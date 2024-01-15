package main

import (
	"errors"
	"flag"
	"fmt"
	"io"
	"os"
	"unicode/utf8"

	"golang.org/x/term"
)

func main() {
	// cli flags
	flag := flag.NewFlagSet("todo", flag.ExitOnError)

	fhelp := flag.Bool("help", false, "print help message")
	fdebug := flag.Bool("debug", false, "toggle debug mode")
	finit := flag.Bool("c", false, "create a new todo file in current folder")
	fglobal := flag.Bool("g", false, "force global file (if there is a local file)")

	flag.Usage = func() {
		fmt.Fprintln(os.Stderr, "Usage: todo [OPTIONS]")
		fmt.Fprintln(os.Stderr, "")
		fmt.Fprintln(os.Stderr, "Options:")
		flag.PrintDefaults()
	}

	flag.Parse(os.Args[1:])

	// print help
	if *fhelp {
		flag.Usage()
		os.Exit(0)
	}

	// get todo markdown file
	name := os.ExpandEnv("$HOME/.todo.md")
	if _, err := os.Stat("./.todo.md"); (!errors.Is(err, os.ErrNotExist) || *finit) && !*fglobal {
		name = "./.todo.md"
	}

	file, err := os.OpenFile(name, os.O_CREATE|os.O_RDWR, 0o644)
	if err != nil {
		fmt.Printf("Unable to open todo file: %v\n", err)
		os.Exit(1)
	}
	defer file.Close()

	raw, err := io.ReadAll(file)
	if err != nil {
		fmt.Printf("Unable to read todo file: %v\n", err)
		os.Exit(1)
	}

	items := parseItems(raw)

	// prepare stdin
	oldState, err := term.MakeRaw(int(os.Stdin.Fd()))
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error in tty init: %v", err)
		os.Exit(1)
	}
	defer term.Restore(int(os.Stdin.Fd()), oldState)

	w, h, err := term.GetSize(int(os.Stdout.Fd()))
	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to determine screen size: %v", err)
		os.Exit(1)
	}

	// prepare state
	exit := make(chan error)

	st := &Store{
		state: State{
			debug: *fdebug,
			w:     w,
			h:     h,
			mode:  modeNormal,
			items: items,
			statusline: StatusLine{
				left:  "[todos]",
				right: "NOR",
			},
		},
	}

	// render handler
	st.sub = func() {
		out := renderTUI(st.State())
		os.Stdout.Write(out)
		os.Stdout.Sync()

		md := renderMD(st.State())
		file.Truncate(0)
		file.Seek(0, 0)
		file.Write(md)
		file.Sync()

		// allow for clean exists
		if st.State().mode == modeExit {
			exit <- nil
		}
	}

	// handle key input
	go func() {
		for {
			raw := make([]byte, utf8.UTFMax)
			if _, err := os.Stdin.Read(raw); err != nil {
				exit <- fmt.Errorf("could not read key: %v", err)
			}

			key, _ := utf8.DecodeRune(raw)
			if key == utf8.RuneError {
				continue
			}

			st.Dispatch("key-pressed", key)
		}
	}()

	st.Update()

	if err = <-exit; err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v", err)
		os.Exit(1)
	}
}
