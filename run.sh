#!/bin/bash

fg_blue='\E[34m'
reset='\E[0m'

# TODO: Make building easier.
function build {
	echo -e "Building the $fg_blue$1$reset executable"
	eval $2
}

# RUNNING
# build "c" "clang -O3 ./src/c/main.c -o bin/c/rot.exe"
build "go" "go build -o bin/go/rot.exe src/go/main.go"
# build "odin" "odin build ./src/odin/ -o:aggressive -out:bin/odin/rot.exe"
# build "rust" "rustc ./src/rust/main.rs --o bin/rust/rot.exe -O"

# TODO: Make running.
function testing {
	echo -e "Testing the $fg_blue$1$reset programm"
	cat ./text/poem.txt | ./bin/$1/rot.exe | ./bin/$1/rot.exe
	# ./bin/$1/rot.exe ./text/poem.txt.encr
	# echo "Test" | ./bin/$1/rot.exe
}

# TESTING
# testing "c"
testing "go"
# testing "odin"
# testing "rust"