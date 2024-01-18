package main

import (
	"bytes"
	"errors"
	"io"
	"os"
	"path"
	"strings"
)

type TodoFile struct {
	Global bool
	Init   bool
	Name   string
	Home   string

	file *os.File
}

func (f *TodoFile) Open() error {
	name := f.Name // prefer local
	if _, err := os.Stat(name); f.Global || (errors.Is(err, os.ErrNotExist) && !f.Init) {
		name = path.Join(f.Home, f.Name)
	}

	file, err := os.OpenFile(name, os.O_CREATE|os.O_RDWR, 0o644)
	if err != nil {
		return err
	}

	f.file = file

	return nil
}

func (f *TodoFile) Close() error {
	if err := f.file.Sync(); err != nil {
		return err
	}

	return f.file.Close()
}

func (f *TodoFile) CurrentState() (*State, error) {
	raw, err := io.ReadAll(f.file)
	if err != nil {
		return nil, err
	}

	return unmarshalMarkdown(raw), nil
}

func (f *TodoFile) ReplaceState(s *State) error {
	raw := marshalMarkdown(s)

	if err := f.file.Truncate(0); err != nil {
		return err
	}

	if _, err := f.file.Seek(0, 0); err != nil {
		return err
	}

	if _, err := f.file.Write(raw); err != nil {
		return err
	}

	return nil
}

func unmarshalMarkdown(raw []byte) *State {
	str := string(raw)
	var items []TodoItem
	for _, ln := range strings.Split(str, "\n") {
		if _, ln, ok := strings.Cut(ln, "- [x] "); ok {
			items = append(items, TodoItem{
				Text: ln,
				Done: true,
			})
			continue
		}

		if _, ln, ok := strings.Cut(ln, "- [ ] "); ok {
			items = append(items, TodoItem{
				Text: ln,
				Done: false,
			})
			continue
		}
	}

	if len(items) == 0 {
		items = append(items, TodoItem{})
	}

	return &State{
		Items: items,
	}
}

func marshalMarkdown(s *State) []byte {
	out := bytes.NewBuffer(nil)

	for _, item := range s.Items {
		if item.Done {
			out.WriteString("- [x] ")
		} else {
			out.WriteString("- [ ] ")
		}

		out.WriteString(item.Text)
		out.WriteRune('\n')
	}

	return out.Bytes()
}
