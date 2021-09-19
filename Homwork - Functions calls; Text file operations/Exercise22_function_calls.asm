bits 32
global start        


extern exit, printf, scanf           
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll
                          

; 22) Two numbers a and b are given. Compute the expression value: (a + b) * k,
; where k is a constant value defined in datasegment.
; Display the expression value (in base 10).                          
                          
segment data use32 class=data
    a resd 1
    b resd 1
    k dw 5
    message1 db "a = ", 0
    message2 db "b = ", 0
    readformat db "%d", 0
    writeformat db "(%d + %d) * %d = %d", 0
    
segment code use32 class=code
    start:
        ; Print the message asking for a
        push dword message1
        call [printf]
        add esp, 1 * 4
        
        ; Read the number a
        push dword a
        push dword readformat
        call [scanf]
        add esp, 2 * 4
        
        ; Print the message asking for b
        push dword message2
        call [printf]
        add esp, 1 * 4
        
        ; Read the number b
        push dword b
        push dword readformat
        call [scanf]
        add esp, 2 * 4
        
        ; Move the number a into AX, add the number b to it, and multiply the sum by the constant k; The resulting number will be in EAX
        mov ax, word [a]
        add ax, word [b]
        mul word [k]
        
        ; Clear EBX so we can store k in it, as we need to print it also
        ; Push all the necessary variables on the stack and the format of the output and then call printf the print everything
        mov ebx, 0
        mov bx, [k]
        push dword eax
        push dword ebx
        push dword [b]
        push dword [a]
        push dword writeformat
        call [printf]
        add esp, 5 * 4
    
        push    dword 0
        call    [exit]
