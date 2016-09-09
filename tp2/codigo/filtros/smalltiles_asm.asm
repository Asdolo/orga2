section .data
DEFAULT REL

section .text
global smalltiles_asm

; void smalltiles_asm    (unsigned char *src, unsigned char *dst, int cols, int filas,
;                     int src_row_size, int dst_row_size);
smalltiles_asm:
;COMPLETAR
	mov r8, rdi					; r8 <- src
	mov r9, rsi					; r9 <- dst

	xor rdx, rdx				; limpio el contador


ciclo:
	pmovupdw xmm0, [r8]
	add r8,8
	pmovupdw xmm1, [r8]
	slr xmm1
	


	loop
	ret
