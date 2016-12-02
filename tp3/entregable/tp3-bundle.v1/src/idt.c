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

    [INT_DIVIDE_ERROR]                      = "Divide error              ",
    [INT_NMI_INTERRUPT]                     = "NMI Interrupt             ",
    [INT_BREAKPOINT]                        = "Breakpoint                ",
    [INT_OVERFLOW]                          = "Overflow                  ",
    [INT_BOUND_RANGE_EXCEEDED]              = "BOUND Range Exceeded      ",
    [INT_INVALID_OPCODE]                    = "Invalid Opcode            ",
    [INT_DEVICE_NOT_AVAILABLE]              = "Device Not Available      ",
    [INT_DOUBLE_FAULT]                      = "Double fault              ",
    [INT_COMPRESSOR_SEGMENT_OVERRUN]        = "Coprocessor Overrun       ",
    [INT_INVALID_TSS]                       = "Invalid TSS               ",
    [INT_SEGMENT_NOT_PRESSENT]              = "Segment Not Present       ",
    [INT_STACK_SEGMENT_FAULT]               = "Stack-Segment Fault       ",
    [INT_GENERAL_PROTECTION]                = "General Protection        ",
    [INT_PAGE_FAULT]                        = "Page Fault                ",
    [INT_X87_FPU_FLOATING_POINT_ERROR]      = "x87 FPU Floating-Point    ",
    [INT_ALIGNMENT_CHECK]                   = "Alignment Check           ",
    [INT_MACHINE_CHECK]                     = "Machine Check             ",
    [INT_SIMD_FLOATING_POINT_EXCEPTION]     = "SIMD Floating-Point Error ",
    // Errores de tareas, Sistema Operativo, etc (no del procesador)
    [CODIGO_ERROR_TAREA_LLAMA_SYSCALL_66]   = "int 0x66 error            ",
    [CODIGO_ERROR_BANDERA_LLAMA_SYSCALL_50] = "int 0x50 error            "

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





int eax_error;
int ebx_error;
int ecx_error;
int edx_error;
int esi_error;
int edi_error;
int ebp_error;
int esp_error;
int eip_error;
int cr0_error;
int cr2_error;
int cr3_error;
int cr4_error;
short cs_error;
short ds_error;
short es_error;
short fs_error;
short gs_error;
short ss_error;
int eflags_error;





char* idt_ultimo_problema = "No hubo interrupciones    ";

idt_entry idt[255] = { };

idt_descriptor IDT_DESC = {
    sizeof(idt) - 1,
    (unsigned int) &idt
};


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
    screen_imprimir(idt_mensajes_interrupciones[exception], C_FG_WHITE, C_BG_RED, 0, 50, 1, 0, 0);

    char tareaOBandera[3];

    if (corriendoBanderas)
    {
        tareaOBandera[0] = 'B';
        tareaOBandera[1] = banderaActual + 0x30;
    }
    else
    {
        tareaOBandera[0] = 'T';
        tareaOBandera[1] = tareaActual + 0x30;
    } 
    tareaOBandera[2] = 0;

    screen_imprimir((char*) tareaOBandera, C_FG_WHITE, C_BG_GREEN, 0, 76, 1, 1, 0);


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



void marcar_en_mapa(int fisica, char c, char bgcolor)
{
    int numero_de_pagina = fisica >> 12;

    char x = (numero_de_pagina % 80);
    char y = (numero_de_pagina / 80);

    char buffer[2];
    buffer[0] = c;
    buffer[1] = 0x00;

    screen_imprimir((char*) buffer, C_BG_LIGHT_GREY, bgcolor, 0, x, y, 0, 1);
}

