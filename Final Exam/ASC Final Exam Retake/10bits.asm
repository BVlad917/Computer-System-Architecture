bits 32

global start        

extern exit, printf
import exit msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    sir1 dq 12345678h, 0AABBCCDDh, 12345678AABBCCDDh, 2h, 0Dh, 22AA22AA22AAAh
    len equ ($ - sir1) / 8
    max_10_bits_cnt dd 0
    max_10_bits_qw resq 1
    sir_bytes resb 8
    no_bytes resd 1
    print_format db "%x ", 0
    
segment code use32 class=code
    start:   
        ; We'll use ESI as an index to iterate through the string <sir1>
        mov esi, 0
        ; We need to cleare the Carry Flag. We'll need it for counting 1-0 bit pairs
        clc
        .for_every_qword_in_sir1:
            ; We'll modify the string in-memory so we save it in EDX:EAX in case we need to modify <max_10_bits_qw>
            mov eax, [sir1 + esi * 8]
            mov edx, [sir1 + esi * 8 + 4]
        
            ; We'll keep track of the number of 1-0 bit pairs in EDX
            mov edx, 0
        
            ; We'll check every potential pair of consecutive pairs of bits
            mov ecx, 63
            .count_10:
                ; BL will keep track of whether or not the left-most bit is 1
                mov bl, 0
                shl dword [sir1 + esi * 8 + 4], 1
                adc bl, 0
                ; We also have to shift the lower part of the qword and add the left-most bit to the higher part of the qword
                shl dword [sir1 + esi * 8], 1
                adc dword [sir1 + esi * 8 + 4], 0
                
                cmp bl, 1
                jne .next_bit_pair
                    ; If we get here, it means that the current bit in the pair is 1.
                    ; Now we check if the second bit in the pair is 0.
                    ; We don't want to modify the number now since that would mean we couldn't consider the next
                    ; pair. So what we do as a workaround is this: We know we need a 0 in front of the number now,
                    ; so we just check if the number is positive or not, since it would be positive if it'd have a 0 in front
                    cmp dword [sir1 + esi * 8], 0
                    jl .next_bit_pair
                        ; If we get here, it means that the qword is positive (or zero) and that means that the first bit is 0
                        ; So we can count this as a 1-0 bit pair
                        inc edx
                .next_bit_pair:
            loop .count_10
            
            ; We check to see if the number of 1-0 bit pairs is greater than the maximum recorded so far
            cmp edx, dword [max_10_bits_cnt]
            jb .next_qword
                ; If we get here, it means that the current qword has more (or equal) 1-0 bit pairs than the maximum count
                ; recorded so far ==> we need to save this qword and its count
                mov dword [max_10_bits_cnt], edx
                mov dword [max_10_bits_qw], eax
                mov dword [max_10_bits_qw + 8], edx
            
            .next_qword:
            inc esi
            cmp esi, len
        jb .for_every_qword_in_sir1
        
        
        ; Now we need to get the bytes of <max_10_bits_qw> into <sir_bytes>
        mov esi, 7
        ; EDI will be used as index to save the bytes
        mov edi, 0
        
        .while_zero_at_end:
            cmp byte [max_10_bits_qw + esi], 0
            jne .start_saving
                ; If we get here => we still have zeros at the most significant part of the qword
                ; We need to ignore these
                dec esi
        jmp .while_zero_at_end
        
        .start_saving:
            cmp esi, 0
            jl .stop_saving
                ; If we get here, it means that ESI >= 0, so we have to save a byte
                mov al, byte [max_10_bits_qw + esi]
                mov byte [sir_bytes + edi], al
                dec esi
        jmp .start_saving
        
        .stop_saving:
        ; Now we have the number of bytes in EDI
        mov dword [no_bytes], edi
        
        ; We need to sort the string <sir_bytes> in decreasing order
        ; We'll use the Selection Sort algorithm
        
        mov esi, 0
        .for_every_byte_in_sir_bytes:
            cmp esi, dword [no_bytes]
            je .exit_outer
                
            mov edi, esi
            inc edi
                
            .second_for_every_byte_in_sir_bytes:
                cmp edi, dword [no_bytes]
                je .exit_inner
                
                mov al, byte [sir_bytes + esi]
                mov bl, byte [sir_bytes + edi]
                
                cmp al, bl
                jae .dont_swap
                    ; If we get here it means that AL < BL so we need to swap the 2 bytes
                    mov byte [sir_bytes + esi], bl
                    mov byte [sir_bytes + edi], al
            
                .dont_swap:
                inc edi
            jmp .second_for_every_byte_in_sir_bytes
                
            .exit_inner:
            inc esi
        jmp .for_every_byte_in_sir_bytes
        
        .exit_outer:
        ; Now the string <sir_bytes> is sorted, we have to print every byte on the screen
        
        ; We'll use ESI as index to iterate through <sir_bytes>
        mov esi, 0
        ; We'll use EAX to push the bytes on the stack to print them
        mov eax, 0
        
        .last_for_every_byte_in_sir_bytes:
            ; We push the current byte on the stack and call <printf> to print it on the screen as a hexadecimal number
            mov al, [sir_bytes + esi]
            push eax
            push print_format
            call [printf]
            add esp, 2 * 4
            
            inc esi
            cmp esi, dword [no_bytes]
        jb .last_for_every_byte_in_sir_bytes
        
        push    dword 0
        call    [exit]
