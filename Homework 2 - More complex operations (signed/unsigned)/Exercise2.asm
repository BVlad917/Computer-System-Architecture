bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions


; 25) (a + b - c) + (a + b + d) - (a + b)
; a - byte, b - word, c - double word, d - qword - Signed representation                          
            
segment data use32 class=data
    a db 9
    b dw 7
    c dd 5
    d dq 10
    ; a db 1
    ; b dw 2
    ; c dd 70
    ; d dq 10

; The result for the above data: (9 + 7 - 5) + (9 + 7 + 10) - (9 + 7) = 11 + 26 - 16 = 37 - 16 = 21 = 15(h)    

segment code use32 class=code
    start:
        xor eax, eax; clear EAX
        xor ebx, ebx; clear EBX
        
        mov al, [a]; AL = 1
        cbw; AX = 1
        add ax, [b]; AX = 3
        cwde; EAX = 3
        sub eax, [c]; EAX = -67
        mov ebx, eax; EBX = -67     # need to extend this if want to subtract with a qword
        
        xor eax, eax
        xor ecx, ecx
        mov al, [a]; AL = a = 1
        cbw; AX = a = 1
        add ax, [b]; AX = 3
        cwde; EAX = 3
        
        add dword [d], eax;
        adc dword [d + 4], 0; Now the address of qword d has 13 = D(h)
        
        mov eax, ebx;
        cdq; EDX:EAX = -67
        
        add dword [d], eax
        adc dword [d + 4], edx
        ; Now the address of qword d has -54
        
        xor eax, eax
        mov al, [a]; AL = 1
        cbw; AX = 1
        add ax, [b]; AX = 3
        cwde; EAX = 3
        cdq; EDX:EAX = 3
        
        sub dword [d], eax
        sbb dword [d+4], edx
        ; Now the address of qword d has the result
        ; We'll move it into EDX:EAX
        
        mov eax, dword [d]
        mov edx, dword [d + 4]
        ; Now EDX:EAX has the result
   
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
