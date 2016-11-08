/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de estructuras para administrar tareas
*/

#include "tss.h"
#include "defines.h"
#include "mmu.h"


//declarar mas
tss tarea_inicial;
tss tarea_idle;

tss tss_navios[CANT_TAREAS];
tss tss_banderas[CANT_TAREAS];

void tss_inicializar() {
	

	// Tarea Idle
	tarea_idle.cr3 = DIRECTORIO_PAGINAS_KERNEL_POS;
	tarea_idle.eip = PAGINA1_VIRTUAL_TAREA;  
	tarea_idle.eflags = 0x202; 							//0x202 = permite interrupciones (externas), 0x002 = no permite interupciones (externas)
														// de todas formas, siempre va 0x002 como minimo en los flags ya que sin ese bit explota todo
	tarea_idle.ebp = TASK_IDLE_STACK_RING_0;
	tarea_idle.esp = TASK_IDLE_STACK_RING_0;

	tarea_idle.cs = (GDT_IDX_D0_DESC << 3); 
	tarea_idle.es = (GDT_IDX_D0_DESC << 3); 
	tarea_idle.ss = (GDT_IDX_D0_DESC << 3); 
	tarea_idle.ds = (GDT_IDX_D0_DESC << 3);	
	tarea_idle.fs = (GDT_IDX_D0_DESC << 3); 
	tarea_idle.gs = (GDT_IDX_D0_DESC << 3); 

	tarea_idle.edi = 0x00;
	tarea_idle.esi = 0x00;
	tarea_idle.ebx = 0x00;
	tarea_idle.edx = 0x00;
	tarea_idle.ecx = 0x00;
	tarea_idle.eax = 0x00;

	tarea_idle.ss0 = (GDT_IDX_D0_DESC << 3);
	tarea_idle.esp0 = TASK_IDLE_STACK_RING_0;


	// Tarea inicial
	tarea_inicial.cr3 = 0x00;
	tarea_inicial.eip = 0x00;
	tarea_inicial.eflags = 0x00; 							//0x202 = permite interrupciones (externas), 0x002 = no permite interupciones (externas)
														// de todas formas, siempre va 0x002 como minimo en los flags ya que sin ese bit explota todo
	tarea_inicial.ebp = 0x00;
	tarea_inicial.esp = 0x00;

	tarea_inicial.cs = 0x00; 
	tarea_inicial.es = 0x00; 
	tarea_inicial.ss = 0x00; 
	tarea_inicial.ds = 0x00;	
	tarea_inicial.fs = 0x00; 
	tarea_inicial.gs = 0x00; 

	tarea_inicial.edi = 0x00;
	tarea_inicial.esi = 0x00;
	tarea_inicial.ebx = 0x00;
	tarea_inicial.edx = 0x00;
	tarea_inicial.ecx = 0x00;
	tarea_inicial.eax = 0x00;

	tarea_inicial.ss0 = 0x00;
	tarea_inicial.esp0 = 0x00;


	// tss de las tareas
	int i;
	for (i = 0; i < 8; i++)
	{
		tss_navios[i].cr3 = (unsigned int) directorios_tareas[i]; //directorio 0 = directorio tarea 1
		tss_navios[i].eip = PAGINA1_VIRTUAL_TAREA;  
		tss_navios[i].eflags = 0x202; //permite interrupciones
		tss_navios[i].ebp = PILA_VIRTUAL_TAREA_NIVEL_3;
		tss_navios[i].esp = PILA_VIRTUAL_TAREA_NIVEL_3;

		tss_navios[i].cs = ((GDT_IDX_D3_DESC << 3) | 0X03); 
		tss_navios[i].es = ((GDT_IDX_D3_DESC << 3) | 0X03); 
		tss_navios[i].ss = ((GDT_IDX_D3_DESC << 3) | 0X03); 
		tss_navios[i].ds = ((GDT_IDX_D3_DESC << 3) | 0X03);	
		tss_navios[i].fs = ((GDT_IDX_D3_DESC << 3) | 0X03); 
		tss_navios[i].gs = ((GDT_IDX_D3_DESC << 3) | 0X03); 
		
		tss_navios[i].edi = 0x00;
		tss_navios[i].esi = 0x00;
		tss_navios[i].ebx = 0x00;
		tss_navios[i].edx = 0x00;
		tss_navios[i].ecx = 0x00;
		tss_navios[i].eax = 0x00;
		
		tss_navios[i].ss0 = (GDT_IDX_D0_DESC << 3);
		tss_navios[i].esp0 = (unsigned int) (proximaPaginaLibre()) + 0x1000; 
	}
	

	// tss de las banderas
	for (i = 0; i < 8; i++)
	{
		tss_banderas[i].cr3 = (unsigned int) directorios_tareas[i]; //directorio 0 = directorio tarea 1
		tss_banderas[i].eip = *((unsigned int*)(0x10000 + (i * 0x2000) + 0x1FCCC)); // leemos el eip original que está en el código en el kernel
		tss_banderas[i].eflags = 0x202; //permite interrupciones
		tss_banderas[i].ebp = PILA_VIRTUAL_BANDERA_NIVEL_3;
		tss_banderas[i].esp = PILA_VIRTUAL_BANDERA_NIVEL_3;

		tss_banderas[i].cs = ((GDT_IDX_D3_DESC << 3) | 0X03); 
		tss_banderas[i].es = ((GDT_IDX_D3_DESC << 3) | 0X03); 
		tss_banderas[i].ss = ((GDT_IDX_D3_DESC << 3) | 0X03); 
		tss_banderas[i].ds = ((GDT_IDX_D3_DESC << 3) | 0X03);	
		tss_banderas[i].fs = ((GDT_IDX_D3_DESC << 3) | 0X03); 
		tss_banderas[i].gs = ((GDT_IDX_D3_DESC << 3) | 0X03); 
		
		tss_banderas[i].edi = 0x00;
		tss_banderas[i].esi = 0x00;
		tss_banderas[i].ebx = 0x00;
		tss_banderas[i].edx = 0x00;
		tss_banderas[i].ecx = 0x00;
		tss_banderas[i].eax = 0x00;
		
		tss_banderas[i].ss0 = (GDT_IDX_D0_DESC << 3);
		tss_navios[i].esp0 = (unsigned int) (proximaPaginaLibre()) + 0x1000;  
	}
	



}

