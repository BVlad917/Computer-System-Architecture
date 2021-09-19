bits 32
global convert

segment data use32 public class=data
    
segment code use32 public class=code
    convert:
        ; Move the letter into EAX and subtract 'a' from it so we get the 
        ; index of the letter from the alphabet
        mov eax, [esp + 4]
        sub eax, 'a' ;Now EAX has the index of the alphabet of the converted letter
        
        mov ebx, [esp + 8] ;Get the starting address of the alphabet
        mov al, [ebx + eax] ;Move into AL the corresponding converted letter, using the EBX as starting address of the alphabet and EAX as the index
        ret