package main

import (
	"bytes"
	"fmt"
	"os"
	"unicode/utf8"

	"github.com/tomasruud/dotfiles/bin/todo/ansi"
	"golang.org/x/term"
)

// TodoTTY handles input and output to terminal.
type TodoTTY struct {
	In   *os.File
	Out  *os.File
	Exit chan error

	oldState *term.State
}

func (t *TodoTTY) Start() error {
	oldState, err := term.MakeRaw(int(t.In.Fd()))
	if err != nil {
		return fmt.Errorf("error in tty init: %v", err)
	}
	t.oldState = oldState
	return nil
}

func (t *TodoTTY) Stop() error {
	return term.Restore(int(t.In.Fd()), t.oldState)
}

func (t *TodoTTY) ReadKey() <-chan rune {
	ch := make(chan rune)

	go func() {
		defer close(ch)
		for {
			raw := make([]byte, utf8.UTFMax)
			if _, err := os.Stdin.Read(raw); err != nil {
				continue
			}

			key, _ := utf8.DecodeRune(raw)
			if key == utf8.RuneError {
				continue
			}

			ch <- key
		}
	}()

	return ch
}

func (t *TodoTTY) Size() (w int, h int, err error) {
	w, h, err = term.GetSize(int(t.Out.Fd()))
	return w, h, err
}

func (t *TodoTTY) Draw(s *State) {
	s.Lock()
	defer s.Unlock()

	out := t.render(s)
	_, _ = t.Out.Write(out)

	if s.Mode == ModeExit {
		t.Exit <- nil
	}
}

func (t *TodoTTY) render(s *State) []byte {
	out := bytes.NewBuffer(nil)

	// Clear the screen
	out.WriteString(ansi.MoveHome)
	out.WriteString(ansi.EraseScreen)

	if s.Mode == ModeExit {
		return out.Bytes()
	}

	// Render status line
	out.WriteString(ansi.BgBlack)
	out.WriteString(ansi.FgWhite)
	sf := fmt.Sprintf("%%-%ds%%%ds", s.W/2, s.W-s.W/2)
	_, _ = fmt.Fprintf(out, sf, s.StatusLine.Left, s.StatusLine.Right)
	out.WriteString(ansi.StyleReset)
	out.WriteString(ansi.MoveDown(1))

	// Render items
	for i, item := range s.Items {
		out.WriteString(ansi.MoveLineStart)

		if item.Done {
			out.WriteString(ansi.StyleDim)
			out.WriteString("[x")
		} else {
			out.WriteString("[ ")
		}

		if i == s.Y {
			out.WriteString("> ")
		} else {
			out.WriteString("] ")
		}

		out.WriteString(item.Text)
		out.WriteString(ansi.StyleReset)
		out.WriteString(ansi.MoveDown(1))
	}

	if s.Debug {
		out.WriteString(ansi.MoveHome)
		out.WriteString(ansi.MoveDown(s.H))
		_, _ = fmt.Fprintf(out, "%d", s.Key)
	}

	// Place cursor
	out.WriteString(ansi.MoveHome)
	out.WriteString(ansi.MoveDown(s.Y + 1))
	out.WriteString(ansi.MoveRight(s.X + 4))

	return out.Bytes()
}
