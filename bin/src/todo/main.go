package main

import (
	"flag"
	"fmt"
	"os"
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

	tty := TodoTTY{
		In:   os.Stdin,
		Out:  os.Stdout,
		Exit: make(chan error),
	}
	if err := tty.Start(); err != nil {
		return err
	}
	defer tty.Stop()

	w, h, err := tty.Size()
	if err != nil {
		return err
	}

	state.W = w
	state.H = h
	state.Debug = debug
	state.Mode = ModeNormal
	state.StatusLine = StatusLine{
		Left:  "[todos]",
		Right: "NOR",
	}

	tty.Draw(state)

	for {
		select {
		case err := <-tty.Exit:
			return err

		case key := <-tty.ReadKey():
			state.HandleKey(key)
			tty.Draw(state)
		}
	}
}
