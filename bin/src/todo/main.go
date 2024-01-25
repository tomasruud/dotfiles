package main

import (
	"errors"
	"flag"
	"fmt"
	"os"
	"path"
	"slices"
	"strings"

	"github.com/gdamore/tcell/v2"
	"github.com/mattn/go-runewidth"
)

func main() {
	if err := cmd(os.Args); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v", err)
		os.Exit(1)
	}
}

func cmd(args []string) error {
	defer func() {
		if r := recover(); r != nil {
			fmt.Fprintf(os.Stderr, "Fatal error: %v", r)
		}
	}()

	flag := flag.NewFlagSet(args[0], flag.ExitOnError)

	var (
		fhelp    = flag.Bool("help", false, "print help message")
		fsinit   = flag.Bool("c", false, "")
		finit    = flag.Bool("create", *fsinit, "create a new todo file in current folder")
		fsglobal = flag.Bool("g", false, "")
		fglobal  = flag.Bool("global", *fsglobal, "force global file (if there is a local file)")
		ffname   = flag.String("fname", ".todo.md", "name of generated todo file")
	)

	flag.Usage = func() {
		fmt.Fprintf(os.Stderr, "Usage: %s [OPTIONS]\n\nOptions:\n", args[0])
		flag.PrintDefaults()
	}

	if err := flag.Parse(args[1:]); err != nil {
		return err
	}

	if *fhelp {
		flag.Usage()
		return nil
	}

	fname := *ffname
	if _, err := os.Stat(fname); *fglobal || (errors.Is(err, os.ErrNotExist) && !*finit) {
		// use global todo file
		home, err := os.UserHomeDir()
		if err != nil {
			return err
		}

		fname = path.Join(home, fname)
	}

	file, err := os.OpenFile(fname, os.O_CREATE|os.O_RDWR, 0o644)
	if err != nil {
		return err
	}
	defer file.Close()

	app := &App{
		Store: &FileStore{
			File: file,
		},
	}

	return app.Run()
}

type TodoItem struct {
	Text string
	Done bool
}

type TodoStore interface {
	LoadItems() ([]TodoItem, error)
	SaveItems([]TodoItem) error
}

const (
	ModeNormal string = ""
	ModeInsert string = "insert"
	ModeExit   string = "exit"
)

type App struct {
	Store TodoStore

	screen tcell.Screen
	items  []TodoItem
	state  struct {
		y        int
		x        int
		selected int
		mode     string
		combo    rune
	}
}

func (a *App) Run() error {
	if err := a.init(); err != nil {
		return err
	}
	defer a.screen.Fini()
	defer a.Store.SaveItems(a.items)

	a.draw()

	for {
		ev := a.screen.PollEvent()
		switch ev := ev.(type) {
		case *tcell.EventKey:
			a.handleKey(ev)

			if a.state.mode == ModeExit {
				return nil
			}

			a.draw()

		case *tcell.EventResize:
			a.draw()
		}
	}
}

func (a *App) init() error {
	tcell.SetEncodingFallback(tcell.EncodingFallbackASCII)

	sc, err := tcell.NewScreen()
	if err != nil {
		return err
	}

	if err := sc.Init(); err != nil {
		return err
	}

	a.screen = sc

	a.items, err = a.Store.LoadItems()
	if err != nil {
		return err
	}

	return nil
}

func (a *App) emit(x, y int, style tcell.Style, str string) (rows, cols int) {
	xstart := x
	ystart := y
	for _, c := range str {
		if c == '\n' {
			y++
			x = xstart
			continue
		}

		var comb []rune
		w := runewidth.RuneWidth(c)
		if w == 0 {
			comb = []rune{c}
			c = ' '
			w = 1
		}
		a.screen.SetContent(x, y, c, comb, style)
		x += w
	}
	return y - ystart + 1, x - xstart
}

func (a *App) draw() {
	w, _ := a.screen.Size()
	a.screen.Clear()

	// Render status line
	style := tcell.StyleDefault.Background(tcell.ColorBlack).Foreground(tcell.ColorWhite)

	left := "todo 📋"

	var right string
	switch a.state.mode {
	case ModeInsert:
		right = "INS"
	case ModeNormal:
		right = "NOR"
	}

	status := left + runewidth.FillLeft(right, w-runewidth.StringWidth(left))
	a.emit(0, 0, style, status)

	// Render items
	items := a.items
	if len(items) == 0 {
		items = []TodoItem{{}}
	}

	table := make(map[int]struct {
		done  bool
		lines []string
	}, len(items))

	for i, item := range items {
		all := runewidth.Wrap(item.Text, w-4)

		table[i] = struct {
			done  bool
			lines []string
		}{
			done:  item.Done,
			lines: strings.Split(all, "\n"),
		}
	}

	posY := a.state.statusH
	posX := a.state.checkW
	for i, item := range items {
		style = tcell.StyleDefault
		cstyle := style

		if item.Done {
			style = tcell.StyleDefault.Dim(true)
		}

		if i == a.state.selected {
			cstyle = tcell.StyleDefault.Reverse(true)
		}

		if item.Done {
			a.emit(0, posY, cstyle, "[x")
		} else {
			a.emit(0, posY, cstyle, "[ ")
		}

		if i == a.state.selected {
			a.emit(2, posY, cstyle, ">")
		} else {
			a.emit(2, posY, cstyle, "]")
		}

		if i == a.state.selected {
			// Place cursor
			a.screen.ShowCursor(posX+a.state.x, posY+a.state.y)
		}

		rows, _ := a.emit(posX, posY, style, runewidth.Wrap(item.Text, a.state.listW-posX))
		posY += rows
	}

	a.screen.Show()
}

