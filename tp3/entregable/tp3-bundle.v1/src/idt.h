/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de las rutinas de atencion de interrupciones
*/

#ifndef __IDT_H__
#define __IDT_H__


/* Struct de descriptor de IDT */
typedef struct str_idt_descriptor {
    unsigned short  idt_length;
    unsigned int    idt_addr;
} __attribute__((__packed__)) idt_descriptor;

/* Struct de una entrada de la IDT */
typedef struct str_idt_entry_fld {
    unsigned short offset_0_15;
    unsigned short segsel;
    unsigned short attr;
    unsigned short offset_16_31;
} __attribute__((__packed__, aligned (8))) idt_entry;

extern idt_entry idt[];
extern idt_descriptor IDT_DESC;

extern char* idt_ultimo_problema;

void idt_inicializar();
void atender_teclado(int scancode);

void fondear_c(int* cr3, int fisica);
void canonear_c(char* destino, int fuente);
void navegar_c(int fisica1, int fisica2);
void actualizar_buffer();

void marcar_en_mapa(int fisica, char c, char bgcolor);

extern int eax_error;
extern int ebx_error;
extern int ecx_error;
extern int edx_error;
extern int esi_error;
extern int edi_error;
extern int ebp_error;
extern int esp_error;
extern int eip_error;
extern int cr0_error;
extern int cr2_error;
extern int cr3_error;
extern int cr4_error;
extern short cs_error;
extern short ds_error;
extern short es_error;
extern short fs_error;
extern short gs_error;
extern short ss_error;
extern int eflags_error;
void imprimirRegistros();

#endif  /* !__IDT_H__ */
