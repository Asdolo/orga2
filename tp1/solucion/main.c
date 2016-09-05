#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "cuatrotree.h"

int main (void){

	// Esto me sirvió mucho al principio:
	/*
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
	*/

		// Ejercicio 2.1:
		ctTree* miArbol;
		ct_new(&miArbol);

		// Ejercicio 2.2:
		ct_add(miArbol, 10);
		ct_add(miArbol, 50);
		ct_add(miArbol, 30);
		ct_add(miArbol, 5);
		ct_add(miArbol, 20);
		ct_add(miArbol, 40);
		ct_add(miArbol, 60);
		ct_add(miArbol, 19);
		ct_add(miArbol, 39);
		ct_add(miArbol, 4);

		// Ejercicio 2.3:
		ctIter* miIterador;
		miIterador = ctIter_new(miArbol);

		// Ejercicio 2.4:
		char* name = "ejercicio2.txt";
		FILE *pFile = fopen( name, "a" );

		
		ctIter_first(miIterador);

		while(ctIter_valid(miIterador)){
			fprintf(pFile, "%i\n", ctIter_get(miIterador));
			ctIter_next(miIterador);
		}
		fclose( pFile );

		// Ejercicio 2.5:
		ctIter_delete(miIterador);

		// Ejercicio 2.6:
		ct_delete(&miArbol);
    return 0;
}
