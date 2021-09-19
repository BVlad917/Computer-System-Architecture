bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
                          
; 25) (a + b + c) - (d + d) + (b + c)
; a - byte, b - word, c - double word, d - qword - Unsigned representation                          
                          
segment data use32 class=data
    a db 3
    b dw 5
    c dd 9
    d dq 4
    
; For the above example result is: (3 + 5 + 9) - (4 + 4) + (5 + 9) = 17 - 8 + 14 = 9 + 14 = 23 = 17(h)

segment code use32 class=code
    start:
        xor eax, eax; clear EAX
        xor ebx, ebx; clear BX
        
        mov eax, [c]; EAX = 9
        mov bl, [a]; BX = 3
        add eax, ebx; EAX = 12 = C(h)
        
        mov bx, [b]; BX = 5
        add eax, ebx; EAX = 17 = 11(h)
        
        mov ebx, [d]; EBX = low part of d
        mov ecx, [d + 4]; ECX = high part of d
        
        add dword [d], ebx;
        adc dword [d + 4], ecx;
        ; Now what was in d is d + d = 8
        
        cdq; Now EDX:EAX = 17 = 11(h)
        sub eax, dword [d]
        sbb edx, dword [d + 4]
        ; Now EDX:EAX = 17 - 8 = 9
        
        xor ebx, ebx; clear EBX
        mov bx, [b]
        add ebx, [c]
        ; Now EBX = 14 = E(h)
        
        add eax, ebx
        adc edx, 0
        
        ; Now EDX:EAX has the right result: 23 = 17(h)
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
