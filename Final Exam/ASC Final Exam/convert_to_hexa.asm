bits 32

global convert_to_hexa

segment data use32 class=data
    string_repr resb 20
    aux resd 1
    hexa_string db "123456789ABCDE", 0
    
segment code use32 class=code
    convert_to_hexa:
        ; Get the number that needs to be converted in EAX
        mov eax, [esp + 4]
        
        ; We'll use ECX as an index for storing hexadecimal characters in the <string_repr> vector
        mov ecx, 0
        
        ; We clear EDX because we need it for arithmetic operations
        mov edx, 0
        
        ; While the number is not zero
        .while_not_zero:
        
            ; Divide it by 16
            mov dx, 16
            div dx
            
            ; Get the converted character remainder in DL
            mov dl, byte [hexa_string + edx]
            
            ; Move this converted character remainder in the corresponding position in the string <string_repr>
            mov byte [string_repr + ecx], dl
            inc ecx
            
            ; If the number in now 0, exit the loop
            cmp eax, 0
        jne .while_not_zero
        
        ; Add a NULL terminating character to the converted string
        mov byte [string_repr + ecx], 0
        
        ; Save the starting address of the string in EAX
        mov eax, string_repr
        
        ; Return
        ret