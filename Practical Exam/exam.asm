bits 32

global start        

extern exit, fopen, fclose, fread, fprintf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll

; A file containing only sentences (a sentence is a string ending with the '.' character).
; Write an assembly program that reads the given file and write in a different file the 
; 2nd word from each sentence followed by the number of words from each sentence.
; The names of both files are located in the data segment.

segment data use32 class=data
    len equ 100
    text resb len
    no_of_chars dd 0

    write_format db "%c", 0
    write_number_format db "%d", 0
    in_file_name db "in.txt", 0
    out_file_name db "out.txt", 0
    in_descr dd -1
    out_descr dd -1
    write_mode db "w", 0
    read_mode db "r", 0
    
    no_of_spaces dd 0
    ; spaces_vector resb len
    spaces_vector resb len * 4 ; In <spaces_vector> we'll keep the number of spaces in each sentence
    ; Probably unnecessay to have the vector of spaces as a vector of dwords (highly unlikely that a sentence
    ; will have 2 billion spaces in it), but since we declared <no_of_spaces> as a dword (variable that counts
    ; the number of spaces in each sentence), we might as well use a vector of the same type and not risk
    ; losing any information. I first declared this vector as a byte vector (commands are still in the file, commented)
    
segment code use32 class=code
    start:
        ; Open the input file
        push read_mode
        push in_file_name
        call [fopen]
        add esp, 2 * 4
        
        ; If the file failed to open, exit the program
        cmp eax, 0
        je final2
        
        ; Save the file descriptor in a variable
        mov dword [in_descr], eax
        
        ; Open the output file
        push write_mode
        push out_file_name
        call [fopen]
        add esp, 2 * 4
        
        ; If the file failed to open, close the input file and exit the program
        cmp eax, 0
        je final1
        
        ; Save the file descriptor in a variable
        mov dword [out_descr], eax
        
        ; The files are now open. Let's get to work
        
        ; We'll use EDI as an index for <spaces_vector>
        mov edi, 0
        
        ; We'll use ebx to push the character on the stack
        mov ebx, 0
        for_every_text_chunk:
            ; Read a text chunk of <len> characters
            push dword [in_descr]
            push dword len
            push dword 1
            push dword text
            call [fread]
            add esp, 4 * 4
            
            ; If no more characters, then exit the loop
            cmp eax, 0
            je no_more_chars
            
            ; Save the number of characters in a variable
            mov dword [no_of_chars], eax
            
            ; We'll iterate over all characters in the current text chunk. We'll use ESI as an index
            mov esi, 0
            
            for_every_char_in_chunk:
                ; We'll save the current character in BL
                mov bl, [text + esi]
            
                cmp dword [no_of_spaces], 1
                jne dont_copy_to_file
                
                    ; If we get here, that means we are currently iterating over the second word. So we must copy the current char
                    push ebx
                    push dword write_format
                    push dword [out_descr]
                    call [fprintf]
                    add esp, 3 * 4
                
                dont_copy_to_file:
                
                ; If the current char is a space, increase the count
                cmp byte bl, ' '
                jne not_space
                    add dword [no_of_spaces], 1
                
                not_space:
                ; If the current char is a dot, reset the spaces count
                cmp byte bl, '.'
                jne not_dot
                
                    ; Save the number of spaces from this sentence in the spaces vector
                    mov ecx, [no_of_spaces]
                    mov [spaces_vector + edi * 4], ecx
                    inc edi
                
                    ; This is the same command as above, but from the first implementation, where the spaces vector was a vector of bytes
                    ; mov cl, [no_of_spaces]
                    ; mov byte [spaces_vector + edi], cl
                    ; inc edi
                
                    ; Reset the number of spaces
                    mov dword [no_of_spaces], 0
                
                not_dot:
                
                ; If we got to the end of the chunk, exit the loop
                inc esi
                cmp esi, dword [no_of_chars]
            jb for_every_char_in_chunk
        
        jmp for_every_text_chunk
        
        
        no_more_chars:
        ; Now we need to also copy the number of words from each sentence in the file
        ; First, add a newline character so we have the words and sentences on different lines
        push dword 10
        push write_format
        push dword [out_descr]
        call [fprintf]
        add esp, 3 * 4
        
        ; We have EDI that has the "number of numbers" that we need to print
        ; We'll reset ESI and use it as an index again, this time for printing the number of words
        mov esi, 0
        for_every_entry_in_spaces_vector:
            
            ; Put the number of spaces in BL
            mov ebx, [spaces_vector + esi * 4]
            
            ; This is the same command as above, but from the first implementation, where the spaces vector was a vector of bytes
            ; mov bl, [spaces_vector + esi]
            
            ; Number of words = Number of spaces + 1, so we need to increase BL
            inc ebx
            
            ; This is the same command as above, but from the first implementation, where the spaces vector was a vector of bytes
            ; inc bl
            
            ; Write this number in the file
            push ebx
            push dword write_number_format
            push dword [out_descr]
            call [fprintf]
            add esp, 3 * 4
        
            ; We also add a space between the written numbers so we can actually understand something
            push dword ' '
            push dword write_format
            push dword [out_descr]
            call [fprintf]
            add esp, 3 * 4
        
            ; If we got to the end of the spaces vector, then exit the loop
            inc esi
            cmp esi, edi
        jb for_every_entry_in_spaces_vector
        
        ; Close the output file
        push dword [out_descr]
        call [fclose]
        add esp, 1 * 4
        
        final1:
        ; Close the input file
        push dword [in_descr]
        call [fclose]
        add esp, 1 * 4
        
        final2:
        
        push    dword 0
        call    [exit]
