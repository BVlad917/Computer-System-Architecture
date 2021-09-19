bits 32

global start        

extern exit, changeChar, printf
import exit msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    s1 db 'ana,are,mere,eu,nu,mai,am'
    s2 db '---,&--,&---,--,&-,&&&,--'
    len equ $ - s2; length of strings s1 and s2
    s3 resb len
    max_app db 0
    max_letter db 'a' - 1
    letter_appears resb 26 ; Vector for vector appearences counting
    output_format db "Max letter is %c with %d frequency", 0
    
segment code use32 class=code
    start:
        mov esi, 0
        .for_every_byte_in_s1_and_s2:
            cmp byte [s1 + esi], ','
            je .skip_comma
                ; If we get there => we don't have a comma at the current char in s1 and s2
                
                push dword esi
                mov eax, 0
                mov al, [s2 + esi]
                push eax
                mov al, [s1 + esi]
                push eax
                call changeChar
                add esp, 3 * 4
                
                mov [s3 + esi], al
                jmp .increase_index
                
            .skip_comma:
                mov [s3 + esi], byte ','
            
            .increase_index:
                inc esi
                cmp esi, len
        jb .for_every_byte_in_s1_and_s2
        
        ; Now we have the string s3
        
        mov esi, 0
        mov eax, 0
        .for_every_byte_in_s3:
            mov al, [s3 + esi]
            cmp al, ','
            
            je .dont_count
                ; If we get here => we have a letter so we need to increase a count
                sub al, 'a'
                inc byte [letter_appears + eax]
                
                mov byte bl, [letter_appears + eax]
                cmp bl, [max_app]
                
                jb .no_new_letter
                ja .new_letter
                    ; If we get here => the current count is equal to the max count so we need to check if the character is higher in ASCII code
                    
                    mov cl, [s3 + esi]
                    cmp cl, [max_letter]
                    jbe .no_new_letter
                    ja .new_letter
                    
                .new_letter:
                    mov cl, [s3 + esi]
                    mov [max_letter], cl
                    mov [max_app], bl
                
                .no_new_letter:
                ; Nothing to do here
                
            .dont_count:
                ; We get here if we're at a comma (',')
                ; Nothing to do here
                
            inc esi
            cmp esi, len
        jb .for_every_byte_in_s3
        
        ; Now we have the letter with maximum frequency in <max_letter> and its frequency in <max_app>
        
        mov eax, 0
        mov al, [max_app]
        push eax
        
        mov al, [max_letter]
        push eax
        
        push output_format
        call [printf]
        add esp, 3 * 4
        
        push    dword 0
        call    [exit]
