#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "cuatrotree.h"

int main (void){

	char* name = "cambiameporotronombre.txt";
    FILE *pFile = fopen( name, "a" );

    fprintf(pFile,"-\n");

    fclose( pFile );

	printf("ctTree: %d bytes\n", sizeof(ctTree));
	printf("ctTree_t: %d bytes\n", sizeof(struct ctTree_t));
	printf("\n");
	printf("ctNode: %d bytes\n", sizeof(ctNode));
	printf("ctNode_t: %d bytes\n", sizeof(struct ctNode_t));
	printf("\n");
	printf("ctIter: %d bytes\n", sizeof(ctIter));
	printf("ctIter_t: %d bytes\n", sizeof(struct ctIter_t));
	printf("\n");
	printf("uint32_t: %d bytes\n", sizeof(uint32_t));
	printf("uint8_t: %d bytes\n", sizeof(uint8_t));
	printf("\n");


	printf("Direccion: %d bytes\n", sizeof(ctTree*));
	printf("Direccion: %d bytes\n", sizeof(int*));
	printf("\n");


		int jorge = 123;
		ctTree* miPuntero;

		printf("jorge = %d\n", jorge);
		printf("&jorge = %p\n", (void *)&jorge);

		printf("miPuntero = %ld\n", miPuntero);
		printf("&miPuntero = %p\n", (void *)&miPuntero);
		printf("*miPuntero = %d\n", *miPuntero);


		printf("root = %p\n", (miPuntero)->root);
		printf("size = %d\n", (*miPuntero).size);

		ct_new(&miPuntero);

		printf("root = %p\n", (miPuntero)->root);
		printf("size = %ld\n", (*miPuntero).size);


		ct_delete(&miPuntero);
		printf("Termine de eliminar\n");
		printf("root = %p\n", (miPuntero)->root);
		printf("size = %ld\n", (*miPuntero).size);
    return 0;
}
