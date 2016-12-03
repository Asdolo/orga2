; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================
; definicion de rutinas de atencion de interrupciones

%include "imprimir.mac"

BITS 32


;; SCREEN
extern check_soy_bandera
extern check_soy_tarea
extern flamear_bandera
extern screen_print_grupo
extern girar_reloj
;; PIC
extern fin_intr_pic1

;; EXCEPCIONES
extern isr_atender_excepcion

;; Variables

extern eax_error
extern ebx_error;
extern ecx_error;
extern edx_error;
extern esi_error;
extern edi_error;
extern ebp_error;
extern esp_error;
extern eip_error;
extern cr0_error;
extern cr2_error;
extern cr3_error;
extern cr4_error;
extern cs_error;
extern ds_error;
extern es_error;
extern fs_error;
extern gs_error;
extern ss_error;
extern eflags_error;


extern imprimirRegistros

;; INTERRUPCIONES
extern atender_teclado

;; sched
extern sched_proximo_indice
extern desalojarTareaActual
extern isr_atender_excepcion
extern quitarBitBusy

;; syscalls
extern fondear_c
extern canonear_c
extern navegar_c

global _isr32
global _isr33
global _isr80
global _isr102


%define SYS_FONDEAR     0x923
%define SYS_CANONEAR    0x83A
%define SYS_NAVEGAR     0xAEF

%define GDT_IDX_T_INIT_DESC         23
%define GDT_IDX_T_IDLE_DESC         24

%define CODIGO_ERROR_BANDERA_LLAMA_SYSCALL_50     50
%define CODIGO_ERROR_TAREA_LLAMA_SYSCALL_66       66
;;
;; Definición de MACROS
;; -------------------------------------------------------------------------- ;;

%macro ISR 1
global _isr%1

_isr%1:
.loopear:
    mov [eax_error],eax
    mov [ebx_error],ebx
    mov [ecx_error],ecx
    mov [edx_error],edx
    mov [esi_error],esi
    mov [edi_error],edi
    mov [ebp_error],ebp
    mov [esp_error],esp
    mov eax,[esp+8]
    mov [eip_error],eax

    mov eax,cr0
    mov [cr0_error],eax
    mov eax,cr2
    mov [cr2_error],eax
    mov eax,cr3
    mov [cr3_error],eax
    mov eax,cr4
    mov [cr4_error],eax

    mov ax,[esp+8];
    mov [cs_error],ax
    mov ax,ds
    mov [ds_error],ax
    mov ax,es
    mov [es_error],ax
    mov ax,fs
    mov [fs_error],ax
     mov ax,gs
    mov [gs_error],ax
    mov ax,ss
    mov [ss_error],ax
    mov eax,[esp+12]
    mov [eflags_error],eax
    call imprimirRegistros


    call desalojarTareaActual

    push %1 ; le paso como parametro a C el número de excepción
    call isr_atender_excepcion

    ; saltar a la tarea idle
    jmp GDT_IDX_T_IDLE_DESC<<3:1234

    ; To Infinity And Beyond!!
    mov eax, 0xFFF2
    mov ebx, 0xFFF2
    mov ecx, 0xFFF2
    mov edx, 0xFFF2
    jmp $
%endmacro

;;
;; Datos
;; -------------------------------------------------------------------------- ;;
; Scheduler
reloj_numero:           dd 0x00000000
reloj:                  db '|/-\'

offset:
  dd 0x1234 ; basura posta

selector:
 dw 0x00 ; basura, total se va a sobreescribir


%define CANT_CLOCKS 1
clock_granularity:  db CANT_CLOCKS;

;;
;; Rutina de atención de las EXCEPCIONES
;; -------------------------------------------------------------------------- ;;
ISR 0

ISR 2
ISR 3
ISR 4
ISR 5
ISR 6
ISR 7
ISR 8
ISR 9
ISR 10
ISR 11
ISR 12
ISR 13
ISR 14

ISR 16
ISR 17
ISR 18
ISR 19



;;
;; Rutina de atención del RELOJ
;; -------------------------------------------------------------------------- ;;
_isr32:
    pushad

    dec byte [clock_granularity]
    jnz .noJump

    mov byte [clock_granularity], CANT_CLOCKS

    call screen_print_grupo

    str ax
    push ax
    call check_soy_tarea
    pop ax

    call sched_proximo_indice
    cmp ax, 0
  	je .noJump

    str bx
    cmp ax,bx
    je .noJump

  	mov [selector], ax
  	call fin_intr_pic1

    call girar_reloj

  	jmp far [offset]
  	jmp .end


.noJump:
	call fin_intr_pic1
.end:
    popad
    iret

;;
;; Rutina de atención del TECLADO
;; -------------------------------------------------------------------------- ;;
_isr33:
    pushad
    call fin_intr_pic1

    xor eax, eax
    in al, 0x60

    push eax
    call atender_teclado
    pop eax

    popad
    iret

;;
;; Rutinas de atención de las SYSCALLS
;; -------------------------------------------------------------------------- ;;
_isr80:
    pushad

    ; me guardo los parametros de la syscall
    push eax
    push ebx
    push ecx

    str ax
    push ax
    call check_soy_tarea
    cmp al, 1
    pop ax

    ; restauro los parametros de la syscall
    pop ecx
    pop ebx
    pop eax
    je soy_tarea



    ; SOY UNA BANDERA, IMPRIMO ERROR Y SALTO A SALTAR IDLE
    push CODIGO_ERROR_BANDERA_LLAMA_SYSCALL_50 ; le paso como parametro a C el número de excepción
    call isr_atender_excepcion








    jmp fin_isr80


soy_tarea:
    cmp eax, SYS_FONDEAR
    jne ask_canonear
    mov eax, cr3
    push ebx
    push eax

    call fondear_c
    add esp, 8

    jmp fin_isr80

ask_canonear:
    cmp eax, SYS_CANONEAR
    jne ask_navegar

    push ecx
    push ebx


    call canonear_c
    add esp, 8

    jmp fin_isr80

ask_navegar:
    cmp eax, SYS_NAVEGAR
    jne fin_isr80

    push ecx ; nueva pagina 2 fisica
    push ebx ; nueva pagina 1 fisica

    call navegar_c

    add esp, 8

fin_isr80:
    popad

    ; saltar a la tarea idle
    jmp GDT_IDX_T_IDLE_DESC<<3:1234

    iret





















_isr102:

    str ax
    push ax
    call check_soy_bandera
    cmp al, 1
    pop ax
    je do_actualizar_buffer

    ; SOY UNA TAREA, IMPRIMO ERROR Y SALTO A SALTAR IDLE
    push CODIGO_ERROR_TAREA_LLAMA_SYSCALL_66 ; le paso como parametro a C el número de excepción
    call isr_atender_excepcion
    jmp _isr102_saltar_a_idle

do_actualizar_buffer:
    ; call actualizar_buffer si fue llamada por una bandera
    call flamear_bandera
    ; sacamos el bit de busy
    str ax
    push ax
    call quitarBitBusy
    pop ax

_isr102_saltar_a_idle:
    ; harcodeamos la tarea init para que el contexto se guarde ahi y no tener
    ; que restaurar la tss de la bandera
    mov ax, GDT_IDX_T_INIT_DESC<<3
    ltr ax

    ; saltar a la tarea idle
    jmp GDT_IDX_T_IDLE_DESC<<3:1234
    iret
