bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions


; Exercise 4
; Multiplications, divisions
; a, b, c - byte, d - word
; 25) [100 - (10 * a + 4 * (b + c))] - d     
                          
segment data use32 class=data
    a db 1
    b db 2
    c db 3
    d dw 4

segment code use32 class=code
    start:
        
        xor ebx, ebx; clear EBX
        mov bx, 100; BX = 100
        
        xor eax, eax; clear EAX
        mov al, 10; AL = 10
        mul byte [a]; AX = AL * a = 10 * a
        
        sub bx, ax; BX = BX - AX = 100 - (10 * a)     = 90 = 5Ah
        
        xor al, al; clear AL
        mov al, [b]
        
        xor ecx, ecx; clear ECX
        mov cl, [c]; CL = c
        
        add ax, cx; AX = AX + CX = AL + CL = b + c
        xor cl, cl; clear CL
        mov cx, 4; CX = 4
        
        mul cx; DX:AX = AX * CX = 4 * (b + c)         = 20 = 14h
        
        push dx; Push AX on the stack
        push ax; Push DX on the stack
        pop eax; Pop DX:AX on EAX; EAX = 4 * (b + c)
        
        add ebx, eax; EBX = EBX + EAX = 100 - (10 * a) + 4 * (b + c)    = 110 = 6E
        
        xor cl, cl; clear CL
        mov cx, [d]; CX = d
        
        sub ebx, ecx; EBX = EBX - ECX = [100 - (10 * a) + 4 * (b + c)] - d    = 106 = 6A
        
        
        ; Now EBX will have the correct answer
        
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
