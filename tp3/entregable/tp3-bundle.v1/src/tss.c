/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de estructuras para administrar tareas
*/

#include "tss.h"
#include "defines.h"


//declarar mas
tss tarea_inicial;
tss tarea_idle;

tss tss_navios[CANT_TAREAS];
tss tss_banderas[CANT_TAREAS];

void tss_inicializar() {
	
	// preguntar que va en cada cosa

	// preguntar por que nos piden mapear la pagina de la idle con identity mapping si el cr3 que nos dicen de poner es el del kernel
	// Tarea Idle
	tarea_idle.cr3 = DIRECTORIO_PAGINAS_KERNEL_POS;
	tarea_idle.eip = TASK_IDLE_CODE_SRC_ADDR;  // Preguntar si va 0x20000 (codigo de la tarea idle en el kernel) o si va 0x40000000 (direccion virtual del codigo de la tarea idle) y en ese caso, copiarlo a dicha direccion en la funcion mnu_inicializar_memoria_tareas
	tarea_idle.eflags = 0x02;
	tarea_idle.ebp = 0x2A000;
	tarea_idle.esp = 0x2A000;
	tarea_idle.cs = ((GDT_IDX_C3_DESC)<<3)|0x03; //le seteamos CPL en 3 porque es un segmento nivel 3

	tarea_idle.es = ((GDT_IDX_D3_DESC)<<3)|0x03; //le seteamos RPL en 3 porque es un segmento nivel 3
	tarea_idle.ss = ((GDT_IDX_D3_DESC)<<3)|0x03; //le seteamos RPL en 3 porque es un segmento nivel 3
	tarea_idle.ds = ((GDT_IDX_D3_DESC)<<3)|0x03; //le seteamos RPL en 3 porque es un segmento nivel 3
	tarea_idle.fs = ((GDT_IDX_D3_DESC)<<3)|0x03; //le seteamos RPL en 3 porque es un segmento nivel 3
	tarea_idle.gs = ((GDT_IDX_D3_DESC)<<3)|0x03; //le seteamos RPL en 3 porque es un segmento nivel 3
	
	tarea_idle.edi = 0x00;
	tarea_idle.esi = 0x00;
	tarea_idle.ebx = 0x00;
	tarea_idle.edx = 0x00;
	tarea_idle.ecx = 0x00;
	tarea_idle.eax = 0x00;

	tarea_idle.ss0 = (GDT_IDX_D0_DESC << 3);
	tarea_idle.esp0 = 0x00; //preguntar








}

