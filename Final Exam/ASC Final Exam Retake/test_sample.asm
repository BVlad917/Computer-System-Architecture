bits 32

global start        

extern exit, printf
import exit msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    format db "%d", 0
    
segment code use32 class=code
    start:
        mov eax, 16
        mov ebx, eax
        shl ebx, 1
        jc done
        shr ebx, 1
        jnc done
        shr ebx, 1
        jnc label1
        
        push eax
        push dword format
        call [printf]
        add esp, 2 * 4
        jmp done
        
        label1:
        neg eax
        push eax
        push dword format
        call [printf]
    
        done:
        push    dword 0
        call    [exit]
