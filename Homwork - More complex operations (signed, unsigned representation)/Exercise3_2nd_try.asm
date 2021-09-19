bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions


; 25) (a * a + b + x) / (b + b) + c * c - Unsigned Representation                          
; a-word; b-byte; c-doubleword; x-qword
                   
segment data use32 class=data
    a dw 20
    b db 10
    c dd 50
    x dq 100

;       ===> 2525 for the above data

segment code use32 class=code
    start:
        
        mov ax, [a]
        mul ax; DX:AX = a * a
        push dx
        push ax
        pop ebx; EBX = a * a
        
        mov eax, 0
        mov al, [b]
        add ebx, eax; EBX = a * a + b
        
        mov eax, ebx
        mov edx, 0; EDX:EAX = a * a + b
        
        clc
        add dword [x + 0], eax
        adc dword [x + 4], edx; qword @ address of x = (a * a + b + x)
        
        mov eax, 0
        mov bx, 0
        mov al, [b]
        mov bl, [b]
        add ax, bx; EAX = (b + b)
        
        mov ebx, eax; EBX = (b + b)
        mov eax, dword [x + 0]
        mov edx, dword [x + 4]; EDX:EAX = (a * a + b + x)
        
        div ebx; EAX = (a * a + b + x) / (b + b); EDX = (a * a + b + x) % (b + b)
        
        mov ebx, eax; EBX = (a * a + b + x) / (b + b)
        mov eax, [c]
        mul eax; EDX:EAX = (c * c)
 
        mov dword [x + 0], eax
        mov dword [x + 4], edx; qword @ address of x = (c * c)
        mov eax, ebx;
        mov edx, 0; EDX:EAX = (a * a + b + x) / (b + b)
        
        clc
        add eax, dword [x + 0]
        adc edx, dword [x + 4]
        ; EDX:EAX = (a * a + b + x) / (b + b) + c * c
 
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
