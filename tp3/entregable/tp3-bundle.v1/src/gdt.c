/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de la tabla de descriptores globales
*/
 
#include "gdt.h"
#include "tss.h"

gdt_entry gdt[GDT_COUNT] = {
    /* Descriptor nulo*/
    /* Offset = 0x00 */
    [GDT_IDX_NULL_DESC] = (gdt_entry) {
        (unsigned short)    0x0000,         /* limit[0:15]  */
        (unsigned short)    0x0000,         /* base[0:15]   */
        (unsigned char)     0x00,           /* base[23:16]  */
        (unsigned char)     0x00,           /* type         */
        (unsigned char)     0x00,           /* s            */
        (unsigned char)     0x00,           /* dpl          */
        (unsigned char)     0x00,           /* p            */
        (unsigned char)     0x00,           /* limit[16:19] */
        (unsigned char)     0x00,           /* avl          */
        (unsigned char)     0x00,           /* l            */
        (unsigned char)     0x00,           /* db           */
        (unsigned char)     0x00,           /* g            */
        (unsigned char)     0x00,           /* base[31:24]  */
    },

    /* codigo level 0 */
    /* Completar */
    [GDT_IDX_C0_DESC] = (gdt_entry) {
        (unsigned short)    0xFFFF,         /* limit[0:15]  */
        (unsigned short)    0x0000,         /* base[0:15]   */
        (unsigned char)     0x00,           /* base[23:16]  */
        (unsigned char)     0x08,           /* type         = Execute-Only */
        (unsigned char)     0x01,           /* s            */
        (unsigned char)     0x00,           /* dpl          */
        (unsigned char)     0x01,           /* p            */
        (unsigned char)     0x06,           /* limit[16:19] */
        (unsigned char)     0x00,           /* avl          */
        (unsigned char)     0x00,           /* l            */
        (unsigned char)     0x01,           /* db           */
        (unsigned char)     0x01,           /* g            */
        (unsigned char)     0x00,           /* base[31:24]  */
    },
    [GDT_IDX_C3_DESC] = (gdt_entry) {
        (unsigned short)    0xFFFF,         /* limit[0:15]  */
        (unsigned short)    0x0000,         /* base[0:15]   */
        (unsigned char)     0x00,           /* base[23:16]  */
        (unsigned char)     0x08,           /* type         = Execute-Only */
        (unsigned char)     0x01,           /* s            */
        (unsigned char)     0x03,           /* dpl          */
        (unsigned char)     0x01,           /* p            */
        (unsigned char)     0x06,           /* limit[16:19] */
        (unsigned char)     0x00,           /* avl          */
        (unsigned char)     0x00,           /* l            */
        (unsigned char)     0x01,           /* db           */
        (unsigned char)     0x01,           /* g            */
        (unsigned char)     0x00,           /* base[31:24]  */
    },

    [GDT_IDX_D0_DESC] = (gdt_entry) {
        (unsigned short)    0xFFFF,         /* limit[0:15]  */
        (unsigned short)    0x0000,         /* base[0:15]   */
        (unsigned char)     0x00,           /* base[23:16]  */
        (unsigned char)     0x02,           /* type         = Read/Write */
        (unsigned char)     0x01,           /* s            */
        (unsigned char)     0x00,           /* dpl          */
        (unsigned char)     0x01,           /* p            */
        (unsigned char)     0x06,           /* limit[16:19] */
        (unsigned char)     0x00,           /* avl          */
        (unsigned char)     0x00,           /* l            */
        (unsigned char)     0x01,           /* db           */
        (unsigned char)     0x01,           /* g            */
        (unsigned char)     0x00,           /* base[31:24]  */
    },
    [GDT_IDX_D3_DESC] = (gdt_entry) {
        (unsigned short)    0xFFFF,         /* limit[0:15]  */
        (unsigned short)    0x0000,         /* base[0:15]   */
        (unsigned char)     0x00,           /* base[23:16]  */
        (unsigned char)     0x02,           /* type         = Read/Write */
        (unsigned char)     0x01,           /* s            */
        (unsigned char)     0x03,           /* dpl          */
        (unsigned char)     0x01,           /* p            */
        (unsigned char)     0x06,           /* limit[16:19] */
        (unsigned char)     0x00,           /* avl          */
        (unsigned char)     0x00,           /* l            */
        (unsigned char)     0x01,           /* db           */
        (unsigned char)     0x01,           /* g            */
        (unsigned char)     0x00,           /* base[31:24]  */
    },

    [GDT_IDX_V_DESC] = (gdt_entry) {
        (unsigned short)    0x0F9F,         /* limit[0:15]  */
        (unsigned short)    0x8000,         /* base[0:15]   */
        (unsigned char)     0x0B,           /* base[23:16]  */
        (unsigned char)     0x02,           /* type         = Read/Write */
        (unsigned char)     0x01,           /* s            */
        (unsigned char)     0x00,           /* dpl          */
        (unsigned char)     0x01,           /* p            */
        (unsigned char)     0x00,           /* limit[16:19] */
        (unsigned char)     0x00,           /* avl          */
        (unsigned char)     0x00,           /* l            */
        (unsigned char)     0x01,           /* db           */
        (unsigned char)     0x00,           /* g            */
        (unsigned char)     0x00,           /* base[31:24]  */
    },

};
 
