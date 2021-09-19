bits 32

global conversie

segment data use32 class=data
    str_len resd 1
    
segment code use32 class=code
    conversie:
        ; We need the address of the string, so we store it in EDX
        mov edx, dword [esp + 4]
        
        ; Save the length of the string in a variable
        mov eax, dword [esp + 8]
        mov dword [str_len], eax
        
        ; We'll need ESI, but we follow the CDECL convention, so the value of ESI needs to not change. We save it on the stack
        push esi
        
        ; We'll keep the converted number in EAX
        mov eax, 0
        ; We'll use ESI as an index to iterate through the given string
        mov esi, 0
        
        .for_every_byte_in_str:
            ; First, we'll put the current byte in CL for ease of use
            mov cl, byte [edx + esi]
            
            cmp cl, '9'
            ja .letter
                ; If we get here, it means that the current byte is a number
                sub cl, '0'
                jmp .add_to_eax
            
            .letter:
                ; If we get here, it means that the current byte is a letter
                sub cl, 'a'
                add cl, 10
        
            .add_to_eax:
            ; Now we shift EAX by 4 bits and add the number to it
            shl eax, 4
            add al, cl
        
            ; Increase the index and if we reached the end of the string exit the loop
            inc esi
            cmp esi, dword [str_len]
        jb .for_every_byte_in_str
        
        ; We restore the value of ESI
        pop esi
        ret