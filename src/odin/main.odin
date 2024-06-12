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
		replace: for i, t in OUTPUT_TABLE {
			if ch == i {
				c = utf8.rune_at_pos(INPUT_TABLE, t)
				break replace
			}
		}
		strings.write_rune(&str, c)
	}
	return strings.to_string(str)
}

usage :: proc() {
	fmt.printf("Usage: rot13: [options] [files]\n options: -h, --help: Print this help message\n")
}

main :: proc() {
	arg_len := len(os.args)
	for arg in os.args {
		if arg == "-h" || arg == "--hh" {
			usage()
			return
		}
	}

	if arg_len >= 1 {
		data, ok := os.read_entire_file(os.stdin, context.allocator)
		if ok {
			fmt.print(rot13(string(data)))
			return
		}
		defer delete(data, context.allocator)
	}

	for arg in os.args[1:] {
		if os.is_dir(arg) {
			fmt.printfln("rot: %s: Is a directory", arg)
			continue
		}
		data, ok := os.read_entire_file(arg, context.allocator)
		if !ok {
			// could not read file
			fmt.printfln("rot: couldn't read file: %s", arg)
			return
		}
		defer delete(data, context.allocator)
		fmt.print(rot13(string(data)))
	}

	if arg_len <= 1 {
		usage()
		return
	}
}
