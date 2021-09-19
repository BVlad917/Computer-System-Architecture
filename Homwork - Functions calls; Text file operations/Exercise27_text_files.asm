bits 32
global start        

extern exit, fopen, fclose, fread, fprintf
import exit msvcrt.dll 
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll

; 27) A text file is given. The text file contains numbers (in base 10) separated by spaces.
; Read the content of the file, determine the minimum number (from the numbers that have been read)
; and write the result at the end of file.

segment data use32 class=data
    file_name db "numbers.txt", 0
    access_mode db "a+", 0
    file_descriptor dd -1
    len equ 1000
    text resb len
    writeformat db 10, "%d", 0
    min dd 0FFFFFFFFh

segment code use32 class=code
    start:
        ; Firstly, open the file
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 2 * 4
        
        mov [file_descriptor], eax; Move the file descriptor in a variable so we can use the register EAX
        cmp eax, 0; see if the file opened successfully
        je final; if the file didn't open, jump to the end
        
        ; Now we read the text from the file
        push dword [file_descriptor]
        push dword len
        push dword 1
        push dword text
        call [fread]
        add esp, 4 * 4
        
        mov esi, 0; index for looping through the characters from the file
        mov ebx, eax; save the number of characters in the file in EBX; we'll need EAX for something else, look below
        mov eax, 0; we'll use EAX to construct each number from the file
        mov ecx, 0
        for_every_character_in_the_file:
            mov cl, [text + esi]; get the current character from the file
            cmp cl, ' '; See if it is a space or not
            je not_digit
                ; If the current character is not a space (i.e., it is a digit), we convert this character digit
                ; to an integer, multiply EAX by 10 and add this new digit to EAX
                mov dx, 10
                mul word dx
                sub cl, '0'
                add eax, ecx
                jmp dont_change
            
            not_digit:
                ; If the current character is a space, that means we already have a number read and stored in EAX.
                ; See if this number is smaller than the current minimum and if it is indeed smaller, assign to the variable
                ; min this new minimum, namely EAX
                mov edx, eax
                mov eax, 0; Here we reset the register EAX, as it will need to construct the next number
                cmp edx, [min]
                jae dont_change
                    mov [min], edx
        
            dont_change:
                    ; If the current number is not smaller than min, don't do anything
                
            inc esi
            cmp esi, ebx
            jb for_every_character_in_the_file
        
        ; Now we have the minimum number from that file in the variable min
        ; We need to append this number to the file
        
        push dword [min]
        push dword writeformat
        push dword [file_descriptor]
        call [fprintf]
        add esp, 3 * 4
        
        ; Now we need to close the file
        push dword [file_descriptor]
        call [fclose]
        add esp, 1 * 4
        
        final:
            ; If the file failed to open, we jump here
        push    dword 0
        call    [exit]
