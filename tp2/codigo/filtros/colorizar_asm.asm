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
; 	rdx = cols
; 	rcx = filas
; 	r8 = src_row_size
; 	r9 = dst_row_size
;   xmm0 = alpha


global colorizar_asm


section .text




colorizar_asm:

	
rdi+algo para que agarre borde
8*8
rdi+fila+1pixel



0 - - - - - - - - - - - - - - 15
0 - - - - - - - - - - - - - - 15                                      
0 x x x x x x - - - - - - - - 15			
0 - - - - - - - - - - - - - - 15
^
rdi

RSI VA A EMPEZAR EN 
0 - - - - - - - - - - - 8
0 - - - - - - - - - - - 8
0 - - - - - - - - - - - 8




;movemos rsi al primer pixel que va a ser efectivamente procesado
add rsi, ancho*4+4

mov r12d, ecx ;r12d = filas

; seteamos la cantidad de loops
xor rcx, rcx

mov ecx, r12d 		; ecx = filas
sub ecx, 2 		; ecx = filas - 2

mov eax,edx		; eax = ancho
sub eax,2		; eax = ancho - 2
shr eax,1		; eax = (ancho-2)/2
mul ecx			; eax = (ancho-2)/2 * (filas-2)
mov ecx, eax		; ecx = (ancho-2)/2 * (filas-2)

;CONTADORLOOP= ecx=((ancho-2)/2)*(filas-2)

.ciclo:
	
	movups xmm0, [rdi] 			; xmm0 = |ab_a3 ab_r3 ab_g3 ab_b3|ab_a2 ab_r2 ab_g2 ab_b2|ab_a1 ab_r1 ab_g1 ab_b1|ab_a0 ab_r0 ab_g0 ab_b0|
movups xmm1, [rdx*4 +rdi]		; xmm1 = |me_a3 me_r3 me_g3 me_b3|me_a2 me_r2 me_g2 me_b2|me_a1 me_r1 me_g1 me_b1|me_a0 me_r0 me_g0 me_b0|
movups xmm2, [rdx*8+rdi]		; xmm2 = |ar_a3 ar_r3 ar_g3 ar_b3|ar_a2 ar_r2 ar_g2 ar_b2|ar_a1 ar_r1 ar_g1 ar_b1|ar_a0 ar_r0 ar_g0 ar_b0|

					

pmaxub xmm0,xmm1
pmaxub xmm0,xmm2		
	
					; xmm0 = | max(col3) | max(col2) | max(col1) | max(col0) |
movups xmm3, xmm0


mov xmm4,xmm0				; xmm4 = | max(col3) | max(col2) | max(col1) | max(col0) |
mov xmm5,xmm0				; xmm5 = | max(col3) | max(col2) | max(col1) | max(col0) |

shufb xmm5,[MASCARALOCA]		; xmm5 = | max(col2) | max(col3) | max(col0) | max(col1)  |

pmaxub xmm4,xmm5			; xmm4 = | max(col3, col2) | basura | max(col1, col0) | basura |

shufb xmm5[MASCARALOCA2]            ; xmm5 =  | max(col1) 		    | basura | max(col2) 		 | max(col1)  |
pmaxub xmm4 ,xmm5			; xmm4 = | max(col3, col2, col1) | basura | max(col2, col1, col0) | basura |
					; xmm4 = | maxA1 | maxR1 | maxG1 | maxB1 | basurax4 | maxA0 | maxR0 | maxG0 | maxB0 | basurax4 |

movups xmm10,xmm4

pshufb xmm4,[reordenarMaximos]	; xmm4 = | maxR1 | maxR1 | maxG1 | maxB1 | basurax4 | maxR0 | maxR0 | maxG0 | maxB0 | basurax4 |
mov xmm5, xmm4				; xmm5 = | maxR1 | maxR1 | maxG1 | maxB1 | basurax4 | maxR0 | maxR0 | maxG0 | maxB0 | basurax4 |

pshufb xmm5,[reordenarMaximos2]	; xmm5 = | maxG1 | maxB1 | maxB1 | maxG1 | basurax4 | maxG0 | maxB0 | maxB0 | maxG0 | basurax4 |


; calculemos phiR, phiG, phiB
pcmpgtb xmm5, xmm4

; xmm5 = | maxG1 > maxR1 | maxB1 > maxR1 | maxB1 > maxG1 | maxG1 > maxB1| basurax4 | maxG0 > maxR1| maxB0 > maxR1| maxB0 > maxG1 | maxG0 > maxB1 | basurax4 |

mov xmm4, xmm5
xor xmm4, [mask_todo_1_128_bits]

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









/*
if (maxR >= maxG && maxR >= maxB){
		res = 1 + alpha;
	}

*/

	
	
					; xmm6 = | phiR_0 | phiG_0 | phiB_0 | caca |
					; xmm7 = | phiR_1 | phiG_1 | phiB_1 | caca |







https://github.com/Asdolo/orga2/blob/master/tp2/codigo/filtros/colorizar_c.c




















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

