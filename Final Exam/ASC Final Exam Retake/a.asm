bits 32

global start   

extern exit, procedura_1, procedura_2
import exit msvcrt.dll

segment data use32 class=data
    sir1 dd 0FFFFFFF0h, 0AABBCCDDh, 12343210h, 3h, 0FFFFE000h, 17h, 0AFFEFFE0h
    len equ ($ - sir1) / 4
    sir2 resd len
    sir2_len resd 1
    
segment code use32 class=code
    start:
        ; We'll use ESI as an index to iterate through <sir1>
        mov esi, 0
        ; We'll use EDI as an index to save the mirrored dwords in <sir2>
        mov edi, 0
        
        .for_every_dword_in_sir1:
            ; Put the current dword in EAX for ease of use
            mov eax, [sir1 + esi * 4]
            
            ; First, we check to see if the current dword is negative
            cmp eax, 0
            jge .skip
                ; If we get here, it means that the current dword is indeed negative
                ; Now we check to see if the current dword is a multiple of 16
                ; If the last nibble of the dword is 0 ==> the dword is a multiple of 16
                mov cl, al
                and cl, 0Fh
                cmp cl, 0
                jne .skip
                    ; If we get here, it means that the current dword is both negative AND a multiple of 16
                    ; Now we can call <procedura_1>, which returns the mirrored value of the dword passed as parameter
                    push eax
                    call procedura_1
                    add esp, 1 * 4
                    
                    ; Now we have the mirrored value of the current dword in EAX. We save it in <sir2>
                    mov [sir2 + edi * 4], eax
                    inc edi
            .skip:
            inc esi
            cmp esi, len
        jb .for_every_dword_in_sir1
        
        
        ; Now we have the lenght of <sir2> in EDI. Let's save it in a variable
        mov dword [sir2_len], edi
        
        ; We need to sort the vector <sir2>. We'll use the Selection Sort algorithm
        mov esi, 0
        .for_every_dword_in_sir2:
            ; If we reached the end of the vector, we exit the outer loop
            cmp esi, dword [sir2_len]
            je .exit_outer
            
            ; EDI will be used to take the elements to the right of the element taken by ESI
            mov edi, esi
            inc edi
            
            .second_for_every_dword_in_sir2:
                ; If we reached the end of the vector, we exit the inner loop
                cmp edi, dword [sir2_len]
                je .exit_inner
                
                ; We move the 2 elements that need to be compared (and potentially swapped) in EAX and EBX
                mov eax, dword [sir2 + esi * 4]
                mov ebx, dword [sir2 + edi * 4]
                
                cmp eax, ebx
                jle .dont_swap
                    ; If we get here, it means that EAX > EBX and the elements in <sir2> need to be swapped
                    mov dword [sir2 + esi * 4], ebx
                    mov dword [sir2 + edi * 4], eax
                
                .dont_swap:
                inc edi
            jmp .second_for_every_dword_in_sir2
            
            .exit_inner:
            inc esi
        jmp .for_every_dword_in_sir2
        .exit_outer:
        
        ; Now the elements in the vector <sir2> are sorted in increasing order
        ; We need to print them using <procedura_2>
        ; Once again, we'll use ESI to iterate through the vector <sir2>
        mov esi, 0
        .last_for_every_dword_in_sir2:
            ; Push the current dword on the stack and call <procedura_2>
            push dword [sir2 + esi * 4]
            call procedura_2
            add esp, 1 * 4
            
            inc esi
            cmp esi, dword [sir2_len]
        jb .last_for_every_dword_in_sir2
        
        push    dword 0
        call    [exit]
