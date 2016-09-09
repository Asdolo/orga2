section .data
DEFAULT REL

section .text
global smalltiles_asm

; void smalltiles_asm    (unsigned char *src, unsigned char *dst, int cols, int filas,
;                     int src_row_size, int dst_row_size);
smalltiles_asm:
;COMPLETAR
	mov r8, rdi					; r8 <- src
	mov r9, rsi					; r9 <- dst r9 abajo la izquierda
	;r10=r9+(cols/2)
	;r10 abajo a la derecha
	;r11=r9+(filas/2)
	;r11 arriba a la izquierda
	;r12=r9++(cols/2)+(filas/2)
	;r12 arriba derecha
	xor rdx, rdx				; limpio el contador

while(j<altura)
for(i=0;j<ancho;j++){
	if(j+1==ancho){
	j=0;
	altura++;
	}
}



	mov xmm8,[masc1] ;XMM8 ES LA MASCARA
ciclo:
	pmovupdw xmm0, [r8] 
	;xmm0= |--|p2|--|p0|

	;xmm1= |--|p10|--|p8|
	movupdw xmm1, [r8+??]

	add r8,16*ancho/2

	mov xmm2,xmm0
	;xmm2= |--|p2|--|p0|

	pshufd xmm2,xmm0,00001000b
	;xmm2= |--|--|p2|p0|

	pshufd xmm3,xmm1,b
	;xmm3= |p10|p8|--|--|

	and xmm2,FFFFFFFFH,FFFFFFFFH,00000000h,00000000h
	;xmm2=|0|0|p2|p0
	and xmm3,00000000h,00000000h,FFFFFFFFH,FFFFFFFFH
	;xmm3=|p10|p8|0|0
	padddw xmm3,xmm2
	;xmm3=|p10|p8|p2|p0


	;xmm2=|P10|p8|p2|p0|
	;mov [r9],xmm2 ... Escribimos en destino
	;add r9,16 Incrementamos el destino

	loop
	ret
