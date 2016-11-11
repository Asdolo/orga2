; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================
; definicion de rutinas de atencion de interrupciones

%include "imprimir.mac"

BITS 32


;; SCREEN
extern screen_proximo_reloj

;; PIC
extern fin_intr_pic1

;; EXCEPCIONES
extern isr_atender_excepcion


;; INTERRUPCIONES
extern atender_teclado

;; sched
extern sched_proximo_indice

;; syscalls
extern fondear_c
extern canonear_c
extern navegar_c

global _isr32
global _isr33
global _isr80
global _isr102
global proximo_reloj


%define SYS_FONDEAR     0x923
%define SYS_CANONEAR    0x83A
%define SYS_NAVEGAR     0xAEF

%define GDT_IDX_T_IDLE_DESC         24

;;
;; Definición de MACROS
;; -------------------------------------------------------------------------- ;;

%macro ISR 1
global _isr%1

_isr%1:
.loopear:

    push %1 ; le paso como parametro a C el número de excepción
    call isr_atender_excepcion

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
    ;call fin_intr_pic1
    ;call screen_proximo_reloj

    call sched_proximo_indice

    cmp ax,0
	je .noJump
	mov [selector], ax
	call fin_intr_pic1
                        ; xchg bx, bx
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
    mov eax, 0x42
    pushad

    popad
    iret


;; Funciones Auxiliares
;; -------------------------------------------------------------------------- ;;
proximo_reloj:
    pushad


    ; inc DWORD [reloj_numero]
    ; mov ebx, [reloj_numero]
    ; cmp ebx, 0x4
    ; jl .ok
    ;     mov DWORD [reloj_numero], 0x0
    ;     mov ebx, 0
    ; .ok:
    ;     add ebx, reloj
    ;     imprimir_texto_mp ebx, 1, 0x0f, 24, 79

    popad
    ret
