/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del manejador de memoria
*/

#ifndef __MMU_H__
#define __MMU_H__


#endif	/* !__MMU_H__ */
void* libre;
void* libreMar;

void* mmu_inicializar_dir_tarea(int t);
void mmu_inicializar_dir_kernel();
void mmu_mapear_pagina(int* dp, int virtual, int fisica);
void mmu_unmapear_pagina(int* dp, int virtual);
void mnu_inicializar_memoria_tareas();
void* proximaPaginaLibre();
void* proximaPaginaLibreDelMar();
void identity_mapping(int directorio_pos, int tabla1_pos, int tabla2_pos);
void copiar(int* dest, int* source, int size);

void* directorios_tareas[8];
/*
void* proximaPaginaLibre();
*/
