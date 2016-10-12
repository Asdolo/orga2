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


char* idt_mensajes_interrupciones[20] = {

    [0] = "Division por cero papa!!!!"

};

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
}


// preguntar la signatura
void isr_atender_excepcion(int exception){

    screen_imprimir(idt_mensajes_interrupciones[exception], 0x0B, 0x00, 0x00, 0x00, 0x00);
}