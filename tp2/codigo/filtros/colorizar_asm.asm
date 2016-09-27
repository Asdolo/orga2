; void colorizar_asm (
;   unsigned char *src,
;   unsigned char *dst,
;   int cols,
;   int filas,
;   int src_row_size,
;   int dst_row_size,
;   float alpha
; );
 
; Parámetros:
;   rdi = src
;   rsi = dst
;   edx = cols
;   ecx = filas
;   r8 = src_row_size
;   r9 = dst_row_size
;   xmm0 = alpha
 
 
global colorizar_asm
 
section .rodata
    uno:                dw 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
    mascaraNegadoraXOR: db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    unoFloat:           dd 1.0, 1.0, 1.0, 1.0
    dosCincoCincoFloat: dd 255.0, 255.0, 255.0, 255.0
    maskInsertAlpha:    db 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
section .text
 
 
 
 
colorizar_asm:
 
  xor r8, r8
  mov r8d, edx                            ; r8 = ancho
  shl r8, 2                               ; r8 = ancho*4
 
  ; seteo los contadores
  xor r10, r10                            ; r10 = 0
  mov r10d, ecx                           ; r10 = alto
  sub r10, 2                              ; r10 = alto-2
 
 
  xor r9, r9                              ; r9 = 0
  mov r9d, edx                            ; r9 = ancho
  shr r9, 1                               ; r9 = ancho/2
  dec r9                                  ; r9 = (ancho/2)-1
  mov rcx, r9                             ; rcx = r9
 
  movdqu xmm15, [maskInsertAlpha]
 
  movdqu xmm14, [dosCincoCincoFloat]
  ; xmm9 =  | 255.0 | 255.0 | 255.0 | 255.0 |
 
  movdqu xmm12, [uno]
  ; xmm12 = | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
 
  movdqu xmm11, [mascaraNegadoraXOR]
 
  ; xmm0 =  |           |           |           |   alpha   |
  pshufd xmm0, xmm0, 0000000000b
  ; xmm0 =  |   alpha   |   alpha   |   alpha   |   alpha   |
  movdqu xmm10, xmm0
  ; xmm10 =  |   alpha   |   alpha   |   alpha   |   alpha   |
  pslldq xmm10, 4
  ; xmm10 =  |   alpha   |   alpha   |   alpha   |     0     |
  psrldq xmm10, 4
  ; xmm10 =  |     0     |   alpha   |   alpha   |   alpha   |
 
  movdqu xmm9, [unoFloat]
  ; xmm9 =  | 0.0 | 1.0 | 1.0 | 1.0 |
 
  ; inicializo el puntero rsi
 
  add rsi, r8
  add rsi, 4
 
  .ciclo:
 
    movdqu xmm0, [rdi]
    ; xmm0 = | A[0][3] | R[0][3] | G[0][3] | B[0][3] | A[0][2] | R[0][2] | G[0][2] | B[0][2] | A[0][1] | R[0][1] | G[0][1] | B[0][1] | A[0][0] | R[0][0] | G[0][0] | B[0][0] |
    ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0
 
    movdqu xmm1, [rdi + r8]
    ; xmm1 = | A[1][3] | R[1][3] | G[1][3] | B[1][3] | A[1][2] | R[1][2] | G[1][2] | B[1][2] | A[1][1] | R[1][1] | G[1][1] | B[1][1] | A[1][0] | R[1][0] | G[1][0] | B[1][0] |
    ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0
 
    movdqu xmm2, [rdi + 2*r8]
    ; xmm2 = | A[2][3] | R[2][3] | G[2][3] | B[2][3] | A[2][2] | R[2][2] | G[2][2] | B[2][2] | A[2][1] | R[2][1] | G[2][1] | B[2][1] | A[2][0] | R[2][0] | G[2][0] | B[2][0] |
    ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0
 
    ; calculo maximos por columnas
    movdqu xmm3, xmm1
    ; xmm3 = | A[1][3] | R[1][3] | G[1][3] | B[1][3] | A[1][2] | R[1][2] | G[1][2] | B[1][2] | A[1][1] | R[1][1] | G[1][1] | B[1][1] | A[1][0] | R[1][0] | G[1][0] | B[1][0] |
    ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0
 
    pmaxub xmm3,xmm2
    ; xmm3 = | max(pix[1][3], pix[2][3]) | max(pix[1][2], pix[2][2]) | max(pix[1][1], pix[2][1]) | max(pix[1][0], pix[2][0]) |
 
    pmaxub xmm3, xmm0
    ; xmm3 = | max(pix[0][3], pix[1][3], pix[2][3]) | max(pix[0][2], pix[1][2], pix[2][2]) | max(pix[0][1], pix[1][1], pix[2][1]) | max(pix[0][0], pix[1][0], pix[2][0]) |
    ; xmm3 = | max(col3]) | max(col2) | max(col1) | max(col0) |
 
    movdqu xmm4, xmm3
    ; xmm4 = | max(col3]) | max(col2) | max(col1) | max(col0) |
 
    psrldq xmm4, 8
    ; xmm4 = |     0     |     0     | max(col3) | max(col2)  |
 
    pmaxub xmm3, xmm4
    ; xmm3 = |   fruta   |   fruta   | max(col1, col3) | max(col0, col2) |
 
 
    movdqu xmm4, xmm2
    ; xmm4 = |  xmm2[3]  |  xmm2[2]  |     xmm2[1]     |     xmm2[0]     |
    psrldq xmm4, 4
    ; xmm4 = |     0     |  xmm2[3]  |     xmm2[2]     |     xmm2[1]     |
    pmaxub xmm3, xmm4
    ; xmm3 = |   fruta   |   fruta   | max(col1, col3, xmm2[2]) | max(col0, col2, xmm2[1]) |
 
    movdqu xmm4, xmm0
    ; xmm4 = |  xmm0[3]  |  xmm0[2]  |     xmm0[1]     |     xmm0[0]     |
    psrldq xmm4, 4
    ; xmm4 = |     0     |  xmm0[3]  |     xmm0[2]     |     xmm0[1]     |
    pmaxub xmm3, xmm4
    ; xmm3 = |   fruta   |   fruta   | max(col1, col3, xmm2[2], xmm0[2]) | max(col0, col2, xmm2[1], xmm0[1]) |
 
 
    movdqu xmm4, xmm1
    ; xmm4 = |  xmm1[3]  |  xmm1[2]  |     xmm1[1]     |     xmm1[0]     |
    psrldq xmm4, 4
    ; xmm4 = |     0     |  xmm1[3]  |     xmm1[2]     |     xmm1[1]     |
    pmaxub xmm3, xmm4
    ; xmm3 = |   fruta   |   fruta   | max(col1, col3, xmm2[2], xmm0[2], xmm1[2]) | max(col0, col2, xmm2[1], xmm0[1], xmm1[1]) |
 
 
    ; tengo:
    ; xmm3 = |   fruta   |   fruta   | maxA1 | maxR1 | maxG1 | maxB1 | maxA0 | maxR0 | maxG0 | maxB0 |
    ;         127                     63      55      47      39      31      23      15      7     0
 
    ; quiero calcular las máscaras para phiR, phiG, phiB
    ; extiendo xmm3 para poder comparar
    movdqu xmm0, xmm3
    ; xmm0 = |   fruta   |   fruta   | maxA1 | maxR1 | maxG1 | maxB1 | maxA0 | maxR0 | maxG0 | maxB0 |
    ;         127                     63      55      47      39      31      23      15      7     0
 
    pxor xmm2, xmm2
    ; xmm2 = | 0 | 0 | 0 | 0 |
 
    punpcklbw xmm0, xmm2
 
    ; xmm0 = | maxA1 | maxR1 | maxG1 | maxB1 | maxA0 | maxR0 | maxG0 | maxB0 |
    ;         127     111     95      79      63      47      31      15    0
 
    ; reacomodo xmm0 para aprovechar mas comparaciones
 
    pshuflw xmm0, xmm0, 00100100b
    ; xmm0 = | maxA1 | maxR1 | maxG1 | maxB1 | maxB0 | maxR0 | maxG0 | maxB0 |
    ;         127     111     95      79      63      47      31      15    0
 
    pshufhw xmm0, xmm0, 00100100b
    ; xmm0 = | maxB1 | maxR1 | maxG1 | maxB1 | maxB0 | maxR0 | maxG0 | maxB0 |
    ;         127     111     95      79      63      47      31      15    0
 
    movdqu xmm2, xmm0
    ; xmm2 = | maxB1 | maxR1 | maxG1 | maxB1 | maxB0 | maxR0 | maxG0 | maxB0 |
    ;         127     111     95      79      63      47      31      15    0
 
    pshuflw xmm2, xmm2, 01011010b
    ; xmm2 = | maxB1 | maxR1 | maxG1 | maxB1 | maxG0 | maxG0 | maxR0 | maxR0 |
    ;         127     111     95      79      63      47      31      15    0
 
    pshufhw xmm2, xmm2, 01011010b
    ; xmm2 = | maxG1 | maxG1 | maxR1 | maxR1 | maxG0 | maxG0 | maxR0 | maxR0 |
    ;         127     111     95      79      63      47      31      15    0
 
    pcmpgtw xmm0, xmm2  ; xmm0 > xmm2
 
    ; xmm0 = | maxB1 > maxG1 | maxR1 > maxG1 | maxG1 > maxR1 | maxB1 > maxR1 | maxB0 > maxG0 | maxR0 > maxG0 | maxG0 > maxR0 | maxB0 > maxR0 |
    ;         127             111             95              79              63              47              31              15            0
 
    ; niego la mascara, porque así me sirve para phiR
    movdqu xmm2, xmm0
    pxor xmm2, xmm11
 
    ; xmm2 = | maxB1 <= maxG1 | maxR1 <= maxG1 | maxG1 <= maxR1 | maxB1 <= maxR1 | maxB0 <= maxG0 | maxR0 <= maxG0 | maxG0 <= maxR0 | maxB0 <= maxR0 |
    ;         127              111              95               79               63               47               31               15             0
 
    ; phiR:
    ; if (maxR >= maxG && maxR >= maxB){
    ;   res = 1 + alpha;
    ; }
    ; else
    ; {
    ;       res = 1 - alpha;
    ; }
 
    ; xmm0 = | maxB1 > maxG1 | maxR1 > maxG1 | maxG1 > maxR1 | maxB1 > maxR1 | maxB0 > maxG0 | maxR0 > maxG0 | maxG0 > maxR0 | maxB0 > maxR0 |
    ;         127             111             95              79              63              47              31              15            0
 
    ; xmm2 = | maxB1 <= maxG1 | maxR1 <= maxG1 | maxG1 <= maxR1 | maxB1 <= maxR1 | maxB0 <= maxG0 | maxR0 <= maxG0 | maxG0 <= maxR0 | maxB0 <= maxR0 |
    ;         127              111              95               79               63               47               31               15             0
 
    ; acomodo para poder calcular maxR >= maxG && maxR >= maxB (máscara de phiR)
    movdqu xmm3, xmm2
    ; xmm3 = | maxB1 <= maxG1 | maxR1 <= maxG1 | maxG1 <= maxR1 | maxB1 <= maxR1 | maxB0 <= maxG0 | maxR0 <= maxG0 | maxG0 <= maxR0 | maxB0 <= maxR0 |
    ;         127              111              95               79               63               47               31               15             0
 
    psrldq xmm3, 2
    ; xmm3 = |        0       |     basura     |     basura     | maxG1 <= maxR1 |     basura     |     basura     |     basura     | maxG0 <= maxR0 |
    ;         127              111              95               79               63               47               31               15             0
 
    pand xmm3, xmm2
    ; xmm3 = |     basura     |     basura     |     basura     | maxR1 >= maxG1 && maxR1 >= maxB1 |     basura     |     basura     |     basura     | maxR0 >= maxG0 && maxR0 >= maxB0 |
    ;         127              111              95               79                                 63               47               31               15                               0
 
    ; me guardo la mascara de phiR en xmm4
    movdqu xmm4, xmm3
    ; xmm4 = |     basura     |     basura     |     basura     | maxR1 >= maxG1 && maxR1 >= maxB1 |     basura     |     basura     |     basura     | maxR0 >= maxG0 && maxR0 >= maxB0 |
    ;         127              111              95               79                                 63               47               31               15                               0
 
 
    ; phiG:
    ; if (maxR < maxG && maxG >= maxB){
    ;   res = 1 + alpha;
    ; }
    ; else
    ; {
    ;       res = 1 - alpha;
    ; }
 
    ; xmm0 = | maxB1 > maxG1 | maxR1 > maxG1 | maxG1 > maxR1 | maxB1 > maxR1 | maxB0 > maxG0 | maxR0 > maxG0 | maxG0 > maxR0 | maxB0 > maxR0 |
    ;         127             111             95              79              63              47              31              15            0
 
    ; xmm2 = | maxB1 <= maxG1 | maxR1 <= maxG1 | maxG1 <= maxR1 | maxB1 <= maxR1 | maxB0 <= maxG0 | maxR0 <= maxG0 | maxG0 <= maxR0 | maxB0 <= maxR0 |
    ;         127              111              95               79               63               47               31               15             0
 
    ; acomodo para poder calcular maxR < maxG && maxG >= maxB (máscara de phiG)
    movdqu xmm3, xmm0
    ; xmm3 = | maxB1 > maxG1 | maxR1 > maxG1 | maxG1 > maxR1 | maxB1 > maxR1 | maxB0 > maxG0 | maxR0 > maxG0 | maxG0 > maxR0 | maxB0 > maxR0 |
    ;         127             111             95              79              63              47              31              15            0
 
    pslldq xmm3, 4
 
    ; xmm3 = | maxG1 > maxR1 |     basura     |     basura     |     basura     | maxG0 > maxR0 |     basura     |        0       |        0       |
    ;         127             111              95               79               63              47               31               15             0
 
    pand xmm3, xmm2
 
    ; xmm3 = | maxR1 < maxG1 && maxG1 >= maxB1 |     basura     |     basura     |     basura     | maxR0 < maxG0 && maxG0 >= maxB0 |     basura     |     basura     |     basura     |
    ;         127                               111              95               79               63                                47               31               15             0
 
    ; me guardo la mascara de phiG en xmm5
    movdqu xmm5, xmm3
    ; xmm5 = | maxR1 < maxG1 && maxG1 >= maxB1 |     basura     |     basura     |     basura     | maxR0 < maxG0 && maxG0 >= maxB0 |     basura     |     basura     |     basura     |
    ;         127                               111              95               79               63                                47               31               15             0
 
 
 
    ; phiB
    ; if (maxR < maxB && maxG < maxB){
    ;   res = 1 + alpha;
    ; }
    ; else
    ; {
    ;       res = 1 - alpha;
    ; }
 
    ; xmm0 = | maxB1 > maxG1 | maxR1 > maxG1 | maxG1 > maxR1 | maxB1 > maxR1 | maxB0 > maxG0 | maxR0 > maxG0 | maxG0 > maxR0 | maxB0 > maxR0 |
    ;         127             111             95              79              63              47              31              15            0
 
    ; xmm2 = | maxB1 <= maxG1 | maxR1 <= maxG1 | maxG1 <= maxR1 | maxB1 <= maxR1 | maxB0 <= maxG0 | maxR0 <= maxG0 | maxG0 <= maxR0 | maxB0 <= maxR0 |
    ;         127              111              95               79               63               47               31               15             0
 
    ; acomodo para poder calcular maxR < maxG && maxG >= maxB (máscara de phiG)
    movdqu xmm3, xmm0
    ; xmm3 = | maxB1 > maxG1 | maxR1 > maxG1 | maxG1 > maxR1 | maxB1 > maxR1 | maxB0 > maxG0 | maxR0 > maxG0 | maxG0 > maxR0 | maxB0 > maxR0 |
    ;         127             111             95              79              63              47              31              15            0
 
    psrldq xmm3, 6
 
    ; xmm3 = |        0       |        0       |        0       | maxB1 > maxG1 |     basura     |     basura     |     basura     | maxB0 > maxG0 |
    ;         127              111              95               79              63               47               31               15            0
 
    pand xmm3, xmm0
 
    ; xmm3 = |     basura     |     basura     |     basura     | maxR1 < maxB1 && maxG1 < maxB1 |     basura     |     basura     |     basura     | maxR0 < maxB0 && maxG0 < maxB0 |
    ;         127              111              95               79                               63               47               31               15                             0
 
    ; me guardo la mascara de phiB en xmm6
    movdqu xmm6, xmm3
    ; xmm6 = |     basura     |     basura     |     basura     | maxR1 < maxB1 && maxG1 < maxB1 |     basura     |     basura     |     basura     | maxR0 < maxB0 && maxG0 < maxB0 |
    ;         127              111              95               79                               63               47               31               15                             0
 
 
 
    ; Uno todas las máscaras en un solo registro
 
    ; xmm4 = |      basura      |      basura      |      basura      | condicion(PhiR1) |      basura      |      basura      |      basura      | condicion(PhiR0) |
    ;         127                111                95                 79                 63                 47                 31                 15               0
    ; xmm5 = | condicion(PhiG1) |      basura      |      basura      |      basura      | condicion(PhiG0) |      basura      |      basura      |      basura      |
    ;         127                111                95                 79                 63                 47                 31                 15               0
    ; xmm6 = |      basura      |      basura      |      basura      | condicion(PhiB1) |      basura      |      basura      |      basura      | condicion(PhiB0) |
    ;         127                111                95                 79                 63                 47                 31                 15               0
 
    movdqu xmm0, xmm4
    ; xmm0 = |      basura      |      basura      |      basura      | condicion(PhiR1) |      basura      |      basura      |      basura      | condicion(PhiR0) |
    ;         127                111                95                 79                 63                 47                 31                 15               0
 
    psrldq xmm5, 4
    ; xmm5 = |      basura      |      basura      | condicion(PhiG0) |      basura      |      basura      |      basura      | condicion(PhiG0) |      basura      |
    ;         127                111                95                 79                 63                 47                 31                 15               0
 
    pblendw xmm0, xmm5, 00100010b
    ; xmm0 = |      basura      |      basura      | condicion(PhiG1) | condicion(PhiR1) |      basura      |      basura      | condicion(PhiG0) | condicion(PhiR0) |
    ;         127                111                95                 79                 63                 47                 31                 15               0
 
    pslldq xmm6, 4
    ; xmm6 = |      basura      | condicion(PhiB1) |      basura      |      basura      |      basura      | condicion(PhiB0) |      basura      |      basura      |
    ;         127                111                95                 79                 63                 47                 31                 15               0
 
    pblendw xmm0, xmm6, 01000100b
    ; xmm0 = |      basura      | condicion(PhiB1) | condicion(PhiG1) | condicion(PhiR1) |      basura      | condicion(PhiB1) | condicion(PhiG0) | condicion(PhiR0) |
    ;         127                111                95                 79                 63                 47                 31                 15               0
 
    ; a partir de acá la idea es generar una máscara con 1 (0x0001) donde la condición es true y -1 (0xFFFF) donde la condición es false,
    ; para luego multiplicar dicha máscara por alpha, para luego poder restarle a 1.0
 
    movdqu xmm2, xmm0
    movdqu xmm3, xmm0
    ; xmm2 = |      basura      | condicion(PhiB1) | condicion(PhiG1) | condicion(PhiR1) |      basura      | condicion(PhiB1) | condicion(PhiG0) | condicion(PhiR0) |
    ;         127                111                95                 79                 63                 47                 31                 15               0
 
    ; xmm3 = |      basura      | condicion(PhiB1) | condicion(PhiG1) | condicion(PhiR1) |      basura      | condicion(PhiB1) | condicion(PhiG0) | condicion(PhiR0) |
    ;         127                111                95                 79                 63                 47                 31                 15               0
 
    ; Convierto la máscara: donde hay 0xFFFF pongo 0x0001
    pand xmm2, xmm12
    ; xmm2 = |        0       | (bool) condicion(PhiB1) | (bool) condicion(PhiG1) | (bool) condicion(PhiR1) |        0       | (bool) condicion(PhiB0) | (bool) condicion(PhiG0) | (bool) condicion(PhiR0) |
    ;         127              111                       95                        79                        63               47                        31                        15                      0
 
    pxor xmm3, xmm11
    ;xmm3 = |      0xFFFF     | ¬condicion(PhiB1) | ¬condicion(PhiG1) | ¬condicion(PhiR1) |      0xFFFF     | ¬condicion(PhiB0) | ¬condicion(PhiG0) | ¬condicion(PhiR0) |
    ;         127              111                 95                  79                  63                47                  31                  15                0
 
    ; tengo en xmm3: 0x0000 si es true, 0xFFFF si es false
 
    paddw xmm3, xmm2
    ; le sumo 0x0001 a "los true" y 0x0000 a "los false"
    ; tengo en xmm3: 0x0001 (1 signed) si es true, 0xFFFF (-1 signed) si es false
 
    ; genero la máscara de extensión de signo
    ; comparo CON SIGNO xmm2 (todo 0) con xmm3.
    pxor xmm2, xmm2
    pcmpgtw xmm2, xmm3
    ; Recordemos que: 0xFFFF (-1) < 0x0000 (0) < 0x0001 (1)
 
    movdqu xmm0, xmm3
    ; tengo en xmm0: 0x0001 (1 signed) si es true, 0xFFFF (-1 signed) si es false
 
    ; desempaco word a doubleword, para que los int ocupen 32 bits y luego poder convertirlos a float, usando la máscara xmm2
    punpcklwd xmm0, xmm2
    ; xmm0 = |        0       | if condicion(PhiB0) then 0x00000001 else 0xFFFFFFFF fi | if condicion(PhiG0) then 0x00000001 else 0xFFFFFFFF fi | if condicion(PhiR0) then 0x00000001 else 0xFFFFFFFF fi |
    ;         127              95                                                       63                                                       31                                                     0
    punpckhwd xmm3, xmm2
    ; xmm3 = |        0       | if condicion(PhiB1) then 0x00000001 else 0xFFFFFFFF fi | if condicion(PhiG1) then 0x00000001 else 0xFFFFFFFF fi | if condicion(PhiR1) then 0x00000001 else 0xFFFFFFFF fi |
    ;         127              95                                                       63                                                       31                                                     0
 
    ; Recién ahora puedo convertir los 1 y -1 a float:
    cvtdq2ps xmm0, xmm0
    ; xmm0 = |        0       | if condicion(PhiB0) then 1.0 else -1.0 fi | if condicion(PhiG0) then 1.0 else -1.0 fi | if condicion(PhiR0) then 1.0 else -1.0 fi |
    ;         127              95                                          63                                          31                                        0
 
    cvtdq2ps xmm3, xmm3
    ; xmm3 = |        0       | if condicion(PhiB1) then 1.0 else -1.0 fi | if condicion(PhiG1) then 1.0 else -1.0 fi | if condicion(PhiR1) then 1.0 else -1.0 fi |
    ;         127              95                                          63                                          31                                        0
 
    mulps xmm0, xmm10
    ; xmm0 = |        0       | if condicion(PhiB0) then alpha else -alpha fi | if condicion(PhiG0) then alpha else -alpha fi | if condicion(PhiR0) then alpha else -alpha fi |
    ;         127              95                                              63                                              31                                            0
 
    mulps xmm3, xmm10
    ; xmm3 = |        0       | if condicion(PhiB1) then alpha else -alpha fi | if condicion(PhiG1) then alpha else -alpha fi | if condicion(PhiR1) then alpha else -alpha fi |
    ;         127              95                                              63                                              31                                            0
 
    ; xmm9 =  | 0.0 | 1.0 | 1.0 | 1.0 |
 
    addps xmm0, xmm9
    ; xmm0 = |        0       | PhiB0 | PhiG0 | PhiR0 |
    ;         127              95      63      31    0
 
    addps xmm3, xmm9
    ; xmm3 = |        0       | PhiB1 | PhiG1 | PhiR1 |
    ;         127              95      63      31    0
 
 
    ; tengo:
    ; xmm1 = | A[1][3] | R[1][3] | G[1][3] | B[1][3] | A[1][2] | R[1][2] | G[1][2] | B[1][2] | A[1][1] | R[1][1] | G[1][1] | B[1][1] | A[1][0] | R[1][0] | G[1][0] | B[1][0] |
    ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0
 
    pslldq xmm1, 4
    ; xmm1 = | A[1][2] | R[1][2] | G[1][2] | B[1][2] | A[1][1] | R[1][1] | G[1][1] | B[1][1] | A[1][0] | R[1][0] | G[1][0] | B[1][0] |    0    |    0    |    0    |    0    |
    ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0
 
    psrldq xmm1, 8
    ; xmm1 = |    0    |    0    |    0    |    0    |    0    |    0    |    0    |    0    | A[1][2] | R[1][2] | G[1][2] | B[1][2] | A[1][1] | R[1][1] | G[1][1] | B[1][1] |
    ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0
 
    ; xmm1 = |    00    |    00    |    00    |    00    |    00    |    00    |    00    |    00    |    A1    |    R1    |    G1    |    B1    |    A0    |    R0    |    G0    |    B0    |
    ;         127        119        111        103        95         87         79         71         63         55         47         39         31         23         15         7        0
 
    movdqu xmm8, xmm1
    ; xmm8= |    00    |    00    |    00    |    00    |    00    |    00    |    00    |    00    |    A1    |    R1    |    G1    |    B1    |    A0    |    R0    |    G0    |    B0    |
    ;         127        119        111        103        95         87         79         71         63         55         47         39         31         23         15         7        0
 
 
    ; extiendo de byte a word
    pxor xmm4, xmm4
    punpcklbw xmm1, xmm4
    ; xmm1 = |    A1    |    R1    |    G1    |    B1    |    A0    |    R0    |    G0    |    B0    |
    ;         127        111        95         79         63         47         31         15       0
 
    movdqu xmm2, xmm1
    ; xmm2 = |    A1    |    R1    |    G1    |    B1    |    A0    |    R0    |    G0    |    B0    |
    ;         127        111        95         79         63         47         31         15       0
 
    psrldq xmm2, 8
    ; xmm2 = |    00    |    00    |    00    |    00    |    A1    |    R1    |    G1    |    B1    |
    ;         127        111        95         79         63         47         31         15       0
 
    punpcklwd xmm1, xmm4
    ; xmm1 = |    A0    |    R0    |    G0    |    B0    |
    ;         127        95         63         31       0
 
    punpcklwd xmm2, xmm4
    ; xmm2 = |    A1    |    R1    |    G1    |    B1    |
    ;         127        95         63         31       0
 
    cvtdq2ps xmm1, xmm1
    ; xmm1 = |    A0    |    R0    |    G0    |    B0    |
    ;         127        95         63         31       0
    cvtdq2ps xmm2, xmm2
    ; xmm2 = |    A1    |    R1    |    G1    |    B1    |
    ;         127        95         63         31       0
 
    ; teníamos...:
 
    ; xmm0 = |        0       | PhiB0 | PhiG0 | PhiR0 |
    ;         127              95      63      31    0
    ; xmm3 = |        0       | PhiB1 | PhiG1 | PhiR1 |
    ;         127              95      63      31    0
 
    shufps xmm0, xmm0, 11000110b
    ; xmm0 = |        0       | PhiR0 | PhiG0 | PhiB0 |
    ;         127              95      63      31    0
    shufps xmm3, xmm3, 11000110b
    ; xmm3 = |        0       | PhiR1 | PhiG1 | PhiB1 |
    ;         127              95      63      31    0
 
    ; p_d->r = min(255.0, phiR * p_s->r);
    ; p_d->g = min(255.0, phiG * p_s->g);
    ; p_d->b = min(255.0, phiB * p_s->b);
    ; p_d->a = p_s->a;
 
    mulps xmm0, xmm1
    ; xmm0 = |   basura   | PhiR0 * R0 | PhiG0 * G0 | PhiB0 * B0 |
    ;         127          95           63           31         0
 
    mulps xmm3, xmm2
    ; xmm3 = |   basura   | PhiR1 * R1 | PhiG1 * G1 | PhiB1 * B1 |
    ;         127          95           63           31         0
 
    movdqu xmm1, xmm3
    ; xmm1 = |   basura   | PhiR1 * R1 | PhiG1 * G1 | PhiB1 * B1 |
    ;         127          95           63           31         0
 
 
    ; minimo entre eso y 255.0
    ; minps xmm0, xmm14
    ; xmm0 = |   basura   | min(255.0, PhiR0 * R0) | min(255.0, PhiG0 * G0) | min(255.0, PhiB0 * B0) |
    ;         127          95                       63                       31                     0
    ; minps xmm3, xmm14
    ; xmm3 = |   basura   | min(255.0, PhiR1 * R1) | min(255.0, PhiG1 * G1) | min(255.0, PhiB1 * B1) |
    ;         127          95                       63                       31                     0
 
    cvtps2dq xmm0, xmm0
    ; xmm0 = |   basura   | min(255.0, PhiR0 * R0) | min(255.0, PhiG0 * G0) | min(255.0, PhiB0 * B0) |
    ;         127          95                       63                       31                     0
 
    cvtps2dq xmm3, xmm3
    ; xmm3 = |   basura   | min(255.0, PhiR1 * R1) | min(255.0, PhiG1 * G1) | min(255.0, PhiB1 * B1) |
    ;         127          95                       63                       31                     0
 
    packusdw xmm0, xmm3
    ; xmm0 = |   basura   | min(255.0, PhiR1 * R1) | min(255.0, PhiG1 * G1) | min(255.0, PhiB1 * B1) |   basura   | min(255.0, PhiR0 * R0) | min(255.0, PhiG0 * G0) | min(255.0, PhiB0 * B0) |
    ;         127          111                      95                       79                       63           47                       31                       15                     0
 
    pxor xmm1, xmm1
    packuswb xmm0, xmm1
    ; xmm0 = |   basura   | min(255.0, PhiR1 * R1) | min(255.0, PhiG1 * G1) | min(255.0, PhiB1 * B1) |   basura   | min(255.0, PhiR0 * R0) | min(255.0, PhiG0 * G0) | min(255.0, PhiB0 * B0) |
    ;         127          111                      95                       79                       63           47                       31                       15                     0
 
    ; xmm0 = |  00  |  00  |  00  |  00  |  00  |  00  |  00  |  00  | basura | f(G1) | f(G1) | f(B1) | basura | f(G0) | f(G0) | f(B0) |
    ;         127                         95                          63                               31                             0
 
    ; inserto los valores de alpha
    ; xmm8= |    00    |    00    |    00    |    00    |    00    |    00    |    00    |    00    |    A1    |    R1    |    G1    |    B1    |    A0    |    R0    |    G0    |    B0    |
    ;         127        119        111        103        95         87         79         71         63         55         47         39         31         23         15         7        0
 
    movdqu xmm1, xmm0
    movdqu xmm0, xmm15 ; cargo la máscara en xmm0 (operando implícito de pblendvb)
    pblendvb xmm1, xmm8
 
    ; xmm1 = |  00  |  00  |  00  |  00  |  00  |  00  |  00  |  00  |  A1  | f(G1) | f(G1) | f(B1) |  A0  | f(G0) | f(G0) | f(B0) |
    ;         127                         95                          63                             31                           0
 
    ; hago movq así solo escribo los 64 bits más bajos de xmm0
    movq [rsi], xmm1
 
    add rdi, 8
    add rsi, 8
 
    dec rcx
    jnz .ciclo
 
    ; reseteo el contador
    mov rcx, r9                             ; rcx = r9
 
    ; acomodo los punteros a la fila de arriba
    add rdi, 8
    add rsi, 8
 
    sub r10, 1
    cmp r10, 0
    jne .ciclo
 
  ret