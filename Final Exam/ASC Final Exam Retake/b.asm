bits 32

global procedura_1, procedura_2
extern printf
import printf msvcrt.dll

segment data use32 class=data
    print_format db "%x ", 0
    
segment code use32 class=code
    procedura_1:
        ; We move in ECX the dword that needs to be mirrored
        mov ecx, [esp + 4]
        ; We'll put the mirrored value in EAX
        mov eax, 0
        
        ; Swap the last byte and put it in EAX
        mov dl, cl
        shl dl, 4
        add al, dl
        mov dl, cl
        shr dl, 4
        add al, dl
        ; Go to the next byte
        shl eax, 8
        shr ecx, 8
        
        ; Swap the second to last byte and put it in EAX
        mov dl, cl
        shl dl, 4
        add al, dl
        mov dl, cl
        shr dl, 4
        add al, dl
        ; Go to the next byte
        shl eax, 8
        shr ecx, 8
        
        ; Swap the second byte and put it in EAX
        mov dl, cl
        shl dl, 4
        add al, dl
        mov dl, cl
        shr dl, 4
        add al, dl
        ; Go to the next byte
        shl eax, 8
        shr ecx, 8
        
        ; Swap the first byte and put it in EAX
        mov dl, cl
        shl dl, 4
        add al, dl
        mov dl, cl
        shr dl, 4
        add al, dl
        ; No more shifting required
        ret
    
    procedura_2:
        ; Push the dword that needs to be printed on the stack and call the <printf> function
        push dword [esp + 4]
        push print_format
        call [printf]
        add esp, 2 * 4
        ret
