bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions


; Exercise 5
; Multiplications, divisions
; a, b - byte; e, f, g - word
; 25) (e + f + g) / (a + b)   === > AX = 3h
                          
segment data use32 class=data
    a db 3
    b db 4
    e dw 7
    f dw 8
    g dw 9


segment code use32 class=code
    start:
        
        mov eax, 0; clear EAX
        mov ebx, 0; clear EBX
        
        mov ax, [e]; AX = e
        mov bx, [f]; BX = f
        add eax, ebx; EAX = EAX + EBX = e + f
        
        mov bx, 0; clear BX
        mov bx, [g]; BX = g
        
        add eax, ebx; EAX = EAX + EBX = e + f + g
        mov ecx, eax; ECX = EAX = e + f + g. We need EAX later, so we move result to ECX
        
        
        mov edx, 0; clear EDX
        mov eax, 0; clear EAX
        mov ax, cx; AX = CX
        
        shr ecx, 16; Shift ecx by 4 bytes
        mov dx, cx; DX = CX
        
        ; Now DX:AX = e + f + g
        
        mov ebx, 0; clear EBX
        mov ecx, 0; clear ECX
        
        mov bl, [a]; BL = a
        mov cl, [b]; CL = b
        
        add bx, cx; BX = BX + CX = BL + CL = a + b
        
        div bx; AX = DX:AX / BX and DX = DX:AX % BX
        
        ; Now AX will contain the correct answer
        ; DX will contain the remainder of that division
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
