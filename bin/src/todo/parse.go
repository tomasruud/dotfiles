package main

import (
	"strings"
)

func parseItems(raw []byte) []TodoItem {
	str := string(raw)
	var items []TodoItem
	for _, ln := range strings.Split(str, "\n") {
		if _, ln, ok := strings.Cut(ln, "- [x] "); ok {
			items = append(items, TodoItem{
				text: ln,
				done: true,
			})
			continue
		}

		if _, ln, ok := strings.Cut(ln, "- [ ] "); ok {
			items = append(items, TodoItem{
				text: ln,
				done: false,
			})
			continue
		}
	}

	if len(items) == 0 {
		return []TodoItem{{}}
	}

	return items
}
