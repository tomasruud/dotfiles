package main

import (
	"flag"
	"fmt"
	"os"
	"slices"
	"unicode/utf8"

	"github.com/gdamore/tcell/v2"
)

func main() {
	flag := flag.NewFlagSet("todo", flag.ExitOnError)

	fhelp := flag.Bool("help", false, "print help message")
	fdebug := flag.Bool("debug", false, "toggle debug mode")
	finit := flag.Bool("c", false, "create a new todo file in current folder")
	fglobal := flag.Bool("g", false, "force global file (if there is a local file)")
	ffname := flag.String("fname", ".todo.md", "name of generated todo file")
	fhome := flag.String("home", os.ExpandEnv("$HOME"), "root home folder")

	flag.Usage = func() {
		fmt.Fprintln(os.Stderr, "Usage: todo [OPTIONS]")
		fmt.Fprintln(os.Stderr, "")
		fmt.Fprintln(os.Stderr, "Options:")
		flag.PrintDefaults()
	}

	flag.Parse(os.Args[1:])

	if *fhelp {
		flag.Usage()
		os.Exit(0)
	}

	if err := run(*ffname, *fhome, *fdebug, *finit, *fglobal); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v", err)
		os.Exit(1)
	}
}

func run(fname, home string, debug, init, global bool) error {
	f := TodoFile{
		Init:   init,
		Global: global,
		Name:   fname,
		Home:   home,
	}
	if err := f.Open(); err != nil {
		return err
	}
	defer f.Close()

	state, err := f.CurrentState()
	if err != nil {
		return err
	}

	tcell.SetEncodingFallback(tcell.EncodingFallbackASCII)

	sc, err := tcell.NewScreen()
	if err != nil {
		return err
	}

	if err := sc.Init(); err != nil {
		return err
	}

	state.Mode = ModeNormal
	state.StatusLine = StatusLine{
		Left:  "[todos]",
		Right: "NOR",
	}

	draw(state, sc)

	quit := make(chan struct{})

	go func() {
		for {
			ev := sc.PollEvent()
			switch ev := ev.(type) {
			case *tcell.EventKey:
				handleKey(state, ev)

				if state.Mode == ModeExit {
					close(quit)
					return
				}

				draw(state, sc)

			case *tcell.EventResize:
				draw(state, sc)
			}
		}
	}()

	<-quit

	sc.Fini()

	return nil
}

func draw(s *State, sc tcell.Screen) {
	w, _ := sc.Size()
	sc.Clear()

	// Render status line
	style := tcell.StyleDefault.Background(tcell.ColorBlack).Foreground(tcell.ColorWhite)
	var x int
	for _, c := range s.StatusLine.Left {
		sc.SetContent(x, 0, c, nil, style)
		x++
	}
	for ; x < w-utf8.RuneCountInString(s.StatusLine.Right); x++ {
		sc.SetContent(x, 0, ' ', nil, style)
		x++
	}
	for _, c := range s.StatusLine.Right {
		sc.SetContent(x, 0, c, nil, style)
		x++
	}

	// // Render items
	// for i, item := range s.Items {
	// 	out.WriteString(ansi.MoveLineStart)

	// 	if item.Done {
	// 		out.WriteString(ansi.StyleDim)
	// 		out.WriteString("[x")
	// 	} else {
	// 		out.WriteString("[ ")
	// 	}

	// 	if i == s.Y {
	// 		out.WriteString("> ")
	// 	} else {
	// 		out.WriteString("] ")
	// 	}

	// 	out.WriteString(item.Text)
	// 	out.WriteString(ansi.StyleReset)
	// 	out.WriteString(ansi.MoveDown(1))
	// }

	// // Place cursor
	// out.WriteString(ansi.MoveHome)
	// out.WriteString(ansi.MoveDown(s.Y + 1))
	// out.WriteString(ansi.MoveRight(s.X + 4))

	sc.Show()
}

func handleKey(s *State, key *tcell.EventKey) {
	switch s.Mode {
	case ModeNormal:
		switch key.Key() {
		case tcell.KeyTab:
			s.Items[s.Y].Done = true

		case tcell.KeyCtrlC, tcell.KeyCtrlD:
			s.Mode = ModeExit

		case tcell.KeyRune:
			switch key.Rune() {
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
			case ' ':
				s.Items[s.Y].Done = false

			case 'q':
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
		}

	case ModeInsert:
		switch key.Key() {
		case tcell.KeyEsc:
			s.Mode = ModeNormal
			s.StatusLine.Right = "NOR"

		case tcell.KeyBackspace:
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

		case tcell.KeyEnter:
			s.Mode = ModeInsert
			s.StatusLine.Right = "INS"

			s.Items = slices.Insert(s.Items, s.Y+1, TodoItem{})
			s.Y = s.Y + 1
			s.X = 0

		case tcell.KeyRune:
			s.Items[s.Y].Text = utf8Write(s.Items[s.Y].Text, key.Rune(), s.X)
			s.X++
		}
	}
}
