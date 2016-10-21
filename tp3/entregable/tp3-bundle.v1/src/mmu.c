/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del manejador de memoria
*/

#include "mmu.h"
#include "defines.h"
#include "screen.h"
#include "colors.h"



void mmu_inicializar()
{
}

void mmu_inicializar_dir_kernel()
{
	screen_imprimir("Inicializando el directorio y tablas de paginas...", C_FG_LIGHT_CYAN, C_BG_GREEN, 0, 3, 3, 1);


	// Seteamos las Page Directory Entries (son dos)

	int* dir = (int*) DIRECTORIO_TABLA1_POS;

	// Seteamos la dirección de la primer tabla en la primer entrada del directorio y también los flags
	*dir = (TABLA_PAGINAS_1_KERNEL_POS | 0x3);

	dir = (int*) DIRECTORIO_TABLA2_POS;

	// Seteamos la dirección de la segunda tabla en la segunda entrada del directorio y también los flags
	*dir = (TABLA_PAGINAS_2_KERNEL_POS | 0x3);

	int i;
	// Seteamos cada entrada de la tabla 1 (son 1024 paginas, de la 0 a la 1023)

	for (i = 0; i < 1024; i++)
	{
		dir = (int*) (TABLA_PAGINAS_1_KERNEL_POS +  i*4);

		*dir = (i << 12) | 0x3;
	}



	// Seteamos cada entrada de la tabla 2 (son 895, de la 1024 a 1918)
	for (i = 1024; i < 1919; i++)
	{
		dir = (int*) (TABLA_PAGINAS_2_KERNEL_POS +  (i*4) - 1024);

		*dir = (i << 12) | 0x3;
	}


	screen_imprimir("OK", C_FG_LIGHT_GREEN, C_BG_GREEN, 0, 54, 3, 1);


}


int libre;

initmmm
 libre = 0x30000

 damelibre
  m = libre
  inc libre
  return m 

void mmu_mapear_pagina(int* dp, int virtual, int fisica)
{
	int IPD = virtual;
	IPD = IPD >> 22;

	int IPT = virtual;
	IPT = IPT >> 12;
	IPT = IPT & 0x3FF;

	int off = virtual & 0xFFF;

	//dp[IPD]
	int PDE = *(dp + IPD);

	if (!(PDE & 1))
	{
		// No presente,


	}

	int PT = (PDE & 0xFFFFF000);

	*(PT + IPT) = fisica | 0x3; // asumimos fisica es multiplo de 4kb




}
void mmu_unmapear_pagina()
{

}


/*
void* proximaPaginaLibre()
{

}*/