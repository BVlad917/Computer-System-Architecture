bits 32

global start        

extern exit, get_mirrored, print_dword
import exit msvcrt.dll

; bunch of dwords given
; s1 dd FFFFFFF0h, AABBCCDDh, 12343210h, 3h, FFFFE000h, 17h, AFFEFFE0h

; for every dword that is negative and divisible by 16,
; get the mirrored dword of this dword,
; save all of these in a vector,
; sort this vector,
; print all the values of this vector,

; procedura_1: get mirrored dword
; procedura_2: print a dword (or print a list of dwords)

segment data use32 class=data
    s1 dd 0FFFFFFF0h, 0AABBCCDDh, 12343210h, 3h, 0FFFFE000h, 17h, 0AFFEFFE0h
    len equ ($ - s1) / 4
    s2 resd len
    len_of_s2 dd 0
    
; 0FFFFFFF0h, 0FFFFE000h, 0AFFEFFE0h
; ===>>> fffffff, effff, effeffa
; Sorted: effff, effeffa, fffffff
    
segment code use32 class=code
    start:
        ; ESI will be used as index to get all the dwords in s1
        mov esi, 0
        ; EDI will be used as index to iterate through s2, the vector of mirrored dwords
        mov edi, 0
        
        ; We loop over all dwords
        .for_every_dword_in_s1:
        
            ; Put the current dword in EAX
            mov eax, [s1 + esi * 4]
            
            ; Firstly, we check to see if this number if negative
            cmp eax, 0
            jge .skip
                ; If we get here, it means that the current dword is negative
            
                ; If the last digit in hexadecimal representation is 0, then this number is divisible by 16
                mov bl, al
                shl bl, 4
                cmp bl, 0
                jne .skip
                    ; If we get here, it means that the current dword is both negative (by the previous condition) AND a multiple of 16
                    ; Now we need this dword's mirrored value
                    
                    push eax
                    call get_mirrored
                    add esp, 1 * 4
                    ; Now we have in EAX the mirrored value of the initial dword
                    
                    ; Save it in the vector s2
                    mov [s2 + edi * 4], eax
                    inc edi
                    
            .skip:
            
            ; We increase the index ESI and if we reached the end of the vector we exit the loop
            inc esi
            cmp esi, len
        jb .for_every_dword_in_s1
        
        ; Save the length of s2 in a variable
        mov dword [len_of_s2], edi
        
        ; Now we need to sort the vector s2
        ; We will use the Selection Sort algorithm
        
        mov esi, 0
        .for_nums_in_s2_outer:
            cmp esi, dword [len_of_s2]
            jae .stop_outer_loop
        
            mov edi, esi
            inc edi
            .for_nums_in_s2_inner:
                cmp edi, dword [len_of_s2]
                jae .stop_inner_loop
                
                mov eax, [s2 + esi * 4]
                mov ebx, [s2 + edi * 4]
                cmp eax, ebx
                
                jle .dont_swap
                
                    ; If we get here, it means we have to swap the 2 dwords
                    mov dword [s2 + esi * 4], ebx
                    mov dword [s2 + edi * 4], eax
                
                .dont_swap:
                
                inc edi
                jmp .for_nums_in_s2_inner
            
            .stop_inner_loop:
            inc esi
            jmp .for_nums_in_s2_outer
        
        .stop_outer_loop:
        
        
        ; Use ESI to iterate through the sorted vector s2 and print all values from this vector using the procedure <print_dword>
        mov esi, 0
        .for_every_dword_in_s2:
            ; For every dword in s2, push it on the stack and call <print_dword>
            push dword [s2 + esi * 4]
            call print_dword
            add esp, 1 * 4
            
            inc esi
            cmp esi, dword [len_of_s2]
        jb .for_every_dword_in_s2
        
        push    dword 0
        call    [exit]
