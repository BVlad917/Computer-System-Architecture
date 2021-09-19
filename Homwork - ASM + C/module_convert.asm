bits 32

global _asmConvert

; using the CDECL convention, it is assumed the the registers EBX, ESI, EDI, EBP and ESP
; do not modify their value during the function call;

; EAX, ECX, EDX can be modified by a function call

segment data public data use32
    s1_address dd 0
    alphabet_address dd 0
    s2_address dd 0

segment code public code use32
_asmConvert:
    ; Create the stack frame for the program
    push ebp
    mov ebp, esp
    
    ; Move the starting address of s1 into a variable
    mov eax, [ebp + 8]
    mov [s1_address], eax
    
    ; Move the starting address of the alphabet into a variable
    mov eax, [ebp + 12]
    mov [alphabet_address], eax
    
    ; Move the starting address of the result string, s2, into a variable
    mov eax, [ebp + 16]
    mov [s2_address], eax
    
    ; We'll use ESI as an index to iterate through s1 and s2, so we need to save its value on the stack
    push esi
    mov esi, 0
    for_every_character_in_s1:
    
        ; Clear ECX
        mov ecx, 0
        
        ; Get the current character from s1 into CL
        mov eax, [s1_address]
        mov cl, [eax + esi]
        
        ; Subtract the ASCII value of 'a' from CL so that we get the index of the converted character into CL
        sub cl, 'a'
        
        ; Put into DL the converted character
        mov eax, [alphabet_address]
        mov dl, [eax + ecx]
    
        ; Put into the corresponding position of s2 the converted character (notice: the conversion is done character by character so we can simply use the same index, ESI)
        mov eax, [s2_address]
        mov [eax + esi], dl
    
        ; Increase the index ESI, and if we reached the end of the string s1 break the loop
        inc esi
        mov eax, [s1_address]
        cmp byte [eax + esi], 0
        je break_loop
    jmp for_every_character_in_s1
    
    break_loop:
    
    ; Add a NULL termination character at the end of the converted string s2
    mov eax, [s2_address]
    mov byte [eax + esi], 0
    
    ; Restore the value of ESI from the stack
    pop esi
    
    ; Restore the stack frame from the caller program and exit the procedure
    mov esp, ebp
    pop ebp
    ret