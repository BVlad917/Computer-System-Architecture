bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions


; 25) (a * a + b + x) / (b + b) + c * c - Unsigned representation
; a - word; b - byte; c - doubleword; x - qword                          
                          
segment data use32 class=data
    a dw 5
    b db 3
    c dd 4
    x dq 9

; (5 * 5 + 3 + 9) / (3 + 3) + 4 * 4 = 37 / 6 + 16 = 6 + 16 = 22    

segment code use32 class=code
    start:
        xor eax, eax; clear EAX
        mov ax, [a]; AX = 5
        mul ax; DX:AX = 25
        
        push dx
        push ax
        pop ebx; EBX = 25
        
        mov al, [b]; AL = 3
        cbw; AX = 3
        cwde; EAX = 3
        
        add ebx, eax; EBX = 28
        mov eax, ebx; EAX = 28
        cdq; EDX:EAX = 28
        
        add eax, dword [x]
        adc edx, dword [x + 4]
        ; EDX:EAX = (a * a + b + x) = 37
        
        mov ecx, eax;; ECX = EAX
        mov al, [b]
        cbw
        add ax, ax
        cwde; EAX = (b + b)
        
        mov ebx, eax; EBX = (b + b)
        mov eax, ecx
        ; Now EDX:EAX = (a * a + b + x)
        
        div ebx; EAX = (a * a + b + x) / (b + b); EDX = (a * a + b + x) % (b + b)
        mov ecx, eax; ECX = (a * a + b + x) / (b + b)
        
        mov eax, [c]; EAX = c
        mul eax; EDX:EAX = c * c
        
        add eax, ecx
        adc edx, 0
        ; Now EDX:EAX has the answer: 22
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
