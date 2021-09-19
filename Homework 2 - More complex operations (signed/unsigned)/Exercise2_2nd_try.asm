bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

  
; 25) (a + b - c) + (a + b + d) - (a + b)  
; a - byte, b - word, c - double word, d - qword - Signed Representation


segment data use32 class=data
    a db 100
    b dw 150
    c dd 350
    d dq 50

;       ===> -50 for the above data

segment code use32 class=code
    start:
        
        mov al, [a] 
        cbw; AX = a
        add ax, [b]
        cwde; EAX = a + b
        sub eax, [c]; EAX = a + b - c
        
        mov ecx, eax; ECX = a + b - c
        mov al, [a]
        cbw
        add ax, [b]
        cwde; EAX = a + b
        cdq; EDX:EAX = a + b
        
        clc
        add dword [d + 0], eax
        adc dword [d + 4], edx; qword @ address d = (a + b + d)
        
        mov eax, ecx
        cdq; EDX:EAX = a + b - c
        
        clc
        add dword [d + 0], eax
        adc dword [d + 4], edx; qword @ address d = (a + b - c) + (a + b + d)
        
        mov al, [a]
        cbw
        add ax, [b]
        cwde
        cdq; EDX:EAX = a + b
        
        clc
        sub dword [d + 0], eax
        sbb dword [d + 4], edx; qword @ address d = (a + b - c) + (a + b + d) - (a + b)
        
        mov eax, dword [d + 0]
        mov edx, dword [d + 4]; EDX:EAX = (a + b - c) + (a + b + d) - (a + b)
        
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
