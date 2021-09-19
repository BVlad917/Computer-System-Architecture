bits 32

global start        

extern exit, printf, scanf, perror, convert
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll
import perror msvcrt.dll

; 23) Read a string s1 (which contains only lowercase letters).
; Using an alphabet (defined in the data segment), determine and display the string s2
; obtained by substitution of each letter of the string s1 with the
; corresponding letter in the given alphabet.
;   Example:
;       The alphabet:  OPQRSTUVWXYZABCDEFGHIJKLMN
;       The string s1: anaaremere
;       The string s2: OBOOFSASFS


; We'll build a function convert that converts a given lower case string
; according to a given alphabet. The function header
; would look something like 'convert(<s1>, <alphabet>, <s2>)'

segment data use32 public class=data
    input_msg db "Please give the string you want to convert: ", 0
    input_format db "%s", 0
    output_msg db "The converted string is: %s", 10, 0
    max_len equ 100 ;We'll assume the length of the string is at most 100 (altough this can easily be changed)
    s1 resb max_len + 1
    s2 resb max_len + 1
    
    alphabet db "OPQRSTUVWXYZABCDEFGHIJKLMN", 0
    string_too_long_msg db "Please enter a string no longer than %d characters.", 10, 0
    error_msg db "An error occurred while reading the string.", 10, 0

segment code use32 public class=code
    start:
        ; Print a message asking for the string we want to convert
        push dword input_msg
        call [printf]
        add esp, 1 * 4
        
        ; Read the string we want to convert, store it in s1
        push dword s1
        push input_format
        call [scanf]
        add esp, 2 * 4
        
        ; If there was an error during the reading process, jump to end, print an error message, and exit the program
        cmp eax, 0
        je .input_error
        ; If the input string is longer than the maximum accepted size, jump to end, print an error message, and exit the program
        cmp byte [s1 + max_len], 0
        jne .input_too_long
        
        
        ; We'll now call the convert function, which will convert the string s1 according to the given alphabet
        push s2
        push alphabet
        push s1
        call convert
        add esp, 3 * 4
        
        push s2
        push output_msg
        call [printf]
        add esp, 2 * 4
        jmp .fin
        
        
        ; Error that will be shown in the case that the input string is too long
        .input_too_long:
            push dword max_len
            push string_too_long_msg
            call [printf]
            add esp, 2 * 4
            jmp .fin
        
        ; Error that will be shown in the case that the reading process was unsuccessful
        .input_error:
            push error_msg
            call [perror]
            add esp, 1 * 4
        
        .fin:
        
        push    dword 0
        call    [exit]
