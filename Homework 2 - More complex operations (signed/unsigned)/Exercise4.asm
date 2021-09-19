bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; (a * a + b + x) / (b + b) + c * c; - Signed interpretation
; a - word; b - byte; c - doubleword; x - qword
                          
segment data use32 class=data
    a dw -5
    b db 2
    c dd 3
    x dq -89
    
; In the above data, the result is: (25 + 2 + (-67)) / (2 + 2) + 3 * 3 = -40 / 4 + 9 = -10 + 9 = -1

segment code use32 class=code
    start:
        xor eax, eax
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
        
        add dword [x], eax
        adc dword [x + 4], edx
        ; Now the address of qword x has (a * a + b + x)
        
        mov al, [b]
        cbw
        cwde; EAX = b
        add eax, eax; EAX = b + b
        
        mov ebx, eax; EBX = b + b
        
        mov edx, dword [x + 4]
        mov eax, dword [x]; EDX:EAX = (a * a + b + x)
        
        idiv ebx; EAX = (a * a + b + x) / (b + b); EDX = (a * a + b + x) % (b + b)
        mov ebx, eax; EBX = (a * a + b + x) / (b + b)
        
        mov eax, [c]
        imul eax; EDX:EAX = c * c
        
        mov ecx, eax
        mov eax, ebx
        mov ebx, edx
        ; Now EBX:ECX = (c * c)
        cdq; EDX:EAX = (a * a + b + x) / (b + b)
        
        add eax, ecx
        adc edx, ebx
        ; Now EDX:EAX has the answer: -1
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
