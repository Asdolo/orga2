/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de las rutinas de atencion de interrupciones
*/

#include "isr.h"
#include "idt.h"
#include "defines.h"
#include "screen.h"
#include "colors.h"
#include "i386.h"
#include "mmu.h"
#include "sched.h"


int random=0;
char* idt_mensajes_interrupciones[100] = {

    [INT_DIVIDE_ERROR]                      = "Divide error",
    [INT_NMI_INTERRUPT]                     = "NMI Interrupt",
    [INT_BREAKPOINT]                        = "Breakpoint",
    [INT_OVERFLOW]                          = "Overflow",
    [INT_BOUND_RANGE_EXCEEDED]              = "BOUND Range Exceeded",
    [INT_INVALID_OPCODE]                    = "Invalid Opcode (Undefined Opcode)",
    [INT_DEVICE_NOT_AVAILABLE]              = "Device Not Available (No math Coprocessor)",
    [INT_DOUBLE_FAULT]                      = "Double fault",
    [INT_COMPRESSOR_SEGMENT_OVERRUN]        = "Compressor Segment Overrun (reserved)",
    [INT_INVALID_TSS]                       = "Invalid TSS",
    [INT_SEGMENT_NOT_PRESSENT]              = "Segment Not Present",
    [INT_STACK_SEGMENT_FAULT]               = "Stack-Segment Fault",
    [INT_GENERAL_PROTECTION]                = "General Protection",
    [INT_PAGE_FAULT]                        = "Page Fault",
    [INT_X87_FPU_FLOATING_POINT_ERROR]      = "x87 FPU Floating-Point Error (Math Fault)",
    [INT_ALIGNMENT_CHECK]                   = "Alignment Check",
    [INT_MACHINE_CHECK]                     = "Machine Check",
    [INT_SIMD_FLOATING_POINT_EXCEPTION]     = "SIMD Floating-Point Exception",



    // Errores de tareas, Sistema Operativo, etc (no del procesador)
    [CODIGO_ERROR_TAREA_LLAMA_SYSCALL_66]   = "Error Tarea llama int 0x66",
    [CODIGO_ERROR_BANDERA_LLAMA_SYSCALL_50] = "Error Bandera llama int 0x50"

};



char* scancode_to_char[12] = {
    [2]                                  = "1",
    [3]                                  = "2",
    [4]                                  = "3",
    [5]                                  = "4",
    [6]                                  = "5",
    [7]                                  = "6",
    [8]                                  = "7",
    [9]                                  = "8",
    [10]                                 = "9",
    [11]                                 = "0"

};

char* idt_ultimo_problema = "No hubo interrupciones";

idt_entry idt[255] = { };

idt_descriptor IDT_DESC = {
    sizeof(idt) - 1,
    (unsigned int) &idt
};


/*
    La siguiente es una macro de EJEMPLO para ayudar a armar entradas de
    interrupciones. Para usar, descomentar y completar CORRECTAMENTE los
    atributos y el registro de segmento. Invocarla desde idt_inicializar() de
    la siguiene manera:

    void idt_inicializar() {
        IDT_ENTRY(0);
        ...
        IDT_ENTRY(19);

        ...
    }
*/


