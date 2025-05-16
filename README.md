Darren Ho, UMBC 2027
May 15, 2025, 10:03 pm

This program takes a given input of hexadecimals and converts and prints it as ascii characters. 
It prints the ascii characters in sets of two with a space in between each pair. 

I compiled and ran the program using the following commands 
nasm -f elf32 hextoascii.asm -o hextoascii.o
ld -m elf_i386 hextoascii.o -o hextoascii
./hextoascii

the output is:
83 6A 88 DE 9A C3 54 9A
