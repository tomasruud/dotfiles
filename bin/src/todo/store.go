package main

import (
	"bytes"
	"io"
	"os"
	"strings"
)

type FileStore struct {
	File *os.File
}

func (f *FileStore) LoadItems() ([]TodoItem, error) {
	raw, err := io.ReadAll(f.File)
	if err != nil {
		return nil, err
	}

	return unmarshalMarkdown(raw), nil
}

func (f *FileStore) SaveItems(list []TodoItem) error {
	raw := marshalMarkdown(list)

	if err := f.File.Truncate(0); err != nil {
		return err
	}

	if _, err := f.File.Seek(0, 0); err != nil {
		return err
	}

	if _, err := f.File.Write(raw); err != nil {
		return err
	}

	if err := f.File.Sync(); err != nil {
		return err
	}

	return nil
}

func unmarshalMarkdown(raw []byte) []TodoItem {
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

	return items
}

func marshalMarkdown(list []TodoItem) []byte {
	out := bytes.NewBuffer(nil)

	for _, item := range list {
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
