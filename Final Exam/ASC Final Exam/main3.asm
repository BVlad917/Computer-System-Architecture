bits 32

global start        

extern exit
import exit msvcrt.dll

; 3) Two strings containing characters are given. Calculate and display the result of the concatenation of all characters 
; of type decimal number from the second string, and then followed by those from the first string, and vice versa,
; the result of concatenating the characters from the first string after those from the second string.

segment data use32 class=data
    
segment code use32 class=code
    start:
        
        push    dword 0
        call    [exit]
