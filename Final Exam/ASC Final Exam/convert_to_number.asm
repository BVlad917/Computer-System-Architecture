bits 32

global convert_to_number

segment data use32 class=data
    number_string dd 0
    number dd 0
    negative db 0
    
segment code use32 class=code
    convert_to_number:
        ; We have to reset the variable <number> to 0 each time we run the procedure, otherwise
        ; we will use the previous converted number in the current conversion
        mov dword [number], 0
    
        ; Move the starting address of the string to a variable <number_string>
        mov eax, [esp + 4]
        mov dword [number_string], eax
        
        ; If the string starts with a minus sign, remember this in the <negative> bool variable and start
        ; the string conversion from index 1, not from index 0
        mov edx, [number_string]
        cmp byte [edx], '-'
        
        jne .positive
            mov byte [negative], 1
            mov ecx, 1
            jmp .start_conversion
        
        ; On the other hand, if there is no minus sign at the start of the string, we start the conversion from index 0
        .positive:
            mov ecx, 0
            
        .start_conversion:
            ; At each character...
            .while_still_characters:
                
                ; First check if we reached the end of the string
                mov edx, dword [number_string]
                cmp byte [edx + ecx], 0
                je .stop_conversion
        
                ; Multiply the number we have so far by 10, since we are converting from left to right
                mov eax, dword [number]
                mov dx, 10
                mul dx
                mov dword [number], eax
                
                ; Get the current character from the string
                mov eax, 0
                mov edx, dword [number_string]
                mov al, byte [edx + ecx]
                
                ; Subtract the character '0' from it so that we get a number
                sub al, '0'
                
                ; Add this number to the variable <number>
                add dword [number], eax
                
                ; Go to the next character from the string
                inc ecx
            jmp .while_still_characters
            
        .stop_conversion:
        
        ; If the string had a minus in front at the beginning, then negate the number we've found
        mov eax, dword [number]
        cmp byte [negative], 0
        jne .negate_number
        je .keep_positive
        
        .negate_number:
            neg eax
        
        .keep_positive:
        
        ret