bits 32

global start        

extern exit, printf
import exit msvcrt.dll
import printf msvcrt.dll

extern high_byte_of_low_word, print_in_binary, get_negative_number_string

; Se da un sir de dublucuvinte. 
; Scrieti un program in limbaj de asamblare care construieste doua siruri astfel:
;
; i). Un sir de octeti sir2 luand din fiecare dublucuvant octetul superior al cuvantului inferior, iar daca acest 
; octet este strict negativ, el se va pune in sirul destinatie. La final elementele sirului destinatie vor fi afisate in baza 2.
; Ex: sir1 DD 1245AB36h, 23456789h, 1212F1EEh
; Sirul octetilor superiori ai cuvintelor inferioare va fi: ABh, 67h, F1h. Dintre acestia, doar ABh si F1h sunt strict negativi, deci
; sir2 db ABh, F1h
; Pe ecran se va afisa: 1010 1011 1111 0001 (nu trebuie neaparat sa se afiseze si spatiile intre semiocteti).
;
; ii). Sirul sir3 reprezentand sirurile de stringuri necesar a fi afisate pe ecran pentru tiparirea valorilor octetilor din sir2 in baza 10.
; Pentru sirul sir2 de mai sus, vom avea
; sir3 db "-85", "-15"

segment data use32 class=data
    sir1 dd 1245AB36h, 23456789h, 1212F1EEh
    len equ ($ - sir1) / 4 ; The length of the sequence of dwords
    sir2 resb len
    sir3 resb len * 4 ; The numbers converted to string will have at most 4 characters (bytes so we have [-128, 127] and we also have the '-' sign) 
    len_of_sir2 resd 1
    write_char_format db "%c", 0
    write_num_format db "%d", 0
    
segment code use32 class=code
    start:
        ; We'll use ESI to iterate over the numbers from <sir1> and EDI to store the high byte of the low word of each
        ; number in <sir2>
        mov esi, 0
        mov edi, 0
        
        ; Take every dword from the sequence <sir1>
        .for_every_dword_in_sir1:
            ; Get the high byte of the low word of each dword
            push dword [sir1 + esi * 4]
            call high_byte_of_low_word
            add esp, 1 * 4
            
            ; If the number is not negative, don't save it in <sir2>
            cmp al, 0
            jge .dont_save
            ; But if it is negative, save it in <sir2>
                mov byte [sir2 + edi], al
            inc edi
        
            .dont_save:
        
            ; Increase the index ESI, and if we reached the end of the sequence exit the loop
            inc esi
            cmp esi, len
        jb .for_every_dword_in_sir1
        
        ; Save the lenght of the sequence <sir2> in a variable
        mov dword [len_of_sir2], edi
        
        ; Clear EAX as we will need it for future use
        mov eax, 0
        
        ; With ESI we will iterate over the sequence <sir2> (the sequence that now has the high bytes of the
        ; low words of each dword from <sir1>)
        mov esi, 0
        .for_every_byte_in_sir2:
            ; For every byte from the sequence <sir2>
            
            ; Put this byte in AL, push EAX on the stack and print the binary representation of this byte on the screen
            mov al, byte [sir2 + esi]
            
            push eax
            call print_in_binary
            add esp, 1 * 4
        
            ; Increase the index ESI, and if we reached the end of the sequence <sir2>, then exit the loop
            inc esi
            cmp esi, dword [len_of_sir2]
        jb .for_every_byte_in_sir2
        
        ; Print a newline so the output is more readable
        push dword 10
        push write_char_format
        call [printf]
        add esp, 2 * 4

        
        ; Now we need to create the sequence sir3
        ; We'll use ESI as an index for iterating through the negative numbers from <sir2>
        mov esi, 0
        ; We'll use EBX as an index to save the characters in the sequence <sir3>
        mov ebx, 0
        
        ; For every negative number from <sir2>
        .second_for_every_byte_in_sir2:
            
            ; Put the current negative number in EAX
            mov eax, 0
            mov al, byte [sir2 + esi]
            
            ; Convert it to a string
            push eax
            call get_negative_number_string
            add esp, 1 * 4
            
            ; We'll use EDI to iterate through the returned string from the above function call
            mov edi, 0
            
            ; For every character in the string returned by <get_negative_number_string>
            .for_every_char_in_string:
            
                ; Copy that character in the string <sir3>
                mov dl, byte [eax + edi]
                mov byte [sir3 + ebx], dl
                inc ebx
            
                ; Increase the index EDI and if we reached the end of the string, exit
                inc edi
                cmp byte [eax + edi], 0
            jne .for_every_char_in_string
        
            ; Increase ESI and if we parsed through the entire sequence of negative numbers, exit the loop and stop the program
            inc esi
            cmp esi, dword [len_of_sir2]
        jb .second_for_every_byte_in_sir2
        
        ; Now <sir3> has the starting address of the sequence of characters "-85", "-15"
        ; i.e., We would get what we have in <sir3> if we would use the command: sir3 db "-85", "-15"
        
        push    dword 0
        call    [exit]
