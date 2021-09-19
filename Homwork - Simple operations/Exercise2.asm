bits 32 ;assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start 

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
                  
; Exercise 2
; Additions, subtractions                  
; a, b, c, d bytes
; 25) (c + d + d) - (a + a + b)                          
                          
segment  data use32 class=data ; the data segment where the variables are declared 
    a db 1
    b db 2
    c db 3
    d db 4

segment  code use32 class=code ; code segment
start: 
	
    mov eax, 0; clear EAX
    mov al, [c]; AL = c
    
    mov ebx, 0; clear EBX
    mov bl, [d]; BL = d
    
    add ax, bx; AX = AX + BX = AL + BL = c + d
    add ax, bx; AX = AX + BX = AL + Bl = (c + d) + d
    
    mov ebx, 0; clear EBX
    mov bl, [a]; BL = a
    
    add bx, bx; BX = BX + BX = BL + BL = a + a
    
    mov ecx, 0; clear ecx
    mov cl, [b]; CL = b
    
    add bx, cx; BX = BX + CX = (a + a) + b
    
    sub ax, bx; AX = AX - BX = (c + d + d) - (a + a + b)
    
    ; EAX now contains the correct answer
    
	push   dword 0 ;saves on stack the parameter of the function exit
	call   [exit] ; function exit is called in order to end the execution of
