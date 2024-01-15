package ansi

import "fmt"

// Cursor
const (
	MoveHome      = "\033[H"
	MoveLineStart = "\033[0G"
)

func MoveUp(n int) string {
	return fmt.Sprintf("\033[%dA", n)
}

func MoveDown(n int) string {
	return fmt.Sprintf("\033[%dB", n)
}

func MoveRight(n int) string {
	return fmt.Sprintf("\033[%dC", n)
}

func MoveLeft(n int) string {
	return fmt.Sprintf("\033[%dD", n)
}

// Erase
const (
	EraseScreen                 = "\033[2J"
	EraseFromCusrsorToEndOfLine = "\033[K"
)

// Colors
const (
	StyleReset   = "\033[0m"
	StyleDim     = "\033[2m"
	StyleInverse = "\033[7m"

	FgBlack   = "\033[30m"
	FgWhite   = "\033[37m"
	FgDefault = "\033[39m"

	BgBlack   = "\033[40m"
	BgWhite   = "\033[47m"
	BgDefault = "\033[49m"
)
