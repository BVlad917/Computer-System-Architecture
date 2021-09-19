bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; 15) Given an array S of doublewords, build the array of bytes D formed from bytes of
; doublewords sorted as unsigned numbers in descending order.                          
; Example:
;       s DD 12345607h, 1A2B3C15h
;       d DB 56h, 3Ch, 34h, 2Bh, 1Ah, 15h, 12h, 07h
     
segment data use32 class=data
    s dd 12345607h, 1A2B3C15h
    length_of_d equ $-s
    d resb length_of_d


segment code use32 class=code
    start:
        mov esi, 0 ;index used to iterate through S
        mov edi, 0 ;index used to iterate through D
        
        ;copy every byte from S into D
        for_every_element_of_s:
            mov al, [s + esi]
            mov [d + edi], al
            
            inc edi
            inc esi
            cmp esi, length_of_d
        jb for_every_element_of_s
        
        
        ; We will use a simple Selection Sort algorithm
        ; Equivalent C code:
        
        ; for (int i = 0; i < n - 1; i++) {
            ; for (int j = i + 1; j < n; j++) {
                ; if (a[j] > a[i]) {
                    ; swap(a[i], a[j]);
                ; }
            ; }
        ; }
        
        ; What this algorithm does is it finds the maximum element out of every string
        ; [S + i] and moves this maximum at position i in S. This way, at the end all
        ; elements will be sorted in decreasing order
        
        mov esi, 0 ;index used to iterate through all btyes of D except last one
        for_every_element_of_d_except_last:
            
            mov edi, esi ; EDI - index used to iterate through all the bytes to the right of the current byte
            inc edi
            
            for_every_element_of_d_plus_a_constant:
                ; Get the current bytes and compare them
                mov al, [d + esi]
                mov bl, [d + edi]
                
                cmp bl, al
                jbe ignore
                    ; If we get here that means we have found a byte that is greater
                    ; than the current byte, so we need to swap
                    mov [d + esi], bl
                    mov [d + edi], al
                ignore:
                    ; If the byte to the left of the current byte is smaller
                    ; or equal to the current byte => just ignore it
                
                ; Increase EDI so we can find the maximum byte out of the string [S+ESI]
                inc edi
                cmp edi, length_of_d
            jb for_every_element_of_d_plus_a_constant
            
            ; Increase ESI up to (and excluding) length_of_d - 1; we don't need to let the program run for
            ; ESI = length_of_d - 1 since the second for loop would take EDI out of bounds and that would take a 
            ; byte of 00h from memory
            inc esi
            cmp esi, length_of_d - 1
        jb for_every_element_of_d_except_last
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
