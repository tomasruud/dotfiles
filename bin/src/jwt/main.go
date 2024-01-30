package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"os"
	"strings"

	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/term"
)

func main() {
	if err := run(os.Args...); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}

func run(args ...string) error {
	flag := flag.NewFlagSet(args[0], flag.ExitOnError)

	fpretty := flag.Bool("pretty", false, "pretty output")

	if err := flag.Parse(args[1:]); err != nil {
		return err
	}

	var in string
	if !term.IsTerminal(int(os.Stdin.Fd())) {
		stdin, err := io.ReadAll(os.Stdin)
		if err != nil {
			return err
		}
		in = strings.TrimSpace(string(stdin))
	} else {
		in = strings.TrimSpace(flag.Arg(0))
	}

	var claims jwt.MapClaims
	if _, _, err := jwt.NewParser().ParseUnverified(in, &claims); err != nil {
		return err
	}

	marshal := json.Marshal
	if *fpretty {
		marshal = func(v any) ([]byte, error) {
			return json.MarshalIndent(v, "", "  ")
		}
	}

	out, err := marshal(claims)
	if err != nil {
		return err
	}

	fmt.Println(string(out))

	return nil
}
