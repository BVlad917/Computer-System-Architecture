bits 32       

global high_byte_of_low_word

segment data use32 class=data
    
segment code use32 class=code
    high_byte_of_low_word:
        ; Get the dword in EAX
        mov eax, [esp + 4]
        
        ; Use the AND instruction so that we isolate the high byte of the low word
        and eax, 0000_0000_0000_0000_1111_1111_0000_0000b
        
        ; Shift to the right by 8 positions, so that we now have the high byte of the low word in AL
        shr eax, 8
        
        ; Return from the program
        ret
