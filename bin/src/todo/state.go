package main

import (
	"slices"
	"strings"
	"sync"
	"unicode/utf8"
)

type TodoItem struct {
	text string
	done bool
}

type StatusLine struct {
	left  string
	right string
}

type State struct {
	debug bool
	key   rune

	w int
	h int
	y int
	x int

	mode string

	items      []TodoItem
	statusline StatusLine
}

const (
	modeNormal string = "normal"
	modeInsert string = "insert"
	modeExit   string = "exit"
)

func reduce(s State, action string, payload any) State {
	switch action {
	case "window-resized":
		if p, ok := payload.([]int); ok {
			s.w = p[0]
			s.h = p[1]
		}
		return s

	case "key-pressed":
		key, ok := payload.(rune)
		if !ok {
			return s
		}

		s.key = key

		switch s.mode {
		case modeNormal:
			switch key {
			case 'h':
				if s.x-1 >= 0 {
					s.x--
				}
				return s

			case 'j':
				if s.y+1 < len(s.items) {
					s.y++

					if s.x >= utf8.RuneCountInString(s.items[s.y].text) {
						s.x = utf8.RuneCountInString(s.items[s.y].text)
					}
				}
				return s

			case 'k':
				if s.y-1 >= 0 {
					s.y--

					if s.x >= utf8.RuneCountInString(s.items[s.y].text) {
						s.x = utf8.RuneCountInString(s.items[s.y].text)
					}
				}
				return s

			case 'l':
				if s.x+1 <= utf8.RuneCountInString(s.items[s.y].text) {
					s.x++
				}
				return s

			case 9 /*<Tab>*/ :
				s.items[s.y].done = true
				return s

			case ' ':
				s.items[s.y].done = false
				return s

			case 3 /*<C-c>*/, 4 /*<C-d>*/, 'q':
				s.mode = modeExit
				return s

			case 'o':
				s.mode = modeInsert
				s.statusline.right = "INS"

				s.items = slices.Insert(s.items, s.y+1, TodoItem{})
				s.y = s.y + 1
				s.x = 0
				return s

			case 'O':
				s.mode = modeInsert
				s.statusline.right = "INS"

				s.items = slices.Insert(s.items, s.y, TodoItem{})
				s.x = 0
				return s

			case 'i':
				s.mode = modeInsert
				s.statusline.right = "INS"
				return s

			case 'a':
				s.mode = modeInsert
				s.statusline.right = "INS"
				if s.x+1 <= utf8.RuneCountInString(s.items[s.y].text) {
					s.x++
				}
				return s

			case 'A':
				s.mode = modeInsert
				s.statusline.right = "INS"
				s.x = utf8.RuneCountInString(s.items[s.y].text)
				return s

			case 'd':
				if s.x >= utf8.RuneCountInString(s.items[s.y].text) {
					return s
				}

				s.items[s.y].text = utf8Remove(s.items[s.y].text, s.x)
				return s
			}

		case modeInsert:
			if key == 27 /*<Esc>*/ {
				s.mode = modeNormal
				s.statusline.right = "NOR"
				return s
			}

			if key == 127 /*<Bsp>*/ {
				if s.x < 1 {
					if s.y < 1 {
						return s
					}

					// stitch lines together
					s.x = utf8.RuneCountInString(s.items[s.y-1].text)
					s.items[s.y-1].text += s.items[s.y].text

					if s.y < len(s.items) {
						s.items = append(s.items[0:s.y], s.items[s.y+1:]...)
					} else {
						s.items = s.items[0:s.y]
					}

					s.y--
					return s
				}

				s.items[s.y].text = utf8Remove(s.items[s.y].text, s.x-1)
				s.x--
				return s
			}

			if key == 13 /*<Cr>*/ {
				s.mode = modeNormal
				return reduce(s, "key-pressed", 'o') // trigger new line
			}

			s.items[s.y].text = utf8Write(s.items[s.y].text, key, s.x)
			s.x++
			return s
		}
	}

	return s
}

type Store struct {
	state State
	sub   func()

	sync.Mutex
}

func (s *Store) State() State {
	return s.state
}

func (s *Store) Dispatch(action string, payload any) {
	s.Lock()
	defer s.Unlock()

	next := reduce(s.state, action, payload)
	s.state = next

	s.Update()
}

func (s *Store) Update() {
	s.sub()
}

func utf8Write(s string, r rune, i int) string {
	var b strings.Builder
	n := 0
	for ri, rv := range s {
		if n == i {
			b.WriteRune(r)
			b.WriteString(s[ri:])
			return b.String()
		}
		b.WriteRune(rv)
		n++
	}

	b.WriteRune(r)
	return b.String()
}

func utf8Remove(s string, i int) string {
	var b strings.Builder
	n := 0
	for _, r := range s {
		if n == i {
			n++
			continue
		}
		b.WriteRune(r)
		n++
	}

	return b.String()
}
