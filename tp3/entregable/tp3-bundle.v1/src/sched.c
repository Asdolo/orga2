/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#include "sched.h"
#include "defines.h"
#include "i386.h"

char corriendoBanderas;
unsigned int tareaActual;
unsigned int banderaActual;
char contadorTareas;
char contadorBanderas;
char cantTareasVivas;

int indicesTareas[8];
int indicesBanderas[8];

void sched_inicializar() {

	int i;
	for(i=0;i<8;i++)
	{
		indicesTareas[i] = (GDT_IDX_T1_DESC+i)<<3;
	}
	for(i=0;i<8;i++)
	{
		indicesBanderas[i]= (GDT_IDX_T1_FLAG_DESC+i)<<3;
	}

	tareaActual = -1;
	banderaActual = -1;
	corriendoBanderas=0;
	contadorTareas=0;
	contadorBanderas=0;
	cantTareasVivas=8;
}

unsigned short sched_proximo_indice() {

	if (cantTareasVivas != 0)
	{


		if(!corriendoBanderas)
		{

			// Me fijo si ya ejecuté 3 tareas
			if(++contadorTareas==4)
			{
				breakpoint();
				// Ya corrí 3 tareas
				// Empiezo a correr banderas
				corriendoBanderas=1;
				contadorTareas = 0;

				return indicesBanderas[buscarIndiceSiguienteViva(1)]; // El 1 en indicesBanderas indica que busque en banderas
			}
			else
			{
				// Busco la siguiente tarea a ejecutar
				return indicesTareas[buscarIndiceSiguienteViva(0)];
			}

		}
		else
		{

			if(++contadorBanderas == cantTareasVivas)
			{
				//Termine de correr banderas
				// Busco la siguiente tarea a ejecutar
				corriendoBanderas = 0;
				contadorBanderas=0;

				return indicesTareas[buscarIndiceSiguienteViva(0)];
			}
			else
			{
				// Busco la siguiente bandera a ejecutar
				return indicesBanderas[buscarIndiceSiguienteViva(1)]; // El 1 en indicesBanderas indica que busque en banderas
			}
		}
	}
	else
	{
		return 0;
	}
}


// Devuelve el índice en el arreglo de la siguiente tarea/bandera viva
unsigned char buscarIndiceSiguienteViva(char esBandera)
{
	if (esBandera)
	{
		banderaActual = (banderaActual + 1)%8;
		while (indicesBanderas[banderaActual] == 0)
		{
			banderaActual = (banderaActual  + 1)%8;
		}
		return banderaActual;
	}
	else
	{
		tareaActual = (tareaActual + 1)%8;
		while (indicesTareas[tareaActual] == 0)
		{
			tareaActual = (tareaActual + 1)%8;
		}
		return tareaActual;
	}
}
