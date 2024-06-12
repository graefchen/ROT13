#!/bin/bash

# TODO: Make running.

./build.sh

cat ./text/emily_dickinson_im_nobody.txt | ./bin/rot.exe

cat ./text/test/emily_dickinson_im_nobody.txt | ./bin/rot.exe

./bin/rot.exe ./text/emily_dickinson_im_nobody.txt ./text/test/emily_dickinson_im_nobody.txt