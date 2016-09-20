; void pixelar_asm (
;   unsigned char *src,
;   unsigned char *dst,
;   int cols,
;   int filas,
;   int src_row_size,
;   int dst_row_size
; );

; Parámetros:
;   rdi = src
;   rsi = dst
;   rdx = cols
;   rcx = filas
;   r8 = src_row_size
;   r9 = dst_row_size




global pixelar_asm
section .rodata
    ;mascaraExtend: db 0x00,0xFF,0x01,0xFF,0x02,0xFF,0x03,0xFF,0x04,0xFF,0x05,0xFF,0x06,0xFF,0x07,0xFF,0x08,0xFF
    ;mascaraOrdenadora: db 0x00, 0x02, 0x04, 0x06, 0x00, 0x02, 0x04, 0x06, 0x00, 0x02, 0x04, 0x06, 0x00, 0x02, 0x04, 0x06
    ;mascaraLOCA:       db 0x00, 0x00, 0x08, 0x09, 0x02, 0x03, 0x0a, 0x0b, 0x04, 0x05, 0x0c, 0x0d, 0x06, 0x07, 0x0e, 0x0f
    mascaraExtensoraYHADDIzq:   db 0x00, 0xFF, 0x04, 0xFF, 0x01, 0xFF, 0x05, 0xFF, 0x02, 0xFF, 0x06, 0xFF, 0x03, 0xFF, 0x07, 0xFF
    mascaraExtensoraYHADDDer:   db 0x08, 0xFF, 0x0C, 0xFF, 0x09, 0xFF, 0x0D, 0xFF, 0x0A, 0xFF, 0x0E, 0xFF, 0x0B, 0xFF, 0x0F, 0xFF
    mascaraLimpiadoraAND:       db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    mascaraWordAByte:       db 0x00, 0x02, 0x04, 0x06, 0x00, 0x02, 0x04, 0x06, 0x08, 0x0A, 0x0C, 0x0E, 0x08, 0x0A, 0x0C, 0x0E
    
section .text

