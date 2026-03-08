#!/bin/bash

# elf header
readelf -h ./test

# program headers
objdump -p ./test

# section headers 
objdump -h ./test

# sections
objdump -s ./test

# disassembly 
objdump -d ./test