#define IDT_ENTRY(numero) \
    idt[numero].offset_0_15 = (unsigned short) ((unsigned int)(&_isr ## numero) & (unsigned int) 0xFFFF); \
    idt[numero].segsel = (unsigned short) GDT_IDX_C0_DESC << 3;  \
    idt[numero].attr = (unsigned short) 0x8E00; \
    if (numero == 80 || numero == 102) \
    { \
        idt[numero].attr = (unsigned short) 0xEE00; \
    }else{ \
        idt[numero].attr = (unsigned short) 0x8E00; \
    } \
    idt[numero].offset_16_31 = (unsigned short) ((unsigned int)(&_isr ## numero) >> 16 & (unsigned int) 0xFFFF);



void idt_inicializar() {
    // Excepciones
    /*
        Esto ejecuta una macro que completa la IDT
        automáticamente, no hace falta hacerla manual como la GDT
    */

    // Excepciones de Intel
    IDT_ENTRY(0);
    // IDT_ENTRY(1); // RESERVED
    IDT_ENTRY(2);
    IDT_ENTRY(3);
    IDT_ENTRY(4);
    IDT_ENTRY(5);
    IDT_ENTRY(6);
    IDT_ENTRY(7);
    IDT_ENTRY(8);
    IDT_ENTRY(9);
    IDT_ENTRY(10);
    IDT_ENTRY(11);
    IDT_ENTRY(12);
    IDT_ENTRY(13);
    IDT_ENTRY(14);
    // IDT_ENTRY(15); // (Intel reserved. Do not use.)
    IDT_ENTRY(16);
    IDT_ENTRY(17);
    IDT_ENTRY(18);
    IDT_ENTRY(19);
    // IDT_ENTRY(20); // Intel reserved. Do not use.
    // IDT_ENTRY(21); // Intel reserved. Do not use.
    // IDT_ENTRY(22); // Intel reserved. Do not use.
    // IDT_ENTRY(23); // Intel reserved. Do not use.
    // IDT_ENTRY(24); // Intel reserved. Do not use.
    // IDT_ENTRY(25); // Intel reserved. Do not use.
    // IDT_ENTRY(26); // Intel reserved. Do not use.
    // IDT_ENTRY(27); // Intel reserved. Do not use.
    // IDT_ENTRY(28); // Intel reserved. Do not use.
    // IDT_ENTRY(29); // Intel reserved. Do not use.
    // IDT_ENTRY(30); // Intel reserved. Do not use.
    // IDT_ENTRY(31); // Intel reserved. Do not use.
    IDT_ENTRY(32);
    IDT_ENTRY(33);

    IDT_ENTRY(80);
    IDT_ENTRY(102);
}


void isr_atender_excepcion(int exception){

    //screen_colorear(0, 0, 79, 24, C_BG_RED);
    idt_ultimo_problema = idt_mensajes_interrupciones[exception];
    screen_imprimir(idt_mensajes_interrupciones[exception], C_FG_WHITE, C_BG_GREEN, 0, 0, 0, 0, 0);

    actualizar_pantalla();
}

void atender_teclado(int scancode)
{
    if (scancode == 0x32 && modo_pantalla == 0)
    {
        // seteo la pantalla a modo mapa
        modo_pantalla = 1;

    }else if(scancode == 0x12 && modo_pantalla==1){
        // seteo la pantalla a modo estado
        modo_pantalla = 0;
    }

    actualizar_pantalla();
    return;
}



void fondear_c(int* cr3, int fisica)
{
    mmu_mapear_pagina(cr3, PAGINA_ANCLA_VIRTUAL_TAREA, fisica);
}

void canonear_c(char* destino, int fuente)
{
    char* fuenteFisica;
    fuente = fuente - 0x40000000;

    if (fuente < 0x1000)
    {
        fuenteFisica = (char*) (fuente + direcciones_fisicas_tarea_pagina1[tareaActual]);
    }
    else
    {
        fuenteFisica = (char*) (fuente + direcciones_fisicas_tarea_pagina2[tareaActual]);
    }

    copiar_bytes(destino, fuenteFisica, 97);
}

void navegar_c(int fisica1, int fisica2)
{
    mmu_mapear_pagina(directorios_tareas[tareaActual], PAGINA1_VIRTUAL_TAREA, fisica1);
    mmu_mapear_pagina(directorios_tareas[tareaActual], PAGINA2_VIRTUAL_TAREA, fisica2);


    copiar_int((int*) fisica1, direcciones_fisicas_tarea_pagina1[tareaActual], 0x1000);
    copiar_int((int*) fisica2, direcciones_fisicas_tarea_pagina2[tareaActual], 0x1000);

    direcciones_fisicas_tarea_pagina1[tareaActual] = (void*) fisica1;
    direcciones_fisicas_tarea_pagina2[tareaActual] = (void*) fisica2;
}

