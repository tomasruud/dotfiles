package main

import "strings"

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
