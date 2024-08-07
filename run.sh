#!/bin/bash

fg_blue='\E[34m'
reset='\E[0m'

# TODO: Make building easier.
function build {
	echo -e "Building the $fg_blue$1$reset executable"
	eval $2 > /dev/null
}

# RUNNING
build "c" "clang -O3 ./src/c/main.c -o bin/c/rot.exe -Wall -Werror -pedantic -fsanitize=address"
# build "dart" "dart compile exe src/dart/main.dart -o bin/dart/rot.exe"
# build "go" "go build -o bin/go/rot.exe src/go/main.go"
# build "haskell" "ghc src/haskell/main.hs -outputdir bin/haskell -o bin/haskell/rot.exe"
# build "odin" "odin build ./src/odin/ -o:aggressive -out:bin/odin/rot.exe"
# build "rust" "rustc ./src/rust/main.rs --o bin/rust/rot.exe -O"

# TODO: Make running.
function testing {
	echo -e "Testing the $fg_blue$1$reset programm"
	# FIX: C just ... doesn't want to work with the command below ...
	# when it is in a bash script(?) ... it seems to follow a similar system
	# like a coin throw -> sometimes it works, sometimes not
	cat ./text/poem.txt | ./bin/$1/rot.exe | ./bin/$1/rot.exe
	# cat ./text/poem.txt.encr | ./bin/$1/rot.exe
	# ./bin/$1/rot.exe ./text/poem.txt.encr
	# echo "Test" | ./bin/$1/rot.exe
	# ./bin/$1/rot.exe
}

# TESTING
testing "c"
# testing "dart"
# testing "go"
# testing "haskell"
# testing "odin"
# testing "rust"