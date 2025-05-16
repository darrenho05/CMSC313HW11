section .data
    inputBuf db  0x83,0x6A,0x88,0xDE,0x9A,0xC3,0x54,0x9A
    length equ 8                     ; defines a constant int length as 8
    space equ ' '                    ; defines a constant string space as ' '
section .bss
    outputBuf resb 80                ; reserves 80 bytes of memory for the output
section .text   
    global _start

_start: 
    mov esi, inputBuf                ; puts the inpuy buffer into esi
    mov edi, outputBuf               ; puts the output buffer into edi
    mov ecx, length                  ; puts the length into ecx

process:
    lodsb                            ; loads the next byte into al

leftByte:
    mov bl, al                       ; copies data from al to bl
    shr bl, 4                        ; moves left 4 bytes to right by shifting right 4
    cmp bl, 9                        ; checks if the bits are less than 9
    jbe convertLeftNumbers           ; if it is less than 9, then it is a number and jump, otherwise continue

convertLeftLetters:                  ; if it is greater than 9, it is a letter
    add bl, 0x37                     ; converts the hex to ascii letters by adding 37 hex
    jmp storeLeftBits                ; jump to store 

convertLeftNumbers:                
    add bl, 0x30                     ; converts the hex to ascii numbers 

storeLeftBits:
    mov [edi], bl                    ; stores the bl byte in the current address of the output
    inc edi                          ; increments the output buffer to the next

rightByte:
    mov bl, al                       ; reset bl to original byte
    and bl, 0x0F                     ; masks off left 4 bits
    cmp bl, 9                        ; repeat the checking, converting, and storing process of the left bits to the right bits
    jbe convertRightNumbers 

convertRightLetters:                 
    add bl, 0x37            
    jmp storeRightBits      

convertRightNumbers:
    add bl, 0x30

storeRightBits:
    mov [edi], bl
    inc edi

putSpace:                            
    mov byte [edi], space            ; after putting the byte into the output, put a space
    inc edi

    loop process                     ; repeat the process for the next byte

endNewLine:
    dec edi                          ; go to the very last space of the output
    mov byte [edi], 0x0A             ; replace that space with a new line
    inc edi			     ; increment the index so it is on the last bit, a new line
	
printResult:
    mov eax, 4                       ; system call 4 for sys_write
    mov ebx, 1                       ; file descriptor 1 for stdout
    mov ecx, outputBuf               ; address of output buffer
    mov edx, edi		     ; move edx to point to end of output buffer
    sub edx, outputBuf		     ; subtract the number of bytes of output buffer from edx to get it to point to beginning of output buffer
    int 0x80			     ; syscall

exit:
    mov eax, 1                       ; system call 1 for sys_exit
    xor ebx, ebx                     ; makes exit code 0
    int 0x80			     ; syscall
