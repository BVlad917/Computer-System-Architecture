bits 32

global changeChar

segment data use32 class=data
    operation resb 1
    letter resb 1
    number resb 1
    
segment code use32 class=code
    changeChar:
        mov eax, [esp + 4]
        mov [letter], al
        
        mov eax, [esp + 8]
        mov [operation], al
        
        mov eax, [esp + 12]
        mov [number], al
        
        mov eax, 0
        
        cmp byte [operation], '-'
        jne .and_operator
            ; If we get here, it means we have a '-' operator
            mov al, [number]
            sub [letter], al
            cmp byte [letter], 'a'
            jae .good_char
                ; If we get here, it means we need to get the circular letter
                mov al, [letter]
                neg al
                add al, byte 'a'
                sub al, 1
                neg al
                add al, byte 'z'
                ; With the above set of instructions, we get the character needed in circular fashion
                
                jmp .end_procedure
                
            .good_char:
                mov al, byte [letter]
                jmp .end_procedure
            
        .and_operator:
            mov al, byte [letter]
            mov cl, byte [number]
            and al, cl
            add al, 'a'
    
        .end_procedure:
            ret