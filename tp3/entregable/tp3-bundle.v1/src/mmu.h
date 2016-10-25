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

void mmu_inicializar_dir_tarea();
void mmu_inicializar_dir_kernel();
void mmu_mapear_pagina();
void mmu_unmapear_pagina();
void* proximaPaginaLibre();

/*
void* proximaPaginaLibre();
*/
