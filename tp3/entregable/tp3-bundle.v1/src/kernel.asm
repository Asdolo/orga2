; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================

%define GDT_IDX_C0_DESC 		18
%define GDT_IDX_D0_DESC 		20
%define KERNEL_STACK_START_POS 	0x27000


%define C_FG_BLACK              0x0
%define C_FG_BLUE               0x1
%define C_FG_GREEN              0x2
%define C_FG_CYAN               0x3
%define C_FG_RED                0x4
%define C_FG_MAGENTA            0x5
%define C_FG_BROWN              0x6
%define C_FG_LIGHT_GREY         0x7
%define C_FG_DARK_GREY          0x8
%define C_FG_LIGHT_BLUE         0x9
%define C_FG_LIGHT_GREEN        0xA
%define C_FG_LIGHT_CYAN         0xB
%define C_FG_LIGHT_RED          0xC
%define C_FG_LIGHT_MAGENTA      0xD
%define C_FG_LIGHT_BROWN        0xE
%define C_FG_WHITE              0xF

%define C_BG_BLACK              0x0
%define C_BG_BLUE               0x1
%define C_BG_GREEN              0x2
%define C_BG_CYAN               0x3
%define C_BG_RED                0x4
%define C_BG_MAGENTA            0x5
%define C_BG_BROWN              0x6
%define C_BG_LIGHT_GREY         0x7


%define DIRECTORIO_PAGINAS_KERNEL_POS	0x27000
%define DIRECTORIO_TABLA1_POS			0x27000
%define DIRECTORIO_TABLA2_POS			0x27004

%define TABLA_PAGINAS_1_KERNEL_POS		0x28000
%define TABLA_PAGINAS_2_KERNEL_POS		0x2A000



%include "imprimir.mac"

global start

;; Screen
extern screen_limpiar
extern screen_colorear
extern screen_imprimir
extern screen_blink_colors
extern screen_modo_estado
extern screen_modo_mapa

;; GDT
extern GDT_DESC

;; IDT
extern IDT_DESC
extern idt_inicializar

;; PIC
extern resetear_pic
extern habilitar_pic

;; mmnu
extern mmu_inicializar_dir_kernel
extern mmu_mapear_pagina

;; Saltear seccion de datos
jmp start

;;
;; Seccion de datos.
;; -------------------------------------------------------------------------- ;;
iniciando_mr_msg db     'Iniciando kernel (Modo Real)...'
iniciando_mr_len equ    $ - iniciando_mr_msg

iniciando_mp_msg db     'Iniciando kernel (Modo Protegido)...'
iniciando_mp_len equ    $ - iniciando_mp_msg



orga2_msg db 'Organizacion del Computador II', 0

;;
;; Seccion de código.
;; -------------------------------------------------------------------------- ;;

;; Punto de entrada del kernel.
BITS 16
start:
    ; Deshabilitar interrupciones
    cli

    ; Imprimir mensaje de bienvenida

	
	; macro
    imprimir_texto_mr iniciando_mr_msg, iniciando_mr_len, 0x07, 0, 0

    ; habilitar A20
    call habilitar_A20
    call checkear_A20

    ; cargar la GDT
    lgdt [GDT_DESC]

    ; setear el bit PE del registro CR0
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; pasar a modo protegido

    jmp GDT_IDX_C0_DESC << 3:pm

 BITS 32
 pm:

    ; acomodar los segmentos
    xor eax, eax
    mov ax, GDT_IDX_D0_DESC << 3
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov gs, ax
    mov fs, ax

    ; setear la pila
    mov esp, KERNEL_STACK_START_POS

    ; pintar pantalla, todos los colores, que bonito!

    call screen_limpiar

    

    ; mensaje de bienvenida

    call screen_blink_colors

    push C_BG_BLUE
    push 12					; toY
    push 70					; toX
    push 0					; fromY
    push 2 					; fromX
    call screen_colorear


    push 1					; keepBGColor
    push 1					; y
    push 3					; x
    push 0					; blink (igual lo ignora por el keepBGColor)
    push 0					; bgcolor (igual lo ignora por el keepBGColor)
    push C_FG_WHITE			; forecolor
    push orga2_msg			; mensaje
    call screen_imprimir


    ; inicializar el manejador de memoria

    call mmu_inicializar_dir_kernel

    

    ; inicializar el directorio de paginas

    mov eax, DIRECTORIO_PAGINAS_KERNEL_POS
    mov cr3, eax

    
    ; inicializar memoria de tareas

    ; habilitar paginacion

    mov eax, cr0
    or eax, 0x80000000 ; bit de paginacion on
    mov cr0, eax

    ; pagina de ejemplo
    ; push 0x200000
    ; push 0x781000
    ; push 0x27000
    ; call mmu_mapear_pagina 
    
    ; xchg bx, bx

    ; inicializar tarea idle

    ; inicializar todas las tsss

    ; inicializar entradas de la gdt de las tsss

    ; inicializar el scheduler

    ; inicializar la tabla IDT

    call idt_inicializar

    ; cargar la IDT
    lidt [IDT_DESC]







    ; Pongo la pantalla en modo estado
    call screen_modo_estado
    
    ; Pongo la pantalla en modo mapa
    ; call screen_modo_mapa
    

    ; divido por cero para probar
    ;mov ax, 56
    ;mov bl, 0
    ;div bl


    

    ; configurar controlador de interrupciones

    call resetear_pic
    call habilitar_pic
    sti

    ; cargar la tarea inicial

    ; saltar a la primer tarea

    ; Ciclar infinitamente (por si algo sale mal...)
    mov eax, 0xFFFF
    mov ebx, 0xFFFF
    mov ecx, 0xFFFF
    mov edx, 0xFFFF
    jmp $
    jmp $

;; -------------------------------------------------------------------------- ;;

%include "a20.asm"
