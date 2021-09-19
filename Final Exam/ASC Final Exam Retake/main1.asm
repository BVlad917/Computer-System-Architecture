bits 32

global start        

extern exit, changeChar, printf
import exit msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    s1 db "ana,are,mere,eu,nu,mai,am"
    s2 db "---,&--,&---,--,&-,&&&,--"
    len equ ($ - s2)    ; The length of the 2 strings
    s3 resb len
    vocab resb 26   ; Vector of letter frequencies
    max_freq db 0
    max_freq_letter db 'a' - 1
    output_msg db "The most frequent letter is %c with %d appeareances.", 0
    
segment code use32 class=code
    start:    
        ; We'll ESI as an index to iterate through the 2 strings
        mov esi, 0
        ; We'll use EAX to push bytes on the stack, so we need to clear it
        mov eax, 0
        
        .for_every_char_in_s1_and_s2:
            ; At each step of the for loop push the current character, the current operator, and the current index on the stack
            ; and call the <changeChar> procedure. BUT, if the 2 chars from s1 and s2 are a comma (,) then we have to skip this step (we'll simply add a comma)
            cmp byte [s1 + esi], ','
            jne .not_comma
                ; If we get here, it means that the current chars from s1 and s2 are commas, so we need to save a comma to s3
                mov al, byte ','
                jmp .skip_change_char
            
            .not_comma:
                ; Push the index
                push esi
                ; Push the current op
                mov al, byte [s2 + esi]
                push eax
                ; Push the current character
                mov al, byte [s1 + esi]
                push eax
                call changeChar
                add esp, 3 * 4
            
            .skip_change_char:
            ; Now we have the character we need to save in s3 in AL
            mov byte [s3 + esi], al
            
            ; Increase the index ESI and if we reached the end of the 2 strings then exit the loop
            inc esi
            cmp esi, len
        jb .for_every_char_in_s1_and_s2
        
        
        ; Now we need to determine the character with the most appearances in s3
        ; Again, we'll use ESI as index to iterate through s3
        mov esi, 0
        .for_every_char_in_s3:
            ; At each char from s3 that it NOT a comma, increase its frequency from the frequencies vector
            mov al, [s3 + esi]
            cmp al, ','
            je .skip
                ; If we get here, it means that the current character is NOT a comma, so we have to increase a frequency
                sub al, 'a'
                inc byte [vocab + eax]
                mov al, byte [vocab + eax]
                cmp al, byte [max_freq]
                jb .dont_change
                    ; If we get here, it means that the frequency of the current char from s3 is at least equal to the maximum frequency
                    ja .change_directly
                        ; If we get here, it means that the current frequency is equal to the maximum frequency so we need to check if the current
                        ; letter has a higher ASCII code
                        ; Get the ASCII code of the current character in BL
                        mov bl, [s3 + esi]
                        ; If the ASCII code of the current character is greater than the ASCII code of the maximum frequency letter,
                        ; change the maximum frequency letter; Don't do anything otherwise
                        cmp bl, byte [max_freq_letter]
                        ja .change_directly
                        jmp .dont_change
                    
                    .change_directly:
                        ; If we get here, it means that the current frequency is greater than the maximum frequency so we need to change
                        ; Save the new (or not necessarily new) maximum frequency
                        mov byte [max_freq], al
                        ; Save the new letter
                        mov al, byte [s3 + esi]
                        mov byte [max_freq_letter], al
                
                .dont_change:
        
            .skip:
            inc esi
            cmp esi, len
        jb .for_every_char_in_s3
        
        ; Print the most frequent letter and the number of its appeareances
        mov al, byte [max_freq]
        push eax
        mov al, byte [max_freq_letter]
        push eax
        push output_msg
        call [printf]
        add esp, 3 * 4
        
        push    dword 0
        call    [exit]
