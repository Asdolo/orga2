section .data
DEFAULT REL
 
 
 extern printf
section .text
global smalltiles_asm
 
 
section .rodata
mascaraOrdenadora : db 0x00,0x01,0x02,0x03,0x08,0x09,0x0A,0x0B,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
printValor: DB '%d',10,0

; void smalltiles_asm    (unsigned char *src, unsigned char *dst, int cols, int filas,
;                     int src_row_size, int dst_row_size);
; Parámetros:
;   rdi = src
;   rsi = dst
;   rdx = cols
;   rcx = filas
;   r8 = dst_row_size
;   r9 = dst_row_size
 
 
smalltiles_asm:
  push rbp ;A
  mov rbp,rsp
  push r10;D
  push r11;A
  push r12;D
  push r13;A
  push r14;D
  push r15;A

  mov r15,4;
  mov rax,rdx ; 
  mul r15; rax=ancho*4
  shr rax,1; rax=(ancho*4)/2

  
  mov r13,rax; r13=(ancho*4)/2
  mov r14,rcx; r14=alto



;R10 VA A SER EL PUNTERO A ABAJO A LA DERECHA
  mov r10,r13	;r10= (ancho*4)/2
  add r10,rsi   ;r10= abajo a la derecha


;R11 VA A SER EL PUNTERO ARRIBA A LA IZQUIERDA
  mov rax,r13 ; rax=((ancho*4)/2)
  mul r14; rax=((ancho*4)/2)*alto
  mov r11,rax; r11= ((ancho*4)/2)*alto
  add r11,rsi ; r11=arriba a la izquierda
  
;R12 VA A SER EL PUNTERO ARRIBA A LA DERECHA
  mov r12,r11; r12=arriba a la izquierda
  add r12,r13; r12= arriba a la derecha
  

  xor rcx, rcx                ; limpio el contador
  mov rcx,r13				  ;contador=(ancho*4)/2
  shr rcx,3					  ;contador=ancho/4
  
  
  movups xmm8,[mascaraOrdenadora] ;XMM8 ES LA MASCARA
  mov r15,r13 ;r15=(ancho*4)/2
  mov rax,2
  mul r15   ;r15=ancho*4
  mov r15,rax
 
  
.ciclo:
   movups xmm0, [rdi] ;xmm0= |--|p2|--|p0|
   pshufb xmm0,xmm8  ;xmm0= |--|--|p2|p0|
   movups [rsi],xmm0 ;PONGO DESTINO PUNTERO ABAJO IZQUIERDA
   movups [r10],xmm0 ;PONGO DESTINO PUNTERO ABAJO DERECHA
   movups [r11],xmm0 ;PONGO DESTINO PUNTERO ARRIBA IZQUIERDA
   movups [r12],xmm0 ;PONGO DESTINO PUNTERO ARRIBA DERECHA
   add rdi,16        ;LE SUMO 16 BYTES PORQUE ME QUIERO MOVER 4 BYTES
   add rsi,8		  ;LE SUMO 8 BYTES PORQUE SOLO ESCRIBI 2 BYTES
   add r10,8		  ;LE SUMO 8 BYTES PORQUE SOLO ESCRIBI 2 BYTES
   add r11,8		  ;LE SUMO 8 BYTES PORQUE SOLO ESCRIBI 2 BYTES
   add r12,8		  ;LE SUMO 8 BYTES PORQUE SOLO ESCRIBI 2 BYTES
    
   loop .ciclo		  ;ITERO HASTA QUE EL PUNTERO RDI LLEGUE AL ULTIMO PIXEL DE LA FILA
 
   mov rcx,r13		  ;CONTADOR=(ancho*4)/2
   shr rcx,3		  ;CONTADOR=ancho/4
   add rdi,r15		  ;RDI=RDI+ANCHO*4 LE SUMO ESTO PARA QUE SALTE UNA FILA
   add rsi,r13		  ;RSI=RSI+(ancho*4)/2 LE SUMO ESTO PARA QUE SALTE MEDIA FILA
   add r10,r13		  ;R10=R10+(ancho*4)/2 LE SUMO ESTO PARA QUE SALTE MEDIA FILA
   add r11,r13		  ;R11=R11+(ancho*4)/2 LE SUMO ESTO PARA QUE SALTE MEDIA FILA
   add r12,r13		  ;R12=R12+(ancho*4)/2 LE SUMO ESTO PARA QUE SALTE MEDIA FILA
 	
   sub r14,2		  ;LE RESTO AL CONTADOR DE FILAS 2 PORQUE VOY HACIENDO UNA FILA SI UNA NO..
   cmp r14,0		  ;SI ES 0 EL CONTADOR TERMINE
   jne .ciclo		  ;SALTO AL CICLO DE NUEVO

 	pop r15;D
    pop r14;A
    pop r13;D
    pop r12;A
    pop r11;D
    pop r10;A
    pop rbp;D
    ret;A


