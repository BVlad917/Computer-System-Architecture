bits 32

global change_char

segment data use32 class=data
    char resb 1
    op resb 1
    n resb 1
    
segment code use32 class=code
    change_char:
        ; Save the capital letter in a variable
        mov eax, [esp + 4]
        mov byte [char], al
        
        ; Save the operation in a variable
        mov eax, [esp + 8]
        mov byte [op], al
        
        ; Save the number in a variable
        mov eax, [esp + 12]
        mov byte [n], al
        
        cmp byte [op], '^'
        jne .not_xor
            ; If we get here, it means that the operation the procedure needs to perform is XOR (^)
            mov al, byte [char]
            mov bl, byte [n]
            xor al, bl
            jmp .go_to_end
        
        .not_xor:
            ; If we get here, it means that the operation the procedure needs to perform is MINUS (-)
            mov al, byte [n]
            sub byte [char], al
            
            cmp byte [char], 'A'
            jae .not_circular
                ; If we get here, it means that we have to find the corresponding letter in circular fashion
                sub byte [char], 'A'
                inc byte [char]
                add byte [char], 'Z'
            
            .not_circular:
                ; If we get here, it means that we can simply return the letter directly
            mov al, byte [char]
            
        .go_to_end:
        ret