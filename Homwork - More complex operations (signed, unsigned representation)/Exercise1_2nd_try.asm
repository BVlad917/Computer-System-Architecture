bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions


; 25) (a + b + c) - (d + d) + (b + c)                          
; a - byte, b - word, c - double word, d - qword - Unsigned Representation                          
                          
segment data use32 class=data
    a db 100
    b dw 50
    c dd 60
    d dq 30

;        ===> 260 for the above data

segment code use32 class=code
    start:
        
        mov ecx, dword [c]; ECX = c 
        mov eax, 0
        mov al, [b]
        add ecx, eax; ECX = b + c 
        
        mov al, 0
        mov al, [a]
        add ecx, eax; ECX = a + b + c 
        
        mov eax, dword [d + 0]
        mov edx, dword [d + 4]; EDX:EAX = d 
        
        clc
        add eax, eax
        adc edx, edx; EDX:EAX = d + d 
        
        mov [d + 0], dword eax
        mov [d + 4], dword edx; Now the address of qword d has (d + d) 
        
        mov eax, ecx
        mov edx, 0; EDX:EAX = a + b + c 
        
        clc
        sub eax, dword [d + 0]
        sbb edx, dword [d + 4]; EDX:EAX = (a + b + c) - (d + d) 
        
        mov ecx, 0
        mov cx, [b]
        add ecx, [c]; ECX = b + c 
        
        clc
        add eax, ecx
        adc edx, 0; EDX:EAX = (a + b + c) - (d + d) + (b + c) 
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
