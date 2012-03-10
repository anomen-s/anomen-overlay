/* Fake winemenubuilder.exe program */

/* Use MinGW to build it */

#include <stdio.h>


void main(int argc, char** argv)
{
    int i;

//    printf("*********\n");

    printf("%s", argv[0]);

    for (i = 1; i < argc; i++)
	printf(" \"%s\"", argv[i]);

    printf("\n");

}
