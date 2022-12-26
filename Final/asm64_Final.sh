#! /bin/bash
# Simple assemble/link script
# by Benjamin Boden & Derek Park

echo "Starting assembler"
echo " "

if [ -z $1 ]; then
	echo "usge: ./asm64 <asmMainFile> (not extension)"
	exit
fi

if [ ! -e "$1.asm" ]; then
	echo "error, $1.asm not found."
	echo "Note, do not enter file extensions."
	exit
fi

if [ -z $2 ]; then
	echo "usge: ./asm64 <asmMainFile> (not extension)"
	exit
fi

if [ ! -e "$2.asm" ]; then
	echo "error, $1.asm not found."
	echo "Note, do not enter file extensions."
	exit
fi

# compile this:
nasm -gdwarf -felf64 $1.asm -l $1.lst
nasm -gdwarf -felf64 $2.asm -l $2.lst
ld -g -o main $1.o $2.o

echo "assembled & linked successfuly."
echo "exicutible: 'main'"