gdt_descriptor GDT_DESC = {
    sizeof(gdt) - 1,
    (unsigned int) &gdt
};


void gdt_init_tss()
{



    //tss
    gdt[GDT_IDX_T_INIT_DESC] = (gdt_entry) {
        (unsigned short)    0x67,                       /* limit[0:15]  */
        (unsigned short)    (unsigned int)(&tarea_inicial),           /* base[0:15]   */
        (unsigned char)     (unsigned int)(&tarea_inicial)>>16,       /* base[23:16]  */
        (unsigned char)     0x09,                       /* type         = Read/Write */
        (unsigned char)     0x00,                       /* s            */
        (unsigned char)     0x00,                       /* dpl          */
        (unsigned char)     0x01,                       /* p            */
        (unsigned char)     0x00,                       /* limit[16:19] */
        (unsigned char)     0x00,                       /* avl          */
        (unsigned char)     0x00,                       /* l            */
        (unsigned char)     0x00,                       /* db           */
        (unsigned char)     0x00,                       /* g byte          */
        (unsigned char)     (unsigned int)(&tarea_inicial)>>24,                       /* base[31:24]  */
    };

    gdt[GDT_IDX_T_IDLE_DESC] = (gdt_entry) {
        (unsigned short)    0x67,                       /* limit[0:15]  */
        (unsigned short)    (unsigned int)(&tarea_idle),           /* base[0:15]   */
        (unsigned char)     (unsigned int)(&tarea_idle)>>16,       /* base[23:16]  */
        (unsigned char)     0x09,                       /* type         = Read/Write */
        (unsigned char)     0x00,                       /* s            */
        (unsigned char)     0x00,                       /* dpl          */
        (unsigned char)     0x01,                       /* p            */
        (unsigned char)     0x00,                       /* limit[16:19] */
        (unsigned char)     0x00,                       /* avl          */
        (unsigned char)     0x00,                       /* l            */
        (unsigned char)     0x00,                       /* db           */
        (unsigned char)     0x00,                       /* g byte          */
        (unsigned char)     (unsigned int)(&tarea_idle)>>24,                       /* base[31:24]  */
    };

    int i;
    for (i = GDT_IDX_T1_DESC; i < GDT_IDX_T8_DESC + 1; i++)
    {
        
        gdt[i] = (gdt_entry) {
            (unsigned short)    0x67,                       /* limit[0:15]  */
            (unsigned short)    (unsigned int)(&(tss_navios[i-GDT_IDX_T1_DESC])),           /* base[0:15]   */
            (unsigned char)     (unsigned int)(&(tss_navios[i-GDT_IDX_T1_DESC]))>>16,       /* base[23:16]  */
            (unsigned char)     0x09,                       /* type         = Read/Write */
            (unsigned char)     0x00,                       /* s            */
            (unsigned char)     0x00,                       /* dpl          */
            (unsigned char)     0x01,                       /* p            */
            (unsigned char)     0x00,                       /* limit[16:19] */
            (unsigned char)     0x00,                       /* avl          */
            (unsigned char)     0x00,                       /* l            */
            (unsigned char)     0x00,                       /* db           */
            (unsigned char)     0x00,                       /* g byte          */
            (unsigned char)     (unsigned int)(&(tss_navios[i-GDT_IDX_T1_DESC]))>>24,                       /* base[31:24]  */
        };
    }


    for (i = GDT_IDX_T1_FLAG_DESC; i < GDT_IDX_T8_FLAG_DESC + 1; i++)
    {
        
        gdt[i] = (gdt_entry) {
            (unsigned short)    0x67,                       /* limit[0:15]  */
            (unsigned short)    (unsigned int)(&(tss_banderas[i-GDT_IDX_T1_FLAG_DESC])),           /* base[0:15]   */
            (unsigned char)     (unsigned int)(&(tss_banderas[i-GDT_IDX_T1_FLAG_DESC]))>>16,       /* base[23:16]  */
            (unsigned char)     0x09,                       /* type         = Read/Write */
            (unsigned char)     0x00,                       /* s            */
            (unsigned char)     0x00,                       /* dpl          */
            (unsigned char)     0x01,                       /* p            */
            (unsigned char)     0x00,                       /* limit[16:19] */
            (unsigned char)     0x00,                       /* avl          */
            (unsigned char)     0x00,                       /* l            */
            (unsigned char)     0x00,                       /* db           */
            (unsigned char)     0x00,                       /* g byte          */
            (unsigned char)     (unsigned int)(&(tss_banderas[i-GDT_IDX_T1_FLAG_DESC]))>>24,                       /* base[31:24]  */
        };
    }

}