section .data
DEFAULT REL

section .text
global smalltiles_asm


section .rodata
mascaraOrdenadora :  db 0x00, 0x01, 0x02, 0x03, 0x08, 0x09, 0x0A, 0x0B, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
mascaraOrdenadora2 : db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x01, 0x02, 0x03, 0x08, 0x09, 0x0A, 0x0B




; void smalltiles_asm    (unsigned char *src, unsigned char *dst, int cols, int filas,
;                     int src_row_size, int dst_row_size);
; Parámetros:
;   rdi = src
;   rsi = dst
;   edx = cols
;   ecx = filas
;   r8d = dst_row_size
;   r9d = dst_row_size


smalltiles_asm:
  push rbp   ; A
  mov rbp, rsp
  push rbx   ; D
  push r12   ; A
  push r13   ; D
  push r14   ; A
  push r15   ; D
  sub rsp, 8 ; A

  ; rbx va a ser una constante = ancho*4
  ; r15 va a ser una constante = (ancho*4)/2

  xor r15, r15                            ; r15 = 0
  mov r15d, edx                           ; r15d = ancho
  shl r15, 2                              ; r15 = ancho*4

  mov rbx, r15                            ; rbx = ancho*4
  shr r15, 1                              ; r15 = (ancho*4)/2

  ; r10 va a ser un iterador = alto
  xor r10, r10                            ; r10 = 0
  mov r10d, ecx                           ; r10 = alto

  ; rsi es el puntero a abajo a la izquierda

  ; r12 va a ser el puntero a abajo a la derecha
  mov r12, r15	                          ; r12 = (ancho*4)/2
  add r12, rsi                            ; r12 = puntero hacia abajo a la derecha

  ; r13 va a ser el puntero a arriba la izquierda
  mov rax, r15                            ; rax = (ancho*4)/2
  mul r10                                 ; rax = ((ancho*4)/2) * alto
  mov r13, rax                            ; r13 = ((ancho*4)/2) * alto
  add r13, rsi                            ; r13 = puntero hacia arriba a la izquierda

  ; r14 va a ser el puntero a arriba a la derecha
  mov r14, r13                            ; r14 = puntero hacia arriba a la izquierda
  add r14, r15                            ; r14 = puntero hacia arriba a la izquierda + (ancho*4)/2 = puntero hacia arriba a la derecha

  ; xmm8 va a ser la máscara ordenadora
  movups xmm8, [mascaraOrdenadora]        ; xmm8 = | F | F | F | F | F | F | F | F | B | A | 9 | 8 | 3 | 2 | 1 | 0 |

  ; xmm9 va a ser una máscara auxiliar
  movups xmm9, [mascaraOrdenadora2]       ; xmm9 = | B | A | 9 | 8 | 3 | 2 | 1 | 0 | F | F | F | F | F | F | F | F |

  ; rcx va a ser el contador del ciclo
  xor rcx, rcx                            ; limpio el contador
  mov rcx, r15				                    ; rcx = (ancho*4)/2
  shr rcx, 3				                      ; rcx = ancho/4
  sub rcx, 1                              ; DEJO EL ULTIMO PA'L FINAL

.ciclo:
   movups xmm0, [rdi]                     ; xmm0 = | -- | p2 | -- | p0 |

   pshufb xmm0, xmm8                      ; xmm0 = | 00 | 00 | p2 | p0 |
   movups [rsi], xmm0                     ; PONGO DESTINO PUNTERO ABAJO IZQUIERDA
   movups [r12], xmm0                     ; PONGO DESTINO PUNTERO ABAJO DERECHA
   movups [r13], xmm0                     ; PONGO DESTINO PUNTERO ARRIBA IZQUIERDA
   movups [r14], xmm0                     ; PONGO DESTINO PUNTERO ARRIBA DERECHA
   add rdi, 16                            ; LE SUMO 16 BYTES PORQUE ME QUIERO MOVER 4 PIXEL
   add rsi, 8		                          ; LE SUMO 8 BYTES PORQUE SOLO ESCRIBI 2 PIXEL
   add r12, 8		                          ; LE SUMO 8 BYTES PORQUE SOLO ESCRIBI 2 PIXEL
   add r13, 8		                          ; LE SUMO 8 BYTES PORQUE SOLO ESCRIBI 2 PIXEL
   add r14, 8		                          ; LE SUMO 8 BYTES PORQUE SOLO ESCRIBI 2 PIXEL

   loop .ciclo		                        ; ITERO HASTA QUE EL PUNTERO RDI LLEGUE AL ULTIMO PIXEL DE LA FILA - 1

   ; lo hago manual
   sub rsi, 8
   sub r12, 8
   sub r13, 8
   sub r14, 8
                                          ; xmm0 = | 00 | 00 | p2 | p0 |
   movups xmm1, xmm0                      ; xmm1 = | 00 | 00 | p2 | p0 |
   movups xmm0, [rdi]                     ; xmm0 = | -- | p6 | -- | p4 |
   pshufb xmm0, xmm9                      ; xmm0 = | p6 | p4 | 00 | 00 |

   paddb xmm0, xmm1                       ; xmm0 = | p6 | p4 | p2 | p0 |
   movups [rsi], xmm0                     ; PONGO DESTINO PUNTERO ABAJO IZQUIERDA
   movups [r12], xmm0                     ; PONGO DESTINO PUNTERO ABAJO DERECHA
   movups [r13], xmm0                     ; PONGO DESTINO PUNTERO ARRIBA IZQUIERDA
   movups [r14], xmm0                     ; PONGO DESTINO PUNTERO ARRIBA DERECHA

   add rdi, 16                            ; LE SUMO 16 BYTES PARA QUE APUNTE AL FINAL
   add rsi, 16	                          ; LE SUMO 16 BYTES PARA QUE APUNTE AL FINAL
   add r12, 16	                          ; LE SUMO 16 BYTES PARA QUE APUNTE AL FINAL
   add r13, 16	                          ; LE SUMO 16 BYTES PARA QUE APUNTE AL FINAL
   add r14, 16	                          ; LE SUMO 16 BYTES PARA QUE APUNTE AL FINAL

   ; reseteo el contador
   mov rcx, r15                           ; rcx = (ancho*4)/2
   shr rcx, 3                             ; rcx = ancho/4
   sub rcx, 1                              ; DEJO EL ULTIMO PA'L FINAL

   add rdi, rbx                           ; rdi = rdi + ancho*4       LE SUMO ESTO PARA QUE SALTE UNA FILA
   add rsi, r15                           ; rsi = rsi + (ancho*4)/2   LE SUMO ESTO PARA QUE SALTE MEDIA FILA
   add r12, r15                           ; r12 = r12 + (ancho*4)/2   LE SUMO ESTO PARA QUE SALTE MEDIA FILA
   add r13, r15                           ; r13 = r13 + (ancho*4)/2   LE SUMO ESTO PARA QUE SALTE MEDIA FILA
   add r14, r15                           ; r14 = r14 + (ancho*4)/2   LE SUMO ESTO PARA QUE SALTE MEDIA FILA

   sub r10, 2		                          ; LE RESTO AL CONTADOR DE FILAS 2 PORQUE VOY HACIENDO UNA FILA SI UNA NO..
   cmp r10, 0		                          ; SI ES 0 EL CONTADOR TERMINE
   jne .ciclo		                          ; SALTO AL CICLO DE NUEVO

fin:
   add rsp, 8 ; D
   pop r15    ; A
   pop r14    ; D
   pop r13    ; A
   pop r12    ; D
   pop rbx    ; A
   pop rbp    ; D
   ret        ; A
