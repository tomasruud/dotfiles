package main

import (
	"bytes"
	"fmt"

	"github.com/tomasruud/dotfiles/bin/todo/ansi"
)

func renderTUI(s State) []byte {
	out := bytes.NewBuffer(nil)

	// Clear the screen
	out.WriteString(ansi.MoveHome)
	out.WriteString(ansi.EraseScreen)

	if s.mode == modeExit {
		return out.Bytes()
	}

	// Render status line
	out.WriteString(ansi.BgBlack)
	out.WriteString(ansi.FgWhite)
	sf := fmt.Sprintf("%%-%ds%%%ds", s.w/2, s.w-s.w/2)
	fmt.Fprintf(out, sf, s.statusline.left, s.statusline.right)
	out.WriteString(ansi.StyleReset)
	out.WriteString(ansi.MoveDown(1))

	// Render items
	for i, item := range s.items {
		out.WriteString(ansi.MoveLineStart)

		if item.done {
			out.WriteString(ansi.StyleDim)
			out.WriteString("[x")
		} else {
			out.WriteString("[ ")
		}

		if i == s.y {
			out.WriteString("> ")
		} else {
			out.WriteString("] ")
		}

		out.WriteString(item.text)
		out.WriteString(ansi.StyleReset)
		out.WriteString(ansi.MoveDown(1))
	}

	if s.debug {
		out.WriteString(ansi.MoveHome)
		out.WriteString(ansi.MoveDown(s.h))
		fmt.Fprintf(out, "%d", s.key)
	}

	// Place cursor
	out.WriteString(ansi.MoveHome)
	out.WriteString(ansi.MoveDown(s.y + 1))
	out.WriteString(ansi.MoveRight(s.x + 4))

	return out.Bytes()
}

func renderMD(s State) []byte {
	out := bytes.NewBuffer(nil)

	for _, item := range s.items {
		if item.done {
			out.WriteString("- [x] ")
		} else {
			out.WriteString("- [ ] ")
		}

		out.WriteString(item.text)
		out.WriteRune('\n')
	}

	return out.Bytes()
}
