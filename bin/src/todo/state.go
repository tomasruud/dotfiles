package main

import (
	"slices"
	"strings"
	"sync"
	"unicode/utf8"
)

type State struct {
	Debug bool
	Key   rune

	W int
	H int
	Y int
	X int

	Mode string

	Items      []TodoItem
	StatusLine StatusLine

	sync.Mutex
}

type TodoItem struct {
	Text string
	Done bool
}

type StatusLine struct {
	Left  string
	Right string
}

const (
	ModeNormal string = "normal"
	ModeInsert string = "insert"
	ModeExit   string = "exit"
)

func (s *State) HandleKey(key rune) {
	s.Lock()
	defer s.Unlock()

	s.Key = key

	switch s.Mode {
	case ModeNormal:
		switch key {
		case 'h':
			if s.X-1 >= 0 {
				s.X--
			}

		case 'j':
			if s.Y+1 < len(s.Items) {
				s.Y++

				if s.X >= utf8.RuneCountInString(s.Items[s.Y].Text) {
					s.X = utf8.RuneCountInString(s.Items[s.Y].Text)
				}
			}

		case 'k':
			if s.Y-1 >= 0 {
				s.Y--

				if s.X >= utf8.RuneCountInString(s.Items[s.Y].Text) {
					s.X = utf8.RuneCountInString(s.Items[s.Y].Text)
				}
			}

		case 'l':
			if s.X+1 <= utf8.RuneCountInString(s.Items[s.Y].Text) {
				s.X++
			}

		case 9 /*<Tab>*/ :
			s.Items[s.Y].Done = true

		case ' ':
			s.Items[s.Y].Done = false

		case 3 /*<C-c>*/, 4 /*<C-d>*/, 'q':
			s.Mode = ModeExit

		case 'o':
			s.Mode = ModeInsert
			s.StatusLine.Right = "INS"

			s.Items = slices.Insert(s.Items, s.Y+1, TodoItem{})
			s.Y = s.Y + 1
			s.X = 0

		case 'O':
			s.Mode = ModeInsert
			s.StatusLine.Right = "INS"

			s.Items = slices.Insert(s.Items, s.Y, TodoItem{})
			s.X = 0

		case 'i':
			s.Mode = ModeInsert
			s.StatusLine.Right = "INS"

		case 'a':
			s.Mode = ModeInsert
			s.StatusLine.Right = "INS"
			if s.X+1 <= utf8.RuneCountInString(s.Items[s.Y].Text) {
				s.X++
			}

		case 'A':
			s.Mode = ModeInsert
			s.StatusLine.Right = "INS"
			s.X = utf8.RuneCountInString(s.Items[s.Y].Text)

		case 'd':
			if s.X >= utf8.RuneCountInString(s.Items[s.Y].Text) {
				return
			}

			s.Items[s.Y].Text = utf8Remove(s.Items[s.Y].Text, s.X)
		}

	case ModeInsert:
		switch key {
		case 27 /*<Esc>*/ :
			s.Mode = ModeNormal
			s.StatusLine.Right = "NOR"

		case 127 /*<Bsp>*/ :
			if s.X < 1 {
				if s.Y < 1 {
					return
				}

				// stitch lines together
				s.X = utf8.RuneCountInString(s.Items[s.Y-1].Text)
				s.Items[s.Y-1].Text += s.Items[s.Y].Text

				if s.Y < len(s.Items) {
					s.Items = append(s.Items[0:s.Y], s.Items[s.Y+1:]...)
				} else {
					s.Items = s.Items[0:s.Y]
				}

				s.Y--
				return
			}

			s.Items[s.Y].Text = utf8Remove(s.Items[s.Y].Text, s.X-1)
			s.X--

		case 13 /*<Cr>*/ :
			s.Mode = ModeInsert
			s.StatusLine.Right = "INS"

			s.Items = slices.Insert(s.Items, s.Y+1, TodoItem{})
			s.Y = s.Y + 1
			s.X = 0

		default:
			s.Items[s.Y].Text = utf8Write(s.Items[s.Y].Text, key, s.X)
			s.X++
		}
	}
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
