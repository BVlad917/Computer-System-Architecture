bits 32

global changeChar

segment data use32 class=data
    char resb 1
    op resb 1
    n resb 1
    
segment code use32 class=code
    changeChar:
        ; Save the character in a variable
        mov eax, [esp + 4]
        mov [char], al
        
        ; Save the operation sign in a variable
        mov eax, [esp + 8]
        mov [op], al

        ; Save the number in a variable
        mov eax, [esp + 12]
        mov [n], al
        
        cmp byte [op], '-'
        jne .and_op
            ; If we get here, it means that the operation is minus '-'
            mov al, byte [n]
            sub byte [char], al
            
            cmp byte [char], 'a'
            jae .not_circular
                ; If we get here, it means that we crossed 'a' and we need the circular letter from 'z' onwards
                sub byte [char], 'a'
                inc byte [char]
                add byte [char], 'z'
            .not_circular:
            jmp .skip_to_end
            
        .and_op:
            ; If we get here, it means that the operation is and '&'
            mov al, byte [char]
            mov cl, byte [n]
            and al, cl
            add al, 'a'
            mov byte [char], al
            
        .skip_to_end:
        ; Now we have in the variable <char> the character we need
        ; We move it in AL and return from the procedure
        mov eax, 0
        mov al, byte [char]
        ret
