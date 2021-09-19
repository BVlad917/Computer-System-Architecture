bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions


; Exercise 1
; Simple Exercises
; 25) 64*4 = ?

segment data use32 class=data
    a db 64; a = 64, byte
    b db 4; b = 4, byte

; our code starts here
segment code use32 class=code
    start:
        
		mov eax, 0; clear eax
		
        mov al, [a]; AL = a = 64
        mul byte [b]; AX = AL * b = a * b = 64 * 4 = 256
        
        ; EAX now contains the correct answer
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
