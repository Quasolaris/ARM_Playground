#!/bin/bash


build_mode=$1

asm_file=$2
asm_binary=$asm_file"_binary"


if [[ $build_mode = "-b" ]]; then

	echo "Building Binary"
	as -o "$asm_file.o" $asm_file && ld -o $asm_binary "$asm_file.o"
	rm "$asm_file.o"

elif [[ $build_mode = "-bod" ]]; then

	echo "Building Binary and showing object dump"
	as --gstabs+ -o "$asm_file.o" $asm_file && ld -o $asm_binary "$asm_file.o"

	echo "

	=========== START DUMP

	"

	objdump -s -d "$asm_file.o"
	
	echo "

	=========== END DUMP

	"

	rm "$asm_file.o"

elif [[ $build_mode = "-br" ]]; then

	echo "Building Binary and running it"
	as --gstabs+ -o "$asm_file.o" $asm_file && ld -o $asm_binary "$asm_file.o"
	rm "$asm_file.o"

	echo "

	=========== START PROGRAM

	"

	./$asm_binary
	
	echo "

	=========== END PROGRAM

	"

elif [[ $build_mode = "-bd" ]]; then

	echo "Building Binary with debugg information"
	as --gstabs+ -o "$asm_file.o" $asm_file && ld -o $asm_binary "$asm_file.o"
	rm "$asm_file.o"

elif [[ $build_mode = "-bdr" ]]; then

	echo "Building Binary with debugg information an daterting debugger"
	as --gstabs+ -o "$asm_file.o" $asm_file && ld -o $asm_binary "$asm_file.o"
	rm "$asm_file.o"
	gdb $asm_binary -tui -ex "layout regs"

else
	echo "==================[FLAGS]==================
	-b		{.s file} 	Build binary
	-bod		{.s file} 	Build binary and show object dump
	-br		{.s file} 	Build binary and run it
	-bd		{.s file} 	Build binary with debuggung information
	-bdr		{.s file} 	Build binary and start debugger"
fi




