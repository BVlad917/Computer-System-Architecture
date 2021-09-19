bits 32

extern printf
import printf msvcrt.dll
global high_byte_of_low_word, print_byte_in_base_2

segment data use32 class=data
    print_integer db "%d", 0
    print_char db "%c", 0
    print_hexa db "%x ", 0

segment code use32 class=code
    high_byte_of_low_word:
        ; With 2 shifts we can get the high byte of the low word in AL
        mov eax, dword [esp + 4]
        shl eax, 16
        shr eax, 24
        ret
    
    print_byte_in_base_2:
        mov eax, dword [esp + 4]
        mov ecx, 8
        clc
        
        .for_every_bit_in_AL:
            ; Get the left-most bit from AL in the carry flag CF
            shl al, 1
            ; Get the value of CF in EDX so we can print this value
            mov edx, 0
            adc edx, 0
            
            ; We need the values of EAX, EDX, and ECX to not change, but we will use the function printf, which can change them
            ; So we save these 3 registers on the stack
            push eax
            push ecx
            push edx
            
            ; Push EDX on the stack and print its value on the screen
            push edx
            push print_integer
            call [printf]
            add esp, 2 * 4
        
            ; Now restore the values of EAX and EDX from the stack
            pop edx
            pop ecx
            pop eax
        
        loop .for_every_bit_in_AL
        
        ; Print a space in between the displayed bytes
        push dword ' '
        push print_char
        call [printf]
        add esp, 2 * 4
        ret