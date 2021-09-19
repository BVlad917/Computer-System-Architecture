bits 32

extern printf
import printf msvcrt.dll
global get_mirrored, print_dword

segment data use32 class=data
    divisor db 10
    output_format db "%x ", 0
    
segment code use32 class=code
    get_mirrored:
        ; Get the word that needs to be mirrored in EDX and clear EAX
        mov edx, [esp + 4]
        mov eax, 0
        
        ; Interchange the nibbles of the last byte and put it in EAX
        mov cl, dl
        shl cl, 4
        add al, cl
        mov cl, dl
        shr cl, 4
        add al, cl
        
        ; Move on to the next byte
        shl eax, 8
        shr edx, 8
        
        ; Interchange the nibbles of the second to last byte and put it in EAX
        mov cl, dl
        shl cl, 4
        add al, cl
        mov cl, dl
        shr cl, 4
        add al, cl
        
        ; Move on to the next byte
        shl eax, 8
        shr edx, 8
        
        ; Interchange the nibbles of the second byte and put it in EAX
        mov cl, dl
        shl cl, 4
        add al, cl
        mov cl, dl
        shr cl, 4
        add al, cl
        
        ; Move on to the next byte
        shl eax, 8
        shr edx, 8
        
        ; Interchange the nibbles of the first byte and put it in EAx
        mov cl, dl
        shl cl, 4
        add al, cl
        mov cl, dl
        shr cl, 4
        add al, cl
        
        ; No more shifting since we don't have another byte to mirror
        ; Just return from the procedure
        ret
    
    print_dword:
        ; We just print the dword given as a parameter
        push dword [esp + 4]
        push output_format
        call [printf]
        add esp, 2 * 4
        ret