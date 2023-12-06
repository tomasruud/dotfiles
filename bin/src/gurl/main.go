package main

import (
	"fmt"
	"io"
	"os"
	"os/exec"
	"runtime"
	"strings"
)

func main() {
	in, err := io.ReadAll(os.Stdin)
	if err != nil {
		fmt.Fprintf(os.Stderr, "<!> gurl could not read stdin: %v\n", err)
		fmt.Print(string(in))
		os.Exit(1)
	}

	url, err := parseURL(string(in))
	if err != nil {
		fmt.Fprintf(os.Stderr, "<!> gurl could not parse url: %v\n", err)
		fmt.Print(string(in))
		os.Exit(1)
	}

	if url == "" {
		fmt.Fprintln(os.Stderr, "<!> gurl did not find a url")
		fmt.Print(string(in))
		os.Exit(0)
	}

	if err := open(url); err != nil {
		fmt.Fprintf(os.Stderr, "<!> gurl could not open browser: %v\n", err)
		fmt.Print(string(in))
		os.Exit(1)
	}

	fmt.Print(string(in))
	os.Exit(0)
}

func parseURL(str string) (string, error) {
	for _, tok := range strings.Fields(str) {
		if strings.HasPrefix(tok, "https://") {
			return tok, nil
		}
	}
	return "", nil
}

func open(url string) error {
	switch runtime.GOOS {
	case "darwin":
		return exec.Command("open", url).Start()
	}
	return fmt.Errorf("unsupported platform %q", runtime.GOOS)
}
