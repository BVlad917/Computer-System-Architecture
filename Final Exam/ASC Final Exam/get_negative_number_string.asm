bits 32

global get_negative_number_string

segment data use32 class=data
    number_as_string resb 5
    reverse_string resb 5
    
segment code use32 class=code
    get_negative_number_string:
        ; Move the number we need to convert to string in EAX
        mov eax, [esp + 4]
        
        ; Multiply it by -1 so we ease our job, we'll add a minus sign at the end
        neg al
        
        ; We'll use ECX as an index to save the numbers as characters in the string <number_as_string>
        mov ecx, 0
        
        .while_not_zero:
            ; If the remainder of the previous division is 0, then the conversion is over
            cmp al, 0
            je .conversion_done
        
            ; Convert the current number to its character representation
            mov ah, 0
            mov dl, 10
            div dl
            
            add ah, '0'
            mov [number_as_string + ecx], ah
            inc ecx
            
        jmp .while_not_zero
        .conversion_done:
        
        ; Don't forget to add a minus sign at the end of the string
        mov byte [number_as_string + ecx], '-'
        
        ; Now we need to revert the string
        ; We'll iterate through the string <number_as_string> in reverse order and save every character
        ; in the string <reverse_string>
        mov edx, 0
        .while_still_chars_in_string:
        
            mov al, [number_as_string + ecx]
            mov [reverse_string + edx], al
        
            inc edx
            dec ecx
            cmp ecx, 0
        jge .while_still_chars_in_string
        
        ; Add a NULL terminating character to the final (reversed) string
        mov byte [reverse_string + edx], 0
        
        ; EAX will have the starting address of the given number as a string of characters
        mov eax, reverse_string
        
        ret