#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "cuatrotree.h"

int main (void){
	/*
	char* name = "cambiameporotronombre.txt";
    FILE *pFile = fopen( name, "a" );

    fprintf(pFile,"-\n");

    fclose( pFile );
	*/
	printf("ctTree: %d \n", sizeof(struct ctTree));
	printf("ctTree_t: %d \n", sizeof(struct ctTree_t));
	printf("ctNode: %d \n", sizeof(struct uint8_t));
	printf("ctNode_t: %d \n", sizeof(struct ctNode_t));
	printf("\n");
	printf("uint32_t: %d \n", sizeof(struct uint32_t));
	printf("uint8_t: %d \n", sizeof(struct uint8_t));
	printf("\n");
	




    return 0;
}
