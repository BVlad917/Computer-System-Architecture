bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
                          
; Exercise 3              
; Additions, subtractions
; a, b, c, d word
; 25) (a + b - c) - d            
                          
segment data use32 class=data
    a dw 1
    b dw 2
    c dw 3
    d dw 4
    ; 4

; our code starts here
segment code use32 class=code
    start:
    
        mov eax, 0; clear EAX
        mov ax, [a]; AX = a
        
        mov ebx, 0; clear EBX
        mov bx, [b]; BX = b
        
        add EAX, EBX; EAX = EAX + EBX = AX + BX = a + b
        
        mov ebx, 0; clear EBX
        mov bx, [c]; BX = c
        
        sub eax, ebx; EAX = EAX - EBX = a + b - c
        
        mov ebx, 0; clear EBX
        mov bx, [d]; BX = d
        
        sub eax, ebx; EAX = EAX - EBX = (a + b - c) - d
        
        ; EAX now contains the correct answer
    
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
