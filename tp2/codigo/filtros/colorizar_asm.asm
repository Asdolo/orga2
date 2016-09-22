; void colorizar_asm (
; 	unsigned char *src,
; 	unsigned char *dst,
; 	int cols,
; 	int filas,
; 	int src_row_size,
; 	int dst_row_size,
;   float alpha
; );

; Parámetros:
; 	rdi = src
; 	rsi = dst
; 	edx = cols
; 	ecx = filas
; 	r8 = src_row_size
; 	r9 = dst_row_size
;   xmm0 = alpha


global colorizar_asm

section .rodata
    uno:   dd 1.0, 1.0, 1.0, 1.0
    
section .text




colorizar_asm:


	; r10 va a ser una constante = ancho*4
    ; r11 va a ser una constante = ancho/4
    ; r8 va a ser una constante = (ancho*4)*3
    xor r9, r9                      ; r9 = 0
    mov r9d, ecx                    ; r9 = alto

    xor r10, r10   		            ; r10 =  0
    mov r10d, edx  		            ; r10 = ancho
    shl r10, 2     		            ; r10 = ancho*4
    
    xor r8, r8
    mov rax, r10					; rax = ancho*4
    mul 3							; rax = (ancho*4)*3
    mov r8, rax						; r8 = (ancho*4)*3
    
    xor r11, r11                 	; r10 =  0
    mov r11d, edx                	; r10 = ancho
    shr r11, 2						; r10 = ancho/4
    

	; movemos rsi a la fila de arriba
	add rsi, r10


	; r9 va a ser un iterador = alto
    xor r9, r9                              ; r9 = 0
    mov r9d, ecx                            ; r9 = alto

    ; seteo el contador
    mov rcx, r11                            ; rbx = ancho/4
    
    ; xmm0 =  |           |           |           |   alpha   |
    pshufd xmm0, 0000000000b
    ; xmm0 =  |   alpha   |   alpha   |   alpha   |   alpha   |
		
	movups xmm10, [uno]
	; xmm10 = |    1.0    |    1.0    |    1.0    |    1.0    |
	
	addps xmm10, xmm0	
	; xmm10 = | 1 + alpha | 1 + alpha | 1 + alpha | 1 + alpha |
	
	movups xmm11, [uno]
	; xmm11 = |    1.0    |    1.0    |    1.0    |    1.0    |
	
	subps xmm11, xmm0	
    ; xmm11 = | 1 - alpha | 1 - alpha | 1 - alpha | 1 - alpha |
	
 .ciclo:

 	movdqu xmm0, [rdi]
 	; xmm0 = | A[0][3] | R[0][3] | G[0][3] | B[0][3] | A[0][2] | R[0][2] | G[0][2] | B[0][2] | A[0][1] | R[0][1] | G[0][1] | B[0][1] | A[0][0] | R[0][0] | G[0][0] | B[0][0] |
    ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0
	
	movdqu xmm1, [rdi + r10]
	; xmm1 = | A[1][3] | R[1][3] | G[1][3] | B[1][3] | A[1][2] | R[1][2] | G[1][2] | B[1][2] | A[1][1] | R[1][1] | G[1][1] | B[1][1] | A[1][0] | R[1][0] | G[1][0] | B[1][0] |
    ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0
    
	movdqu xmm2, [rdi + 2*r10]
	; xmm2 = | A[2][3] | R[2][3] | G[2][3] | B[2][3] | A[2][2] | R[2][2] | G[2][2] | B[2][2] | A[2][1] | R[2][1] | G[2][1] | B[2][1] | A[2][0] | R[2][0] | G[2][0] | B[2][0] |
    ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0
    
    pmaxub xmm1,xmm2
	; xmm1 = | max(pix[1][3], pix[2][3]) | max(pix[1][2], pix[2][2]) | max(pix[1][1], pix[2][1]) | max(pix[1][0], pix[2][0]) |
	
	
	; backupeo las 3 filas porque necesito los pixels del medio
	movdqu xmm3, xmm0
	; xmm3 = | A[0][3] | R[0][3] | G[0][3] | B[0][3] | A[0][2] | R[0][2] | G[0][2] | B[0][2] | A[0][1] | R[0][1] | G[0][1] | B[0][1] | A[0][0] | R[0][0] | G[0][0] | B[0][0] |
    ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0
	
	movdqu xmm4, xmm1
	; xmm4 = | A[1][3] | R[1][3] | G[1][3] | B[1][3] | A[1][2] | R[1][2] | G[1][2] | B[1][2] | A[1][1] | R[1][1] | G[1][1] | B[1][1] | A[1][0] | R[1][0] | G[1][0] | B[1][0] |
    ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0
    
	movdqu xmm5, xmm2
	; xmm5 = | A[2][3] | R[2][3] | G[2][3] | B[2][3] | A[2][2] | R[2][2] | G[2][2] | B[2][2] | A[2][1] | R[2][1] | G[2][1] | B[2][1] | A[2][0] | R[2][0] | G[2][0] | B[2][0] |
    ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0
    
	
	; calculo maximos por columnas
	pmaxub xmm0,xmm1
	; xmm0 = | max(pix[0][3], pix[1][3], pix[2][3]) | max(pix[0][2], pix[1][2], pix[2][2]) | max(pix[0][1], pix[1][1], pix[2][1]) | max(pix[0][0], pix[1][0], pix[2][0]) |
	; xmm0 = | max(col3]) | max(col2) | max(col1) | max(col0) |
 	
 	movdqu xmm1, xmm0
 	; xmm1 = | max(col3) | max(col2) | max(col1) | max(col0) |
 	
	pshufb xmm0, [maxCol0y2_maxCol1y3]
	; xmm0 = |     0     |     0     | max(col3) | max(col2)  |

	pmaxub xmm0, xmm1
	; xmm0 = |   fruta   |   fruta   | max(col1, col3) | max(col0, col2) |
	
	
	; ahora acomodo mis backups xmm3 y xmm5 para calcular los maximos con los pixeles del medio
	; quiero maximo entre: max(col0, col2), xmm3[1] y xmm5[1] (donde xmmn[k] es el k-ésimo pixel del registro xmmn)
	; y ademas quiero maximo entre: max(col1, col3), xmm3[2] y xmm5[2] (donde xmmn[k] es el k-ésimo pixel del registro xmmn)
	; entiéndase que anoto pixels, pero los máximos son realmente a nivel byte/componente
	
	; tengo:
	; xmm0 = |   fruta   |   fruta   | max(col1, col3) | max(col0, col2) |
	; xmm3 = |  xmm3[3]  |  xmm3[2]  |     xmm3[1]     |     xmm3[0]     |
	; xmm5 = |  xmm5[3]  |  xmm5[2]  |     xmm5[1]     |     xmm5[0]     |
	
	; entonces, acomodo mis backups para usar pmaxub nuevamente:
	
	movdqu xmm6, xmm3
	; xmm6 = |  xmm3[3]  |  xmm3[2]  |     xmm3[1]     |     xmm3[0]     |
	
	pshufb xmm6, [maxPixelsMedio]
	; xmm6 = |     0     |     0     |     xmm3[2]     |     xmm3[1]     |
	
	pmaxub xmm0, xmm6
	; xmm0 = |   fruta   |   fruta   | max(col1, col3, xmm3[2]) | max(col0, col2, xmm3[1]) |
	
	movdqu xmm6, xmm5
	; xmm6 = |  xmm5[3]  |  xmm5[2]  |     xmm5[1]     |     xmm5[0]     |
	
	pshufb xmm6, [maxPixelsMedio]
	; xmm6 = |     0     |     0     |     xmm5[2]     |     xmm5[1]     |
	
	pmaxub xmm0, xmm6
	; xmm0 = |   fruta   |   fruta   | max(col1, col3, xmm3[2], xmm5[2]) | max(col0, col2, xmm3[1], xmm5[1]) |
	
	; tengo:
	; xmm0 = |   fruta   |   fruta   | max*(p1) | max*(p0) |
	; xmm0 = |   fruta   |   fruta   | maxA1 | maxR1 | maxG1 | maxB1 | maxA0 | maxR0 | maxG0 | maxB0 |
	;                                 63      55      47      39      31      23      15      7     0
	
	; if (maxR >= maxG && maxR >= maxB){
	; 	res = 1 + alpha;
	; }
	; else
	; {
	; 		res = 1 - alpha;
	; }
	
	; if (maxR < maxG && maxG >= maxB){
	; 	res = 1 + alpha;
	; }
	; else
	; {
	; 		res = 1 - alpha;
	; }
	
	; if (maxR < maxB && maxG < maxB){
	; 	res = 1 + alpha;
	; }
	; else
	; {
	; 		res = 1 - alpha;
	; }

	
	
	; calculemos phiR, phiG, phiB
	; extiendo xmm0 para poder comparar
	; xmm0 = |     0     |     0     | maxB1 | maxR1 | maxG1 | maxB1 | maxB0 | maxR0 | maxG0 | maxB0 |
	;                                 63      55      47      39      31      23      15      7     0
	
	
	
	; reacomodo xmm0 para aprovechar mas comparaciones
	
	pshufb xmm0, [mask1]
	; xmm0 = |     0     |     0     | maxB1 | maxR1 | maxG1 | maxB1 | maxB0 | maxR0 | maxG0 | maxB0 |
	;                                 63      55      47      39      31      23      15      7     0
	
	movdqu xmm1, xmm0
	; xmm1 = |     0     |     0     | maxA1 | maxR1 | maxG1 | maxB1 | maxA0 | maxR0 | maxG0 | maxB0 |
	;                                 63      55      47      39      31      23      15      7     0
	
	pshufb xmm1, [mask2]
	; xmm1 = |     0     |     0     | maxG1 | maxG1 | maxR1 | maxR1 | maxG0 | maxG0 | maxR0 | maxR0 |
	;                                 63      55      47      39      31      23      15      7     0
	
	pcmpgtb xmm0, xmm1	; xmm0 > xmm1
	
	; xmm0 = |         0         | maxB1 > maxG1 | maxR1 > maxG1 | maxG1 > maxR1 | maxB1 > maxR1 | maxB0 > maxG0 | maxR0 > maxG0 | maxG0 > maxR0 | maxB0 > maxR0 |
	;         127                 63              55              47              39              31              23              15             7              0
	
	; niego la mascara, porque así me sirve para phiR
	mov xmm2, xmm0
	xor xmm2, [maskUnos]
	
	; xmm4 = | maxG1 <= maxR1 | maxB1 <= maxR1 | maxB1 <= maxG1 | maxG1 <= maxB1| basurax4 | maxG0 <= maxR1| maxB0 <= maxR1| maxB0 <= maxG1 | maxG0 <= maxB1 | basurax4 |
	
	
	mov xmm6, xmm4				;xmm6 = xmm4
	mov xmm7,xmm4				; xmm7 = xmm4
	pshufb xmm6,[mascaraYaNoSeQueNombrePonerle1]
		pshufb xmm7,[mascaraYaNoSeQueNombrePonerle2]
	;xmm6 = | | | maxB1 <= maxR1 | maxB0 <= maxR1| (todo en bytes)
	;xmm7 = | | | maxG1 <= maxR1 | maxG0 <= maxR1| (todo en bytes)
	
	
	; xmm15 = | 1 + alpha | 1 - alpha | 1 + alpha | 1 - alpha |
	
	
	
	pand xmm6,xmm7
	;xmm6 = | | | (maxB1 <= maxR1) & (maxG1 <= maxR1) |(maxB0 <= maxR1) & (maxG0 <= maxR1)| (todo en bytes)







 					; xmm6 = | phiR_0 | phiG_0 | phiB_0 | caca |
 					; xmm7 = | phiR_1 | phiG_1 | phiB_1 | caca |



	; USAR BLEND














 add rdi,8
 add rsi,8
 add r15, 1

 ; me fijo si estoy en el borde
 cmp r15,(ancho-2)/2  ; para ancho = 8, x = 3, para ancho = 12,
 jne continuar
 add rsi, 8 ; corrijo rsi
 add rdi,8

 continuar:

 loop

 ret


