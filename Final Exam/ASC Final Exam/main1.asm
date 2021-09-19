bits 32

global start        

extern exit, printf
import exit msvcrt.dll
import printf msvcrt.dll

extern convert_to_hexa

; 1) An unsigned number a on 32 bits is given. Print the hexadecimal representation of a, but also the results of the circular permutations of its hex digits.

segment data use32 class=data
    a dd 1234
    len dd 0
    converted_string resd 1
    
segment code use32 class=code
    start:
        ; Get the representation of a in hexadecimal
        push dword [a]
        call convert_to_hexa
        add esp, 1 * 4
        
        push eax
        call [printf]
        add esp, 1 * 4
        
        push    dword 0
        call    [exit]