func (a *App) handleKey(key *tcell.EventKey) {
	switch a.state.mode {
	case ModeNormal:
		combo := a.state.combo != 0
		defer func() {
			if combo {
				// restores combo state after second keystroke
				a.state.combo = 0
			}
		}()

		switch key.Key() {
		case tcell.KeyCtrlC, tcell.KeyCtrlD:
			a.state.mode = ModeExit

		case tcell.KeyCtrlN, tcell.KeyTab:
			if a.state.selected+1 < len(a.items) {
				a.state.selected++
			}

		case tcell.KeyCtrlP, tcell.KeyBacktab:
			if a.state.selected-1 >= 0 {
				a.state.selected--
			}

		case tcell.KeyRune:
			switch key.Rune() {
			case 'q':
				if a.state.combo == 0 {
					a.state.combo = 'q'
					return
				}

				if a.state.combo == 'q' {
					a.state.mode = ModeExit
				}

			case 't':
				a.items[a.state.selected].Done = !a.items[a.state.selected].Done

			case 'h':
				if a.state.x-1 >= 0 {
					a.state.x--
				}

			case 'j':
				if a.state.y+1 < len(a.items) {
					a.state.y++

					if a.state.x >= runewidth.StringWidth(a.items[a.state.y].Text) {
						a.state.x = runewidth.StringWidth(a.items[a.state.y].Text)
					}
				}

			case 'k':
				if a.state.y-1 >= 0 {
					a.state.y--

					if a.state.x >= runewidth.StringWidth(a.items[a.state.y].Text) {
						a.state.x = runewidth.StringWidth(a.items[a.state.y].Text)
					}
				}

			case 'l':
				if a.state.x+1 <= runewidth.StringWidth(a.items[a.state.y].Text) {
					a.state.x++
				}

			case 'o':
				a.state.mode = ModeInsert

				a.items = slices.Insert(a.items, a.state.y+1, TodoItem{})
				a.state.y = a.state.y + 1
				a.state.x = 0

			case 'O':
				a.state.mode = ModeInsert

				a.items = slices.Insert(a.items, a.state.y, TodoItem{})
				a.state.x = 0

			case 'i':
				a.state.mode = ModeInsert

			case 'a':
				a.state.mode = ModeInsert
				if a.state.x+1 <= runewidth.StringWidth(a.items[a.state.y].Text) {
					a.state.x++
				}

			case 'A':
				a.state.mode = ModeInsert
				a.state.x = runewidth.StringWidth(a.items[a.state.y].Text)

			case 'd':
				if a.state.x >= runewidth.StringWidth(a.items[a.state.y].Text) {
					return
				}

				a.items[a.state.y].Text = utf8Remove(a.items[a.state.y].Text, a.state.x)
			}
		}

	case ModeInsert:
		switch key.Key() {
		case tcell.KeyEsc:
			a.state.mode = ModeNormal

		case tcell.KeyBackspace, tcell.KeyBackspace2:
			if a.state.x < 1 {
				if a.state.y < 1 {
					return
				}

				// stitch lines together
				a.state.x = runewidth.StringWidth(a.items[a.state.y-1].Text)
				a.items[a.state.y-1].Text += a.items[a.state.y].Text

				if a.state.y < len(a.items) {
					a.items = append(a.items[0:a.state.y], a.items[a.state.y+1:]...)
				} else {
					a.items = a.items[0:a.state.y]
				}

				a.state.y--
				a.state.selected--
				return
			}

			a.items[a.state.y].Text = utf8Remove(a.items[a.state.y].Text, a.state.x-1)
			a.state.x--

		case tcell.KeyEnter:
			a.state.mode = ModeInsert

			a.items = slices.Insert(a.items, a.state.y+1, TodoItem{})
			a.state.y = a.state.y + 1
			a.state.x = 0

		case tcell.KeyRune:
			a.items[a.state.y].Text = utf8Write(a.items[a.state.y].Text, key.Rune(), a.state.x)
			a.state.x++
		}
	}
}
