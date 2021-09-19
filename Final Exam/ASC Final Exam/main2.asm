bits 32

global start        

extern exit, printf, scanf
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll

extern convert_to_number

; 2) Read from the keyboard a string of numbers, given in the base 10 as signed numbers (a string of characters
; is read from the keyboard and a string of numbers must be stored in the memory).                          

segment data use32 class=data
    input_msg db "Please enter a number (enter 'e' if you want to exit): ", 0
    read_format db "%s", 0
    print_number_format db "%d ", 0
    input_string resb 20
    numbers_list resd 100

segment code use32 class=code
    start:
        mov esi, 0
    
        .while_not_stop:
            ; Print a message asking for input
            push input_msg
            call [printf]
            add esp, 1 * 4

            ; Read the number (as characters)
            push dword input_string
            push read_format
            call [scanf]
            add esp, 2 * 4
            
            ; If the character 'e' was given as input, stop accepting input
            cmp byte [input_string], 'e'
            je .stop_loop
            
            ; Convert the string with starting address in input_string to a number
            push dword input_string
            call convert_to_number
            add esp, 1 * 4
            
            ; Store the number in the list <numbers_list>
            mov [numbers_list + esi * 4], eax
            inc esi
        jmp .while_not_stop
        
        .stop_loop:
        
        ; In ESI we now have the "number of numbers", so we can use EDI to iterate over all numbers from the list
        mov edi, 0
        
        for_every_number_in_list:
            
            ; Print the current number
            push dword [numbers_list + edi * 4]
            push print_number_format
            call [printf]
            add esp, 3 * 4
        
            ; Increase the index EDI and if we reached the end of the list, exit
            inc edi
            cmp edi, esi
        jb for_every_number_in_list
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
