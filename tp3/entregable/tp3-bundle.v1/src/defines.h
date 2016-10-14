/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================

    Definiciones globales del sistema.
*/

#ifndef __DEFINES_H__
#define __DEFINES_H__

/* Bool */
/* -------------------------------------------------------------------------- */
#define TRUE                    0x00000001
#define FALSE                   0x00000000


/* Misc */
/* -------------------------------------------------------------------------- */
#define CANT_TAREAS             8

#define TAMANO_PAGINA           0x00001000

#define TASK_SIZE               2 * 4096


/* Indices en la gdt */
/* -------------------------------------------------------------------------- */
#define GDT_IDX_NULL_DESC           0

#define GDT_IDX_C0_DESC				18 // segmento de código nivel 0
#define GDT_IDX_C3_DESC				19 // segmento de código nivel 3
#define GDT_IDX_D0_DESC				20 // segmento de datos nivel 0
#define GDT_IDX_D3_DESC				21 // segmento de datos nivel 3
#define GDT_IDX_V_DESC				22 // segmento de memoria de video

/* Direcciones de memoria */
/* -------------------------------------------------------------------------- */
#define BOOTSECTOR              0x00001000 /* direccion fisica de comienzo del bootsector (copiado) */
#define KERNEL                  0x00001200 /* direccion fisica de comienzo del kernel */
#define VIDEO                   0x000B8000 /* direccion fisica del buffer de video */

/* Excepciones e interrupciones en Modo Protegido */
/* -------------------------------------------------------------------------- */
#define INT_DIVIDE_ERROR 					0
#define INT_NMI_INTERRUPT 					2
#define INT_BREAKPOINT 						3
#define INT_OVERFLOW 						4
#define INT_BOUND_RANGE_EXCEEDED			5
#define INT_INVALID_OPCODE					6
#define INT_DEVICE_NOT_AVAILABLE			7
#define INT_DOUBLE_FAULT					8
#define INT_COMPRESSOR_SEGMENT_OVERRUN		9
#define INT_INVALID_TSS						10
#define INT_SEGMENT_NOT_PRESSENT			11
#define INT_STACK_SEGMENT_FAULT				12
#define INT_GENERAL_PROTECTION				13
#define INT_PAGE_FAULT						14
#define INT_X87_FPU_FLOATING_POINT_ERROR	16
#define INT_ALIGNMENT_CHECK					17
#define INT_MACHINE_CHECK					18
#define INT_SIMD_FLOATING_POINT_EXCEPTION	19


/* Direcciones virtuales de código, pila y datos */
/* -------------------------------------------------------------------------- */
#define TASK_CODE               0x40000000 /* direccion virtual del codigo */

#define TASK_IDLE_CODE          0x40000000 /* direccion virtual del codigo de la tarea idle */
#define TASK_IDLE_STACK         0x003D0000 /* direccion virtual de la pila de la tarea idle */
#define TASK_IDLE_STACK_RING_0  0x0002B000 /* direccion fisica de la pila de la tarea idle */

#define TASK_ANCLA              0x40002000
#define TASK_ANCLA_FIS          0x00000000

#define AREA_TIERRA_INICIO      0x00000000  /* 0.0 MB     */
#define AREA_TIERRA_FIN         0x000FFFFF  /* 1.0 MB - 1 */
#define AREA_MAR_INICIO         0x00100000  /* 1.0 MB     */
#define AREA_MAR_FIN            0x0077FFFF  /* 7.5 MB - 1 */

/* Direcciones fisicas de codigos */
/* -------------------------------------------------------------------------- */
/* En estas direcciones estan los códigos de todas las tareas. De aqui se
 * copiaran al destino indicado por TASK_<i>_CODE_ADDR.
 */
#define TASK_1_CODE_SRC_ADDR    0x00010000
#define TASK_2_CODE_SRC_ADDR    0x00012000
#define TAKS_3_CODE_SRC_ADDR    0x00014000
#define TASK_4_CODE_SRC_ADDR    0x00016000
#define TASK_5_CODE_SRC_ADDR    0x00018000
#define TASK_6_CODE_SRC_ADDR    0x0001A000
#define TASK_7_CODE_SRC_ADDR    0x0001C000
#define TASK_8_CODE_SRC_ADDR    0x0001E000

#define TASK_IDLE_CODE_SRC_ADDR 0x00020000

#endif  /* !__DEFINES_H__ */
