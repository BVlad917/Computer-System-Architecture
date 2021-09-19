bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions


; 22) Given the doubleword A and the word B, compute the word C as follows:
; the bits 0-4 of C are the invert of the bits 20-24 of A
; the bits 5-8 of C have the value 1
; the bits 9-12 of C are the same as the bits 12-15 of B
; the bits 13-15 of C are the same as the bits 7-9 of A               
                          
segment data use32 class=data
    a dd 10101001110010111101010110011101b
    b dw 1001001010010001b
    c dw 0

; Example 1 (this is the example used above)
; A = 1010 1001 1100 1011 1101 0101 1001 1101
; B = 1001 0010 1001 0001
; C = 011 1001 1111 00011 = 29 667(d)




; Example 2
; A = 0101 0111 0011 0011 0011 0001 1011 1011
; B = 0111 0011 0110 0100
; C = 011 0111 1111 01100 = 28 652(d)

; Example 3
; A = 1001 1100 1010 1010 0010 0101 0101 0001
; B = 1111 0010 0001 0101
; C = 0101 1111 1111 0101 = 24 565(d)


segment code use32 class=code
    start:
        mov ebx, 0; we compute the result in EBX 
        
        mov eax, [a]
        not eax; invert the bits of A
        and eax, 00000001111100000000000000000000b; isolate bits 20-24 of A
        mov cl, 20
        ror eax, cl; rotate 20 positions to the right
        or ebx, eax; bits 0-4 of EBX are now the inverted bits 20-24 of A
        
        or ebx, 0000000000000000000000111100000b; bits 5-8 of EBX are now 1
        
        mov eax, 0
        mov ax, [b]; we'll use b as a dword so we can apply the logical operators
        and eax, 00000000000000001111000000000000b; isolate bits 12-15 of B
        mov cl, 3
        ror eax, cl
        or ebx, eax; bits 9-12 of EBX are now the bits 12-15 of B
        
        mov eax, [a]
        and eax, 00000000000000000000001110000000b; isolate bits 7-9 of A
        mov cl, 6
        rol eax, cl
        or ebx, eax; bits 13-15 of EBX are now the bits 7-9 of A
        
        mov [c], bx; C has the correct result; result can also be checked in BX

        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
