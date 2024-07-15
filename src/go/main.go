package main

import (
	"fmt"
	"io"
	"os"
)

const INPUT_TABLE string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
const OUTPUT_TABLE string = "NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm"

func rot13(s string) string {
	str := ""
	for _, ch := range s {
		c := ch
		for t, i := range INPUT_TABLE {
			if ch == i {
				c = []rune(OUTPUT_TABLE)[t]
				break
			}
		}
		str = str + string(c)
	}
	return str
}

func usage() {
	fmt.Fprintf(os.Stderr, "Usage: rot13: [options] [files]\n options: -h, --help: Print this help message\n")
}

func main() {
	arg_len := len(os.Args)
	for _, arg := range os.Args {
		if arg == "-h" || arg == "--help" {
			usage()
			os.Exit(1)
		}
	}

	if arg_len <= 1 {
		fi, err := os.Stdin.Stat()
		if err != nil {
			panic(err)
		}
		if fi.Mode()&os.ModeNamedPipe != 0 {
			stdin, err := io.ReadAll(os.Stdin)
			if err != nil {
				panic(err)
			}
			str := string(stdin)
			fmt.Fprintf(os.Stdout, rot13(str))
			os.Exit(1)
		} else {
			usage()
			os.Exit(1)
		}
	}

	for i := 1; i < arg_len; i++ {
		arg := os.Args[i]
		fileInfo, err := os.Stat(arg)
		if err != nil {
			panic(err)
		}
		if fileInfo.IsDir() {
			fmt.Fprintf(os.Stderr, "rot: %s: Permission denied\n", arg)
			continue
		}
		buffer, err := os.ReadFile(arg)
		if err != nil {
			fmt.Fprintf(os.Stderr, "rot: couldn't read file: %s\n", arg)
			continue
		}
		str := string(buffer)
		fmt.Fprintf(os.Stdout, rot13(string(str)))
	}

}
