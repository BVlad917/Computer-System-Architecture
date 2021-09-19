bits 32

global start        

extern exit, conversie, verificareMAC, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    read_format db "%s", 0
    sum_output db "; The sum modulo 6 is %d", 10, 0
    current_address resb 54
    current_sum dd 0
    sir1 resb 1001
    
segment code use32 class=code
    start:
        ; Read the string from the keyboard
        push dword sir1
        push dword read_format
        call [scanf]
        add esp, 2 * 4
        
        ; We'll use ESI to iterate through the string read from the keyboard
        mov esi, 0
        ; We'll use EDI to save each potential MAC address
        mov edi, 0
        
        .for_every_char_in_sir1:
            cmp byte [sir1 + esi], ','
            jne .save_char
                ; If we get here, it means that the current character is a comma. We check the address built
                ; so far, reset EDI and go to the next (potential) address
                mov byte [current_address + edi], 0
                
                ; Now we use <verificareMAC> to see if the address built so far is indeed a MAC address
                push current_address
                call verificareMAC
                add esp, 1 * 4
                
                cmp eax, 1
                jne .not_mac_address
                    ; If we get here, then the string is indeed a MAC address
                    ; First, we print the MAC address
                    push current_address
                    push read_format
                    call [printf]
                    add esp, 2 * 4
                
                    ; Now we need the sum of the bytes modulo 6
                    ; We have to convert 6 bytes
                    ; First byte conversion
                    push dword 2
                    push dword current_address
                    call conversie
                    add esp, 2 * 4
                    add dword [current_sum], eax
                    
                    ; Second byte conversion
                    push dword 2
                    push dword current_address + 3
                    call conversie
                    add esp, 2 * 4
                    add dword [current_sum], eax
                    
                    ; Third byte conversion
                    push dword 2
                    push dword current_address + 6
                    call conversie
                    add esp, 2 * 4
                    add dword [current_sum], eax
                    
                    ; Forth byte conversion
                    push dword 2
                    push dword current_address + 9
                    call conversie
                    add esp, 2 * 4
                    add dword [current_sum], eax
                    
                    ; Fifth byte conversion
                    push dword 2
                    push dword current_address + 12
                    call conversie
                    add esp, 2 * 4
                    add dword [current_sum], eax
                    
                    ; Sixth byte conversion
                    push dword 2
                    push dword current_address + 15
                    call conversie
                    add esp, 2 * 4
                    add dword [current_sum], eax
                    
                    ; Subtract 6 from the sum until it's < 6
                    .while_not_under_six:
                        cmp dword [current_sum], 6
                        jb .print_sum
                        sub dword [current_sum], 6
                    jmp .while_not_under_six

                    .print_sum:
                    push dword [current_sum]
                    push sum_output
                    call [printf]
                    add esp, 2 * 4
                        
                .not_mac_address:
                    ; If we get here, then the string is NOT a MAC address
                    
                .reset_edi:
                ; After we're done working with the current address, we reset the index EDI and go to the next address
                mov edi, 0
                mov dword [current_sum], 0
                jmp .new_beginning
            
            .save_char:
                ; If we get here, it means that the current character is NOT a comma and we need to save it
                mov al, byte [sir1 + esi]
                mov byte [current_address + edi], al
                inc edi
        
            .new_beginning:
            ; We increase the index and if we haven't yet reached the end we continue. Otherwise we exit the loop
            inc esi
            cmp byte [sir1 + esi], 0
        jne .for_every_char_in_sir1
        
        push    dword 0
        call    [exit]
