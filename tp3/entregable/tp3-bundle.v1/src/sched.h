/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/


#ifndef __SCHED_H__
#define __SCHED_H__




void sched_inicializar();
unsigned short sched_proximo_indice();
unsigned char buscarIndiceSiguienteViva(char esBandera);
char corriendoBanderas;
unsigned int  tareaActual;
unsigned int  banderaActual;
char contadorTareas;
char contadorBanderas;
char cantTareasVivas;




int indicesTareas[8];
int indicesBanderas[8];


#endif	/* !__SCHED_H__ */
