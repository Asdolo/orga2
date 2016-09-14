; void pixelar_asm (
; 	unsigned char *src,
; 	unsigned char *dst,
; 	int cols,
; 	int filas,
; 	int src_row_size,
; 	int dst_row_size
; );

; Parámetros:
; 	rdi = src
; 	rsi = dst
; 	rdx = cols
; 	rcx = filas
; 	r8 = src_row_size
; 	r9 = dst_row_size




global pixelar_asm
section .rodata
mascaraExtend: db 0x00,0xFF,0x01,0xFF,0x02,0xFF,0x03,0xFF,0x04,0xFF,0x05,0xFF,0x06,0xFF,0x07,0xFF,0x08,0xFF
mascaraOrdenadora: db 0x00, 0x02, 0x04, 0x06,0x00, 0x02, 0x04, 0x06,0x00, 0x02, 0x04, 0x06,0x00, 0x02, 0x04, 0x06
mascaraLOCA: db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; TO DO!!
 section .text

pixelar_asm:
		
mov r10, rdi					; r10 <- src
mov r11, rsi					; r11 <- dst r9 
mov r12,rdx					;r12 <- #columnas
mov r13,rcx					; r13 <- #filas

mov r8,r13
shr r8,2
;R8=FILAS/2

mov r9,r13
shr r9,2
;R9=COLUMNAS/2

.cicloExterno:
cmp r8,0
JE .fin
add r8,1
mov r9,r13
shr r9,2
;R9=COLUMNAS/2
.cicloInterno:
	cmp r9,0
	JE .cicloExterno
	movdqu xmm0, [r10]
	 ; xmm0 = |a[0]3 r[0]3 g[0]3 b[0]3 | a[0]2 r[0]2 g[0]2 b[0]2 | a[0]1 r[0]1 g[0]1 b[0]1 | a [0]0 r[0]0 g[0]0 b[0]0|
	movdqu xmm1, [r10+r12] ;
	 ;xmm1 = |a[1]3 r[1]3 g[1]3 b[1]3 | a[1]2 r[1]2 g[1]2 b[1]2 | a[1]1 r[1]1 g[1]1 b[1]1 | a[1]0 r[1]0 g[1]0 b[1]0|
	pshufb xmm0,[mascaraExtend]
	 ; xmm0=  | 0000 a[0]1 0000 r[0]1| 0000 g[0]1 0 b[0]1 | 0000 a[0]0 0 r[0]0| 0000 g[0]0 0000 b[0]0|
	pshufb xmm1,[mascaraExtend]
	; xmm1=   | 0000 a[1]1 0000 r[1]1| 0000 g[1]1 0 b[0]1 | 0000 a[1]0 0 r[1]0| 0000 g[1]0 0000 b[1]0|
	phaddw xmm0,xmm1 
;xmm0= | (a[0]1+a[1]1)  (r[0]1+r[1]1)|(g[0]1+g[1]1)  (b[0]1+b[1]1)|| (a[0]0+a[1]0)  (r[0]0+r[1]0)|(g[0]0+g[1]0)  (b[0]0+b[1]0)| 
pshufb xmm0 ,[mascaraLOCA]
; xmm0= |(a[0]1+a[1]1)  (a[0]0+a[1]0)|(r[0]1+r[1]1)  (r[0]0+r[1]0)|(g[0]1+g[1]1)  (g[0]0+g[1]0)|(b[0]1+b[1]1)  (b[0]0+b[1]0) |
	

		;div16bits xmm0,4; FIJARSE DE USAR SHIFT

phaddw xmm0,xmm9
;xmm9=basur
;xmm0= |basura basura| basura basura|(a[0]1+a[1]1)+(a[0]0+a[1]0)(r[0]1+r[1]1)+(r[0]0+r[1]0)|(g[0]1+g[1]1)+(g[0]0+g[1]0) (b[0]1+b[1]1)+(b[0]0+b[1]0|

	;xmm0[15..0]=promedioB =0000000 00000001
	;xmm0[31..16]=promedioG
	;xmm0[47..32]=promedioR
    ;xmm0[63..48]=promedioA

	pshufb xmm0,[mascaraOrdenadora] ; |PIXELPROMEDIO|PIXELPROMEDIO|PIXELPROMEDIO|PIXELPROMEDIO|
	movq [r11],xmm0
	movq [r11+r13],xmm0

	add r11,8
	add r10,8
	add r9,1
	jmp .cicloInterno

.fin:
	add rsp, 8

	ret