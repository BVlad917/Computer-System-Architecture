bits 32

global start        

extern exit
import exit msvcrt.dll
segment data use32 class=data
    
    
segment code use32 class=code
    start:
        mov eax, 00001111h
        
        push eax
        
        pop cx
        
        pop dx
        
        push    dword 0
        call    [exit]
