bits 32

global start        

extern exit, change_char
import exit msvcrt.dll

segment data use32 class=data
    s1 db "ANA,ARE,MERE,EU,NU,MAI,AM"
    s2 db "---,^--,^---.--,^-,^^^,--"
    len equ ($ - s2)
    s3 resb len
    
segment code use32 class=code
    start:
        ; We'll use ESI as an index to iterate through the strings s1 and s2
        mov esi, 0
        ; We'll pass the characters through AL so we need to clear EAX
        mov eax, 0
        
        .for_every_byte_in_s1_and_s2:
            ; Apply <change_char> to every pair of chars from the 2 strings s1 and s2 (along with the index) (ONLY IF WE ARE NOT AT A COMMA)
            cmp byte [s1 + esi], ','
            je .comma
                ; If we get here, it means that we are currently NOT at a comma in the 2 strings s1 and s2
                ; Push the parameters on the stack: the current index, the operation (from s2), and the character (from s1)
                push esi
                mov al, [s2 + esi]
                push eax
                mov al, [s1 + esi]
                push eax
                call change_char
                add esp, 3 * 4
                jmp .save_char
            
            .comma:
                ; If we get here, it means that we are currently iterating over a comma in the 2 strings s1 and s2
                mov al, byte ','
            
            .save_char:
            ; Now we have in AL the character that the procedure <change_char> outputs
            mov [s3 + esi], al
                
            inc esi
            cmp esi, len
        jb .for_every_byte_in_s1_and_s2
        
        push    dword 0
        call    [exit]
