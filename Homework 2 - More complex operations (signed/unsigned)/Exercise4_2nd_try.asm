bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

                          
; 25) (a * a + b + x) / (b + b) + c * c - Signed Representation
; a-word; b-byte; c-doubleword; x-qword
                          
segment data use32 class=data
    a dw 10
    b db 10
    x dq -400
    c dd 3
    
;     ===> -5 for the above data

segment code use32 class=code
    start:
        
        mov ax, [a]
        imul ax; DX:AX = a * a
        push dx
        push ax
        pop ebx; EBX = a * a
        
        mov al, [b]
        cbw
        cwde; EAX = b
        add eax, ebx; EAX = a * a + b
        cdq; EDX:EAX = a * a + b
        
        clc
        add dword [x + 0], eax
        adc dword [x + 4], edx; qword @ address of x = (a * a + b + x)
        
        mov al, [b]
        cbw
        add ax, ax; AX = (b + b)
        cwde; EAX = (b + b)
        mov ebx, eax; EBX = (b + b)
        
        mov eax, dword [x + 0]
        mov edx, dword [x + 4]; EDX:EAX = (a * a + b + x)
        idiv ebx; EAX = (a * a + b + x) / (b + b); EDX = (a * a + b + x) / (b + b)
        mov ebx, eax; EBX = (a * a + b + x) / (b + b)
        
        mov eax, [c]
        imul eax; EDX:EAX = c * c
        
        mov dword [x + 0], eax
        mov dword [x + 4], edx; qword @ address of x = c * c
        
        mov eax, ebx; EAX = (a * a + b + x) / (b + b)
        cdq; EDX:EAX = (a * a + b + x) / (b + b)
        
        clc
        add eax, dword [x + 0]
        adc edx, dword [x + 4]
        ; EDX:EAX = (a * a + b + x) / (b + b) + c * c
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
