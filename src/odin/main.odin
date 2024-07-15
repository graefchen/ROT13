package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:unicode/utf8"

INPUT_TABLE := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
OUTPUT_TABLE := "NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm"

rot13 :: proc(s: string) -> string {
	str: strings.Builder
	for ch, i in s {
		c: rune = ch
		replace: for i, t in INPUT_TABLE {
			if ch == i {
				c = utf8.rune_at_pos(OUTPUT_TABLE, t)
				break replace
			}
		}
		strings.write_rune(&str, c)
	}
	return strings.to_string(str)
}

usage :: proc() {
	fmt.fprintf(
		os.stderr,
		"Usage: rot13: [options] [files]\n options: -h, --help: Print this help message\n",
	)
}

main :: proc() {
	arg_len := len(os.args)
	for arg in os.args {
		if arg == "-h" || arg == "--hh" {
			usage()
			os.exit(1)
		}
	}

	if arg_len <= 1 {
		data, ok := os.read_entire_file(os.stdin, context.allocator)
		if ok {
			fmt.fprint(os.stdout, rot13(string(data)))
			return
		}
		defer delete(data, context.allocator)
	}
	if arg_len <= 1 {
		usage()
		os.exit(1)
	}

	for arg in os.args[1:] {
		if os.is_dir(arg) {
			fmt.fprintfln(os.stderr, "rot: %s: Permission denied", arg)
			continue
		}
		data, ok := os.read_entire_file(arg, context.allocator)
		if !ok {
			// could not read file
			fmt.fprintfln(os.stderr, "rot: couldn't read file: %s", arg)
			continue
		}
		defer delete(data, context.allocator)
		fmt.fprint(os.stdout, rot13(string(data)))
	}
}
