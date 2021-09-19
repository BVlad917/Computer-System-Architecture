bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; Given an array S of doublewords, build the array of bytes D formed from bytes of doublewords sorted
; as unsigned numbers in descending order.
; Example:
;       s DD 12345607h, 1A2B3C15h
;       d DB 56h, 3Ch, 34h, 2Bh, 1Ah, 15h, 12h, 07h                          
                          
segment data use32 class=data
    s dd 12345607h, 1A2B3C15h
    length_of_s equ $-s
    d resb length_of_s

segment code use32 class=code
    start:
        mov esi, s
        mov edi, d
        mov edx, 0
        cld
        
        for_every_element_of_s:
            movsb
        
            inc edx
            cmp edx, length_of_s
        jb for_every_element_of_s
        
        mov esi, s
        for_every_element_of_d_except_last:
        
        
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