pixelar_asm:
    ; r10 va a ser una constante = ancho*4
    ; r11 va a ser una constante = ancho/4

    xor r10, r10                 ; r10 =  0
    mov r10d, edx                ; r10 = ancho
    shl r10, 2                   ; r10 = ancho*4

    xor r11, r11                 ; r10 =  0
    mov r11d, edx                ; r10 = ancho
    shr r11, 2                   ; r10 = ancho/4

    ;mov eax, r8d                ; eax = alto
    ;shr eax, 1                  ; eax = alto/2
    ;mul ecx                     ; eax = (ancho/4)*(alto/2)
    ;mov rcx, rax                ; rcx = (ancho/4)*(alto/2)

    ; r9 va a ser un iterador = alto
    xor r9, r9                              ; r9 = 0
    mov r9d, ecx                            ; r9 = alto

    ; seteo el contador
    mov rcx, r11                            ; rbx = ancho/4

    movdqu xmm10, [mascaraExtensoraYHADDIzq]
    movdqu xmm11, [mascaraExtensoraYHADDDer]
    movdqu xmm12, [mascaraLimpiadoraAND]
    movdqu xmm13, [mascaraWordAByte]

 .ciclo:

        movdqu xmm0, [rdi]
        ; xmm0 = | A[0][3] | R[0][3] | G[0][3] | B[0][3] | A[0][2] | R[0][2] | G[0][2] | B[0][2] | A[0][1] | R[0][1] | G[0][1] | B[0][1] | A[0][0] | R[0][0] | G[0][0] | B[0][0] |
        ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0                                                                                                                                                        0

        movdqu xmm1, [rdi+r10]
        ; xmm0 = | A[1][3] | R[1][3] | G[1][3] | B[1][3] | A[1][2] | R[1][2] | G[1][2] | B[1][2] | A[1][1] | R[1][1] | G[1][1] | B[1][1] | A[1][0] | R[1][0] | G[1][0] | B[1][0] |
        ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0

        ; Tengo que sacar el promedio de estos 4 pixeles: [0][0], [0][1], [1][0], [1][1]
        ; Tengo que sacar el promedio de estos 4 pixeles: [0][2], [0][3], [1][2], [1][3]






        ; Calculo el promedio de [0][0], [0][1], [1][0], [1][1]

        movdqu xmm2, xmm0
        ; xmm2 = | A[0][3] | R[0][3] | G[0][3] | B[0][3] | A[0][2] | R[0][2] | G[0][2] | B[0][2] | A[0][1] | R[0][1] | G[0][1] | B[0][1] | A[0][0] | R[0][0] | G[0][0] | B[0][0] |
        ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0

        pshufb xmm2, xmm10
        ; xmm2 = |    0    | A[0][1] |    0    | A[0][0] |    0    | R[0][1] |    0    | R[0][0] |    0    | G[0][1] |    0    | G[0][0] |    0    | B[0][1] |    0    | B[0][0] |
        ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0                                                                                                                                                        0

        movdqu xmm3, xmm1
        ; xmm3 = | A[1][3] | R[1][3] | G[1][3] | B[1][3] | A[1][2] | R[1][2] | G[1][2] | B[1][2] | A[1][1] | R[1][1] | G[1][1] | B[1][1] | A[1][0] | R[1][0] | G[1][0] | B[1][0] |
        ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0

        pshufb xmm3, xmm10
        ; xmm3 = |    0    | A[1][1] |    0    | A[1][0] |    0    | R[1][1] |    0    | R[1][0] |    0    | G[1][1] |    0    | G[1][0] |    0    | B[1][1] |    0    | B[1][0] |
        ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0                                                                                                                                                        0

        phaddw xmm2, xmm3
        ; xmm2 = | A[1][1] + A[1][0] | R[1][1] + R[1][0] | G[1][1] + G[1][0] | B[1][1] + B[1][0] | A[0][1] + A[0][0] | R[0][1] + R[0][0] | G[0][1] + G[0][0] | B[0][1] + B[0][0] |
        ;         127                 111                 95                  79                  63                  47                  31                  15                0

        movdqu xmm3, xmm2
        ; xmm3 = | A[1][1] + A[1][0] | R[1][1] + R[1][0] | G[1][1] + G[1][0] | B[1][1] + B[1][0] | A[0][1] + A[0][0] | R[0][1] + R[0][0] | G[0][1] + G[0][0] | B[0][1] + B[0][0] |
        ;         127                 111                 95                  79                  63                  47                  31                  15                0

        psrldq xmm3, 8 ; shifteo xmm3 8 bytes a la derecha (a la izquierda pone ceros)
        ; xmm3 = |         0         |         0         |         0         |         0         | A[1][1] + A[1][0] | R[1][1] + R[1][0] | G[1][1] + G[1][0] | B[1][1] + B[1][0] |
        ;         127                 111                 95                  79                  63                  47                  31                  15                0

        paddw xmm2, xmm3
        ; xmm2 = | fruta | fruta | fruta | fruta | A[1][1] + A[1][0] + A[0][1] + A[0][0] | R[1][1] + R[1][0] + R[0][1] + R[0][0] | G[1][1] + G[1][0] + G[0][1] + G[0][0] | B[1][1] + B[1][0] + B[0][1] + B[0][0] |
        ;         127                             63                                      47                                      31                                      15                                    0

        psrlw xmm2, 2 ; shifteo xmm2 word a word 2 bits (divido por 2² = 4)
        ; xmm2 = | fruta | fruta | fruta | fruta | (A[1][1] + A[1][0] + A[0][1] + A[0][0]) / 4 | (R[1][1] + R[1][0] + R[0][1] + R[0][0]) / 4 | (G[1][1] + G[1][0] + G[0][1] + G[0][0]) / 4 | (B[1][1] + B[1][0] + B[0][1] + B[0][0]) / 4 |
        ;         127                             63                                            47                                            31                                            15                                          0

        movdqu xmm4, xmm2
        ; xmm4 = | fruta | fruta | fruta | fruta | (A[1][1] + A[1][0] + A[0][1] + A[0][0]) / 4 | (R[1][1] + R[1][0] + R[0][1] + R[0][0]) / 4 | (G[1][1] + G[1][0] + G[0][1] + G[0][0]) / 4 | (B[1][1] + B[1][0] + B[0][1] + B[0][0]) / 4 |
        ;         127                             63                                            47                                            31                                            15                                          0


        ; Limpio la fruta con 0
        pand xmm4, xmm12
        ; xmm4 = |   0   |   0   |   0   |   0   | (A[1][1] + A[1][0] + A[0][1] + A[0][0]) / 4 | (R[1][1] + R[1][0] + R[0][1] + R[0][0]) / 4 | (G[1][1] + G[1][0] + G[0][1] + G[0][0]) / 4 | (B[1][1] + B[1][0] + B[0][1] + B[0][0]) / 4 |
        ;         127                             63                                            47                                            31                                            15                                          0




        ; Calculo el promedio de [0][2], [0][3], [1][2], [1][3]

        movdqu xmm2, xmm0
        ; xmm2 = | A[0][3] | R[0][3] | G[0][3] | B[0][3] | A[0][2] | R[0][2] | G[0][2] | B[0][2] | A[0][1] | R[0][1] | G[0][1] | B[0][1] | A[0][0] | R[0][0] | G[0][0] | B[0][0] |
        ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0

        pshufb xmm2, xmm11
        ; xmm2 = |    0    | A[0][3] |    0    | A[0][2] |    0    | R[0][3] |    0    | R[0][2] |    0    | G[0][3] |    0    | G[0][2] |    0    | B[0][3] |    0    | B[0][2] |
        ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0                                                                                                                                                        0

        movdqu xmm3, xmm1
        ; xmm3 = | A[1][3] | R[1][3] | G[1][3] | B[1][3] | A[1][2] | R[1][2] | G[1][2] | B[1][2] | A[1][1] | R[1][1] | G[1][1] | B[1][1] | A[1][0] | R[1][0] | G[1][0] | B[1][0] |
        ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0

        pshufb xmm3, xmm11
        ; xmm3 = |    0    | A[1][3] |    0    | A[1][2] |    0    | R[1][3] |    0    | R[1][2] |    0    | G[1][3] |    0    | G[1][2] |    0    | B[1][3] |    0    | B[1][2] |
        ;         127       119       111       103       95        87        79        71        63        55        47        39        31        23        15        7       0                                                                                                                                                        0

        phaddw xmm2, xmm3
        ; xmm2 = | A[1][3] + A[1][2] | R[1][3] + R[1][2] | G[1][3] + G[1][2] | B[1][3] + B[1][2] | A[0][3] + A[0][2] | R[0][3] + R[0][2] | G[0][3] + G[0][2] | B[0][3] + B[0][2] |
        ;         127                 111                 95                  79                  63                  47                  31                  15                0

        movdqu xmm3, xmm2
        ; xmm3 = | A[1][3] + A[1][2] | R[1][3] + R[1][2] | G[1][3] + G[1][2] | B[1][3] + B[1][2] | A[0][3] + A[0][2] | R[0][3] + R[0][2] | G[0][3] + G[0][2] | B[0][3] + B[0][2] |
        ;         127                 111                 95                  79                  63                  47                  31                  15                0

        psrldq xmm3, 8 ; shifteo xmm3 8 bytes a la derecha (a la izquierda pone ceros)
        ; xmm3 = |         0         |         0         |         0         |         0         | A[1][3] + A[1][2] | R[1][3] + R[1][2] | G[1][3] + G[1][2] | B[1][3] + B[1][2] |
        ;         127                 111                 95                  79                  63                  47                  31                  15                0

        paddw xmm2, xmm3
        ; xmm2 = | fruta | fruta | fruta | fruta | A[1][3] + A[1][2] + A[0][3] + A[0][2] | R[1][3] + R[1][2] + R[0][3] + R[0][2] | G[1][3] + G[1][2] + G[0][3] + G[0][2] | B[1][3] + B[1][2] + B[0][3] + B[0][2] |
        ;         127                             63                                      47                                      31                                      15                                    0

        psrlw xmm2, 2 ; shifteo xmm2 word a word 2 bits (divido por 2² = 4)
        ; xmm2 = | fruta | fruta | fruta | fruta | (A[1][3] + A[1][2] + A[0][3] + A[0][2]) / 4 | (R[1][3] + R[1][2] + R[0][3] + R[0][2]) / 4 | (G[1][3] + G[1][2] + G[0][3] + G[0][2]) / 4 | (B[1][3] + B[1][2] + B[0][3] + B[0][2]) / 4 |
        ;         127                             63                                            47                                            31                                            15                                          0

        pslldq xmm2, 8 ; shifteo xmm3 8 bytes a la izquierda (a la derecha pone ceros)
        ; xmm2 = | (A[1][3] + A[1][2] + A[0][3] + A[0][2]) / 4 | (R[1][3] + R[1][2] + R[0][3] + R[0][2]) / 4 | (G[1][3] + G[1][2] + G[0][3] + G[0][2]) / 4 | (B[1][3] + B[1][2] + B[0][3] + B[0][2]) / 4 |   0   |   0   |   0   |   0   |
        ;         127                                           111                                           95                                            79                                            63                            0


        ; Combino los dos promedios en un solo registro, así escribo los dos de una (para eso hice todo esto de calcular el segundo promedio...)
        paddw xmm2, xmm4
        ; xmm2 = | (A[1][3] + A[1][2] + A[0][3] + A[0][2]) / 4 | (R[1][3] + R[1][2] + R[0][3] + R[0][2]) / 4 | (G[1][3] + G[1][2] + G[0][3] + G[0][2]) / 4 | (B[1][3] + B[1][2] + B[0][3] + B[0][2]) / 4 |
        ;         127                                           111                                           95                                            79                                         64
        ;        | (A[1][1] + A[1][0] + A[0][1] + A[0][0]) / 4 | (R[1][1] + R[1][0] + R[0][1] + R[0][0]) / 4 | (G[1][1] + G[1][0] + G[0][1] + G[0][0]) / 4 | (B[1][1] + B[1][0] + B[0][1] + B[0][0]) / 4 |
        ;         63                                            47                                            31                                            15                                          0

		; empaqueto de word a byte de nuevo
		pshufb xmm2, xmm13
		
        ; xmm2[7..0] = promedio B pixel izquierdo
        ; xmm2[15..8] = promedio G pixel izquierdo
        ; xmm2[23..16] = promedio R pixel izquierdo
        ; xmm2[31..24] = promedio A pixel izquierdo
        
        ; xmm2[39..32] = promedio B pixel izquierdo
        ; xmm2[47..40] = promedio G pixel izquierdo
        ; xmm2[55..48] = promedio R pixel izquierdo
        ; xmm2[63..56] = promedio A pixel izquierdo
        
        ; xmm2[71..64] = promedio B pixel derecho
        ; xmm2[79..72] = promedio G pixel derecho
        ; xmm2[87..80] = promedio R pixel derecho
        ; xmm2[95..88] = promedio A pixel derecho
        
        ; xmm2[103..96] = promedio B pixel derecho
        ; xmm2[111..104] = promedio G pixel derecho
        ; xmm2[119..112] = promedio R pixel derecho
        ; xmm2[127..120] = promedio A pixel derecho

        movdqu [rsi], xmm2
        movdqu [rsi + r10],xmm2

        add rsi, 16
        add rdi, 16

        sub rcx, 1
        cmp rcx, 0
        jnz .ciclo


    ; reseteo el contador
    mov rcx, r11                            ; rbx = ancho/4

    add rdi, r10                            ; rdi = rdi + ancho*4       LE SUMO ESTO PARA QUE SE SALTEE UNA FILA (YA LA PROCESAMOS)
    add rsi, r10                            ; rsi = rsi + (ancho*4)     LE SUMO ESTO PARA QUE SE SALTEE UNA FILA (YA LA PROCESAMOS)

    sub r9, 2		                          ; LE RESTO AL CONTADOR DE FILAS 2 PORQUE VOY HACIENDO UNA FILA SI UNA NO..
    cmp r9, 0		                          ; SI ES 0 EL CONTADOR TERMINE
    jne .ciclo		                          ; SALTO AL CICLO DE NUEVO

    ret        ; A