void fondear_c(int* cr3, int fisica)
{
    int ancla_vieja = (int) direcciones_fisicas_tarea_ancla[tareaActual];
    mmu_mapear_pagina(cr3, PAGINA_ANCLA_VIRTUAL_TAREA, fisica);

    // Despintamos el ancla vieja
    marcar_en_mapa(ancla_vieja, ' ', C_FG_GREEN);

    // Pintamos el ancla nueva
    marcar_en_mapa(fisica, (char) (tareaActual + 0x30), C_FG_RED);

    actualizar_pantalla();

    direcciones_fisicas_tarea_ancla[tareaActual] = (void*) fisica;
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











void imprimirRegistros(){
   
    char buffer[9];
   
    int_to_string_hex8(eax_error,buffer);
    screen_imprimir((char*) buffer, C_FG_WHITE, C_BG_GREEN, 0, 55, 2, 1, 0);
 
    int_to_string_hex8(ebx_error,buffer);
    screen_imprimir((char*) buffer, C_FG_WHITE, C_BG_GREEN, 0, 55, 3, 1, 0);
 
    int_to_string_hex8(ecx_error,buffer);
    screen_imprimir((char*) buffer, C_FG_WHITE, C_BG_GREEN, 0, 55, 4, 1, 0);
 
    int_to_string_hex8(edx_error,buffer);
    screen_imprimir((char*) buffer, C_FG_WHITE, C_BG_GREEN, 0, 55, 5, 1, 0);
   
    int_to_string_hex8(esi_error,buffer);
    screen_imprimir((char*) buffer, C_FG_WHITE, C_BG_GREEN, 0, 55, 6, 1, 0);
 
    int_to_string_hex8(edi_error,buffer);
    screen_imprimir((char*) buffer, C_FG_WHITE, C_BG_GREEN, 0, 55, 7, 1, 0);
 
    int_to_string_hex8(ebp_error,buffer);
    screen_imprimir((char*) buffer, C_FG_WHITE, C_BG_GREEN, 0, 55, 8, 1, 0);
 
    int_to_string_hex8(esp_error,buffer);
    screen_imprimir((char*) buffer, C_FG_WHITE, C_BG_GREEN, 0, 55, 9, 1, 0);
 
    int_to_string_hex8(eip_error,buffer);
    screen_imprimir((char*) buffer, C_FG_WHITE, C_BG_GREEN, 0, 55, 10, 1, 0);
 
    int_to_string_hex8(cr0_error,buffer);
    screen_imprimir((char*) buffer, C_FG_WHITE, C_BG_GREEN, 0, 55, 11, 1, 0);
 
    int_to_string_hex8(cr2_error,buffer);
    screen_imprimir((char*) buffer, C_FG_WHITE, C_BG_GREEN, 0, 55, 12, 1, 0);
 
    int_to_string_hex8(cr3_error,buffer);
    screen_imprimir((char*) buffer, C_FG_WHITE, C_BG_GREEN, 0, 55, 13, 1, 0);
 
    int_to_string_hex8(cr4_error,buffer);
    screen_imprimir((char*) buffer, C_FG_WHITE, C_BG_GREEN, 0, 55, 14, 1, 0);
 
    int_to_string_hex8((int)cs_error,buffer);
    screen_imprimir((char*) buffer, C_FG_WHITE, C_BG_GREEN, 0, 69, 2, 1, 0);
 
    int_to_string_hex8((int)ds_error,buffer);
    screen_imprimir((char*) buffer, C_FG_WHITE, C_BG_GREEN, 0, 69, 3, 1, 0);
 
    int_to_string_hex8((int)es_error,buffer);
    screen_imprimir((char*) buffer, C_FG_WHITE, C_BG_GREEN, 0, 69, 4, 1, 0);
 
    int_to_string_hex8((int)fs_error,buffer);
    screen_imprimir((char*) buffer, C_FG_WHITE, C_BG_GREEN, 0, 69, 5, 1, 0);
 
    int_to_string_hex8((int)gs_error,buffer);
    screen_imprimir((char*) buffer, C_FG_WHITE, C_BG_GREEN, 0, 69, 6, 1, 0);
 
    int_to_string_hex8((int)ss_error,buffer);
    screen_imprimir((char*) buffer, C_FG_WHITE, C_BG_GREEN, 0, 69, 7, 1, 0);
 
 
    int_to_string_hex8((int)eflags_error,buffer);
    screen_imprimir((char*) buffer, C_FG_WHITE, C_BG_GREEN, 0, 69, 10, 1, 0);
 
 
}