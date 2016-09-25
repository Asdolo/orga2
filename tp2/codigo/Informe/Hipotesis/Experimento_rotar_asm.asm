section .data
DEFAULT REL



section .rodata
mascara: db 0x01, 0x02, 0x00, 0x03, 0x05, 0x06, 0x04, 0x07, 0x09, 0x0A, 0x08, 0x0B, 0x0D, 0x0E, 0x0C, 0x0F

section .text
global rotar_asm
rotar_asm:
;void rotar_asm    (unsigned char *src, unsigned char *dst, int cols, int filas,int src_row_size,int dst_row_size);

push rbp		; A
mov rbp, rsp
push rbx		; D
push r12		; A
push r13		; D
sub rsp, 8		; A

mov r10, rdi					; r10 <- src
mov r11, rsi					; r11 <- dst r9 
mov r12,rdx					;r12 <- #columnas
mov r13,rcx					; r13 <- #filas


xor rcx, rcx			; limpio rcx
mov eax, r13d
shr eax, 2
mul r12d	

mov ecx, eax 			; ecx = cantidad de pixels (filas * cols)
movdqu xmm8, [mascara]

shr ecx,4
.ciclo:
	
	movdqu xmm0, [r10]	; xmm0 = |a3 r3 g3 b3|a2 r2 g2 b2|a1 r1 g1 b1|a0 r0 g0 b0|
	pshufb	xmm0, xmm8	; xmm0 = |a3 g3 b3 r3|a2 g2 b2 r2|a1 g1 b1 r1|a0 g0 b0 r0|
	movdqu [r11], xmm0

	movdqu xmm0, [r10+16]	; xmm0 = |a3 r3 g3 b3|a2 r2 g2 b2|a1 r1 g1 b1|a0 r0 g0 b0|
	pshufb	xmm0, xmm8	; xmm0 = |a3 g3 b3 r3|a2 g2 b2 r2|a1 g1 b1 r1|a0 g0 b0 r0|
	movdqu [r11+16], xmm0


	movdqu xmm0, [r10+32]	; xmm0 = |a3 r3 g3 b3|a2 r2 g2 b2|a1 r1 g1 b1|a0 r0 g0 b0|
	pshufb	xmm0, xmm8	; xmm0 = |a3 g3 b3 r3|a2 g2 b2 r2|a1 g1 b1 r1|a0 g0 b0 r0|
	movdqu [r11+32], xmm0

	movdqu xmm0, [r10+48]	; xmm0 = |a3 r3 g3 b3|a2 r2 g2 b2|a1 r1 g1 b1|a0 r0 g0 b0|
	pshufb	xmm0, xmm8	; xmm0 = |a3 g3 b3 r3|a2 g2 b2 r2|a1 g1 b1 r1|a0 g0 b0 r0|
	movdqu [r11+48], xmm0



	movdqu xmm0, [r10+64]	; xmm0 = |a3 r3 g3 b3|a2 r2 g2 b2|a1 r1 g1 b1|a0 r0 g0 b0|
	pshufb	xmm0, xmm8	; xmm0 = |a3 g3 b3 r3|a2 g2 b2 r2|a1 g1 b1 r1|a0 g0 b0 r0|
	movdqu [r11+64], xmm0

	movdqu xmm0, [r10+80]	; xmm0 = |a3 r3 g3 b3|a2 r2 g2 b2|a1 r1 g1 b1|a0 r0 g0 b0|
	pshufb	xmm0, xmm8	; xmm0 = |a3 g3 b3 r3|a2 g2 b2 r2|a1 g1 b1 r1|a0 g0 b0 r0|
	movdqu [r11+80], xmm0


	movdqu xmm0, [r10+96]	; xmm0 = |a3 r3 g3 b3|a2 r2 g2 b2|a1 r1 g1 b1|a0 r0 g0 b0|
	pshufb	xmm0, xmm8	; xmm0 = |a3 g3 b3 r3|a2 g2 b2 r2|a1 g1 b1 r1|a0 g0 b0 r0|
	movdqu [r11+96], xmm0

	movdqu xmm0, [r10+112]	; xmm0 = |a3 r3 g3 b3|a2 r2 g2 b2|a1 r1 g1 b1|a0 r0 g0 b0|
	pshufb	xmm0, xmm8	; xmm0 = |a3 g3 b3 r3|a2 g2 b2 r2|a1 g1 b1 r1|a0 g0 b0 r0|
	movdqu [r11+112], xmm0



	movdqu xmm0, [r10+128]	; xmm0 = |a3 r3 g3 b3|a2 r2 g2 b2|a1 r1 g1 b1|a0 r0 g0 b0|
	pshufb	xmm0, xmm8	; xmm0 = |a3 g3 b3 r3|a2 g2 b2 r2|a1 g1 b1 r1|a0 g0 b0 r0|
	movdqu [r11+128], xmm0

	movdqu xmm0, [r10+144]	; xmm0 = |a3 r3 g3 b3|a2 r2 g2 b2|a1 r1 g1 b1|a0 r0 g0 b0|
	pshufb	xmm0, xmm8	; xmm0 = |a3 g3 b3 r3|a2 g2 b2 r2|a1 g1 b1 r1|a0 g0 b0 r0|
	movdqu [r11+144], xmm0


	movdqu xmm0, [r10+160]	; xmm0 = |a3 r3 g3 b3|a2 r2 g2 b2|a1 r1 g1 b1|a0 r0 g0 b0|
	pshufb	xmm0, xmm8	; xmm0 = |a3 g3 b3 r3|a2 g2 b2 r2|a1 g1 b1 r1|a0 g0 b0 r0|
	movdqu [r11+160], xmm0

	movdqu xmm0, [r10+176]	; xmm0 = |a3 r3 g3 b3|a2 r2 g2 b2|a1 r1 g1 b1|a0 r0 g0 b0|
	pshufb	xmm0, xmm8	; xmm0 = |a3 g3 b3 r3|a2 g2 b2 r2|a1 g1 b1 r1|a0 g0 b0 r0|
	movdqu [r11+176], xmm0



	movdqu xmm0, [r10+192]	; xmm0 = |a3 r3 g3 b3|a2 r2 g2 b2|a1 r1 g1 b1|a0 r0 g0 b0|
	pshufb	xmm0, xmm8	; xmm0 = |a3 g3 b3 r3|a2 g2 b2 r2|a1 g1 b1 r1|a0 g0 b0 r0|
	movdqu [r11+192], xmm0

	movdqu xmm0, [r10+208]	; xmm0 = |a3 r3 g3 b3|a2 r2 g2 b2|a1 r1 g1 b1|a0 r0 g0 b0|
	pshufb	xmm0, xmm8	; xmm0 = |a3 g3 b3 r3|a2 g2 b2 r2|a1 g1 b1 r1|a0 g0 b0 r0|
	movdqu [r11+208], xmm0


	movdqu xmm0, [r10+224]	; xmm0 = |a3 r3 g3 b3|a2 r2 g2 b2|a1 r1 g1 b1|a0 r0 g0 b0|
	pshufb	xmm0, xmm8	; xmm0 = |a3 g3 b3 r3|a2 g2 b2 r2|a1 g1 b1 r1|a0 g0 b0 r0|
	movdqu [r11+224], xmm0

	movdqu xmm0, [r10+240]	; xmm0 = |a3 r3 g3 b3|a2 r2 g2 b2|a1 r1 g1 b1|a0 r0 g0 b0|
	pshufb	xmm0, xmm8	; xmm0 = |a3 g3 b3 r3|a2 g2 b2 r2|a1 g1 b1 r1|a0 g0 b0 r0|
	movdqu [r11+240], xmm0



	add r10, 256
	add r11, 256

	sub ecx,1
	jnz .ciclo

add rsp,8 ;d
pop r13 ;a
pop r12	;d
pop rbx	;a
pop rbp	;d
		
ret	;a