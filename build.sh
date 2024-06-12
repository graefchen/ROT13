#!/bin/bash

# TODO: Make building easier.

echo "Building the odin executable"
odin build ./src/odin/ -out:bin/rot.exe
echo "Finished building the odin executable"