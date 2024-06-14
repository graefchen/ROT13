#!/bin/bash

fg_blue='\E[34m'
reset='\E[0m'

# TODO: Make building easier.
function build {
	echo -e "Building the $fg_blue$1$reset executable"
	eval $2
}

# RUNNING
build "c" "clang -fsanitize=address ./src/c/main.c -o bin/c/rot.exe"
# build "c" "clang ./src/c/main.c -o bin/c/rot.exe"
build "odin" "odin build -sanitize:address -file ./src/odin/ -out:bin/odin/rot.exe"

# TODO: Make running.
function testing {
	echo -e "Testing the $fg_blue$1$reset programm"
	cat ./text/poem.txt | ./bin/$1/rot.exe | ./bin/$1/rot.exe
	# ./bin/$1/rot.exe ./text/poem.txt.encr ./text/ ./bin/c/main.exe
	# echo "" | ./bin/$1/rot.exe
}

# TESTING
testing "c"
testing "odin"