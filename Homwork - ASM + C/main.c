/*
23) Read a string s1 (which contains only lowercase letters). Using an alphabet (defined in
the data segment), determine and display the string s2 obtained by substitution of
each letter of the string s1 with the corresponding letter in the given alphabet.
    Example:
        The alphabet:  OPQRSTUVWXYZABCDEFGHIJKLMN
        The string s1: anaaremere
        The string s2: OBOOFSASFS
*/

#include <stdio.h>
#define max_length 100

void asmConvert(char s1[], char alphabet[], char s2[]);

int main()
{
    char s1[max_length + 1];
    char s2[max_length + 1];
    char alphabet[] = "OPQRSTUVWXYZABCDEFGHIJKLMN";
    
    printf("Please give the string you want to convert: ");
    scanf("%s", s1);

    asmConvert(s1, alphabet, s2);
    printf("The converted string is: %s\n", s2);
    
    return 0;
}