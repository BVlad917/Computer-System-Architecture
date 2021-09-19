bits 32

global verificareMAC

segment data use32 class=data
    
segment code use32 class=code
    verificareMAC:
        ; Save the starting address of the string in EDX
        mov edx, [esp + 4]
        
        ; We save the value of ESI on the stack
        push esi
        
        ; We'll assume that the given string is in MAC address format
        mov eax, 1
        
        ; We'll use ESI as an index to iterate through the string
        mov esi, 0
        .for_every_3_bytes:
            ; For every 3 chars in the string we have the check the following:
            ;   - the first char is either a digit of a letter a-f
            ;   - the second char is -//-
            ;   - the third char is a colon (:)
            
            ; Firstly, we check to see if the string is of the right lenght
            cmp byte [edx + 17], 0
            je .go_on
                ; If we get here, it means that the string is too long ==> not good
                mov eax, 0
                jmp .stop
            
            .go_on:
            ; Now we also check to see if the string is not too short
            cmp byte [edx + 16], 0
            jne .can_start
                ; If we get here it means that the string is too short ==> not good
                mov eax, 0
                jmp .stop
            
            .can_start:
            ; If we get here, it means that the string is of the right size and we can start the checking process
            
            ; We check to see if the first byte is good (a.k.a, is a hexadecimal digit)
            mov cl, byte [edx + esi]
            
            cmp cl, '0'
            jae .maybe_digit
                ; If we get here, it means that the ASCII code of this char is < ASCII code of 0 ==> not good
                mov eax, 0
                jmp .stop
            
            .maybe_digit:
                cmp cl, '9'
                ja .maybe_letter
                    ; If we get here, it means that the current char is for sure a digit ==> good
                    jmp .go_to_second
                    
                .maybe_letter:
                    ; If we get here, it means that the current char is not a digit. We check to see if it's a letter
                    cmp cl, 'a'
                    jae .still_maybe_letter
                        ; If we get here, it means that the current char is not a digit nor a letter a-f ==> not good
                        mov eax, 0
                        jmp .stop
                    
                    .still_maybe_letter:
                        ; If we get here, it means that the ASCII code of the current char is >= 'a'. It might still be a digit
                        cmp cl, 'f'
                        jbe .go_to_second ; If the ASCII code of the current char is also <= 'f', then it is a hexa letter ==> good
                            ; If we get here, it means that the ASCII code of the current char is > 'f' ==> not good
                            mov eax, 0
                            jmp .stop
                
            .go_to_second:
            ; Now we check to see if the second byte is good (a.k.a, is a hexadecimal digit)
            ; It's the same code as the one above
            mov cl, byte [edx + esi + 1]
            
            cmp cl, '0'
            jae .second_maybe_digit
                ; If we get here, it means that the ASCII code of this char is < ASCII code of 0 ==> not good
                mov eax, 0
                jmp .stop
            
            .second_maybe_digit:
                cmp cl, '9'
                ja .second_maybe_letter
                    ; If we get here, it means that the current char is for sure a digit ==> good
                    jmp .go_to_third
                    
                .second_maybe_letter:
                    ; If we get here, it means that the current char is not a digit. We check to see if it's a letter
                    cmp cl, 'a'
                    jae .second_still_maybe_letter
                        ; If we get here, it means that the current char is not a digit nor a letter a-f ==> not good
                        mov eax, 0
                        jmp .stop
                    
                    .second_still_maybe_letter:
                        ; If we get here, it means that the ASCII code of the current char is >= 'a'. It might still be a digit
                        cmp cl, 'f'
                        jbe .go_to_third ; If the ASCII code of the current char is also <= 'f', then it is a hexa letter ==> good
                            ; If we get here, it means that the ASCII code of the current char is > 'f' ==> not good
                            mov eax, 0
                            jmp .stop
                            
            .go_to_third:
            ; Now we check to see if the third byte is good (a.k.a, is a colon). BUT, if we are at the last 2 bytes, we don't need a colon at the end
            cmp esi, 15
            je .stop
            
            ; If we're not at the last 2 bytes, we have to check that we have a colon at the third byte position
            mov cl, byte [edx + esi + 2]
            cmp cl, byte ':'
            je .go_to_next
                ; If we get here, it means that the third byte is not a colon ==> not a good MAC address
                mov eax, 0
                jmp .stop
            
            .go_to_next:
            ; Go to the next 3 bytes in the string
            add esi, 3
            cmp esi, dword 17
        jb .for_every_3_bytes
        
        .stop:
        ; We restore the value of ESI from the stack
        pop esi
        ret