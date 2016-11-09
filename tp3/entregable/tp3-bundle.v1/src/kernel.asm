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

%define GDT_IDX_T_INIT_DESC         23
%define GDT_IDX_T_IDLE_DESC         24



%include "imprimir.mac"

global start

;; Screen
extern screen_limpiar
extern screen_colorear
extern screen_imprimir
extern screen_blink_colors
extern screen_modo_estado
extern screen_modo_mapa
extern actualizar_pantalla

;; GDT
extern GDT_DESC
extern gdt_init_tss

;; IDT
extern IDT_DESC
extern idt_inicializar

;; PIC
extern resetear_pic
extern habilitar_pic

;; mmnu
extern mmu_inicializar_dir_kernel
extern mmu_mapear_pagina
extern mnu_inicializar_memoria_tareas
extern mmu_inicializar_dir_tarea

;; tss
extern tss_inicializar

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
    ; saltamos al segmento de nivel 0
    jmp GDT_IDX_C0_DESC << 3:pm

 BITS 32
 pm:

    ; acomodar los segmentos
    xor eax, eax
    mov ax, GDT_IDX_D0_DESC << 3

    ; el cs no se debe cargar porque si esta corriendo una tarea y si una tarea quiere cambiar de segmento (a uno mas privilegiado), el procesador no puede dejarlo hacer eso
    ; la unica forma de cambiar el cs es haciendo un jmp far 
    ; jmp nuevoCS:offset

    mov ds, ax
    mov ss, ax
    mov es, ax
    mov gs, ax
    mov fs, ax

    ; setear la pila
    mov esp, KERNEL_STACK_START_POS

    ; limpiamos la pantalla
    call screen_limpiar

    
    ; inicializar el manejador de memoria
    call mmu_inicializar_dir_kernel
    ; xchg bx, bx

    ; inicializar el directorio de paginas
    mov eax, DIRECTORIO_PAGINAS_KERNEL_POS
    mov cr3, eax

    ; xchg bx, bx
    ; inicializar memoria de tareas
    call mnu_inicializar_memoria_tareas

    ; habilitar paginacion

    mov eax, cr0
    or eax, 0x80000000 ; bit de paginacion on
    mov cr0, eax

   

    ; inicializar tarea idle

    ; inicializar todas las tsss
    call tss_inicializar

    ; inicializar entradas de la gdt de las tsss
    call gdt_init_tss

    ; inicializar el scheduler

    ; inicializar la tabla IDT

    call idt_inicializar

    ; cargar la IDT
    lidt [IDT_DESC]







    ; Pongo algo en el buffer de estado
    call screen_modo_estado
    
    ; Pongo algo en el buffer de mapa
    call screen_modo_mapa

    ; Como la variable global modo_pantalla (screen.h) arranca en 0, arranca en modo estado
    call actualizar_pantalla
    

    ; divido por cero para probar
    ;mov ax, 56
    ;mov bl, 0
    ;div bl


    

    ; configurar controlador de interrupciones

    call resetear_pic
    call habilitar_pic
    sti

    ; cargar la tarea inicial
    ; xchg bx, bx
    mov ax, GDT_IDX_T_INIT_DESC<<3
    ltr ax

    ; saltar a la primer tarea
    jmp GDT_IDX_T_IDLE_DESC<<3:0246 ; preguntar si el RPL es 0

    ; Ciclar infinitamente (por si algo sale mal...)
    mov eax, 0xFFFF
    mov ebx, 0xFFFF
    mov ecx, 0xFFFF
    mov edx, 0xFFFF
    jmp $
    jmp $

;; -------------------------------------------------------------------------- ;;

%include "a20.asm"


; (general protection fault y se corta la ejecución de la instrucción)
; 1º: chequea el nivel de privilegios
; 2º: chequeo de offset valido (entre 0 y limit de la gdt). tanto para código (cs) o dato (ds)
; 3º: chequeo de tipo de segmento (no se puede hacer un jump far a un segmento de datos) (existen segmentos de datos, que todos permiten lectura. De los segmentos de código, se puede setear que permita la lectura)

; todo esto lo hace el procesador en paralelo, no en serie

; luego el procesador convierte la dirección lógica en dirección lineal, y se le siguen haciendo chequeos
; (si paginación está activada en cr0)
; 1º va al directorio
; 2º busca la entrada de esa dirección
; 3º se fija si está presente
; 4º si fija si los privilegios de la página son accesibles


; acceso a un segmento:
; se puede especificar el segmento a acceder de forma explicita
; ej: jmp 0x8:0
; y accedo al segmento 1 (porque el índice es 1)

; se puede acceder además de forma implícita a un segmento
; ej: mov eax, [ebx]
; porque está implícito que quiero acceder al segmento ds actual

; ej: push eax
; porque está implícito que quiero acceder al segmento ss actual

; ej: jump pepe
; porque está implícito que quiero acceder al segmento cs actual. en este caso sólo se chequea que no nos pasemos del límite del segmento, porque los privilegios ya están bien si llegué hasta acá, y el tipo de segmento también









; como se hacen los chequeos:

; chequeo de offset valido:

; se fija si offset + tamaño del elemento > limite efectivo --> #General Protection

; -----------------------------------------

; chequeo de tipo: 

; caso lectura: 
; si el segmento que queremos acceder es de código se fija si es de ejecución+lectura. Si no es de ejecución+lectura --> #General Protection.
; si queremos acceder a un segmento de dato, no hay que hacer nada: todos los segmentos de datos se pueden leer.

; caso escritura:
; si el segmento que queremos acceder es de código --> #General Protection.
; si queremos acceder a un segmento de dato, se fija si es de escritura. Si no es de escritura --> #General Protection.

; caso ejecución:
; si el segmento que queremos acceder no es de código --> es de dato --> #General Protection.

; -----------------------------------------

; chequeo de privilegios:

; caso dato:

; calcula el EPL = max_numerico(CPL, RPL). El CPL está en el CS (últimos dos bits). El RPL está en el DS (últimos dos bits). 

; Compara el EPL calculado con el DPL del segmento al que queremos acceder. El DPL está seteado en el descriptor de segmento en la gdt.
; Si EPL > DPL --> #General Protection.

; caso código:
; sólo se puede acceder a un segmento de código del mismo nivel del actual
; Si CPL != DPL --> Me fijo si el segmento es conforming. Si es conforming y CPL >= DPL --> OK. Sino --> #General Protection.















