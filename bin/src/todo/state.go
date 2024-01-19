package main

import (
	"sync"
)

type State struct {
	Y int
	X int

	Mode string

	Items      []TodoItem
	StatusLine StatusLine

	sync.Mutex
}

type TodoItem struct {
	Text string
	Done bool
}

type StatusLine struct {
	Left  string
	Right string
}

const (
	ModeNormal string = "normal"
	ModeInsert string = "insert"
	ModeExit   string = "exit"
)
