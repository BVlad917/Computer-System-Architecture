bits 32

global start        

extern exit, high_byte_of_low_word, print_byte_in_base_2
import exit msvcrt.dll

segment data use32 class=data
    ten db 10
    sir1 dd 1245AB36h, 23456789h, 1212F1EEh
    len equ ($ - sir1) / 4
    sir2 resb len
    sir2_len resd 1
    aux_str resb 4
    sir3 resb len * 4
    
segment code use32 class=code
    start:
        ; Using ESI as an index, we'll iterate through the vector of dwords sir1
        mov esi, 0
        
        ; EDI will be the index used to save bytes in sir2
        mov edi, 0
        
        .for_every_dword_in_sir1:
            ; Push the current dword on the stack and call <high_byte_of_low_word>
            push dword [sir1 + esi * 4]
            call high_byte_of_low_word
            add esp, 1 * 4
            
            ; Now we have in AL the high byte of the low word
            cmp al, 0
            jge .not_negative
                ; If we get here, it means that this byte is strictly negative
                mov [sir2 + edi], al
                inc edi
        
            .not_negative:
        
            ; Increase the index ESI and if we reached the end of the vector then exit the loop
            inc esi
            cmp esi, len
        jb .for_every_dword_in_sir1
        
        ; Clear EAX so that we can use it to push the bytes from sir2 on the stack
        mov eax, 0
        
        ; Now we need to print each byte from sir2 in base 2
        ; We'll use ESI as an index to iterate through sir2
        ; Because of the way we used EDI in the previous loop, the lenght of the vector sir2 is in EDI
        mov esi, 0
        mov dword [sir2_len], edi
        .for_every_byte_in_sir2:
            ; Move each byte in EAX, push EAX on the stack and call the function <print_byte_in_base_2>
            mov al, [sir2 + esi]
            push eax
            call print_byte_in_base_2
            add esp, 1 * 4
            
            inc esi
            cmp esi, [sir2_len]
        jb .for_every_byte_in_sir2
        
        
        ; Now we need to create the vector <sir3>
        ; ESI will be used to iterate through sir2
        mov esi, 0
        ; We clear EAX since we will use it to get the digits of each number
        mov eax, 0
        ; EDX will be used to index the vector of chars <sir3>
        mov edx, 0
        
        ; For each byte in the vector <sir2>
        .for_bytes_in_sir2:
        
            ; Get this byte in AL and negate it (so now we have a positive number, since all bytes in <sir2> are already negative)
            mov al, [sir2 + esi]
            neg al
            
            ; EDI will be used as index for <aux_str> to get each digits in decimal of this number, but in reverse since we divide by 10
            mov edi, 0
                
            ; Get the char representation of this byte in the auxilary string <aux_str>
            .while_AL_not_zero:
                div byte [ten]
                add ah, '0'
                mov [aux_str + edi], ah
                inc edi
                
                mov ah, 0
                cmp al, 0
            jne .while_AL_not_zero
            
            ; Save the reverse of <aux_str> in <sir3> (with a dash '-' in front)
            mov byte [sir3 + edx], '-'
            inc edx
            dec edi
            .while_EDI_not_zero:
                mov al, [aux_str + edi]
                dec edi
                mov [sir3 + edx], al
                inc edx
                
                cmp edi, 0
            jge .while_EDI_not_zero
            
            inc esi
            cmp esi, [sir2_len]
        jb .for_bytes_in_sir2
            
        push    dword 0
        call    [exit]
