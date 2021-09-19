bits 32

extern printf
import printf msvcrt.dll

global print_in_binary

segment data use32 class=data
    number resb 1
    output_format db "%d", 0
    space db ' ', 0
    
segment code use32 class=code
    print_in_binary:
        
        ; Get the byte in a variable
        mov eax, [esp + 4]
        mov byte [number], al
        
        ; We'll use ECX as a count for how many times we need to shift left the byte and print the 
        ; digit stored in CF
        mov ecx, 8
        .for_every_bit_in_AL:
        
            ; Shift the byte to the left by 1, now the left-most bit is in CF
            shl byte [number], 1
            
            ; Put the left-most bit in EDX
            mov edx, 0
            adc edx, 0
        
            ; Save ECX on the stack, since the printf function can modify it
            push ecx
        
            ; Print the value from EDX, the current left-most bit
            push edx
            push output_format
            call [printf]
            add esp, 2 * 4
        
            ; Restore the value of ECX from the stack after we applied the printf function
            pop ecx
        
            ; Decrese ECX and if we reached 0, that means we have nothing left to print => Exit the loop
            dec ecx
            cmp ecx, 0
        ja .for_every_bit_in_AL
        
        ; Print a space so that the output is more readable
        push dword space
        call [printf]
        add esp, 1 * 4
        
        ; Return from the function
        ret