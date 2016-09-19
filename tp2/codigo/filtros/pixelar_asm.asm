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
    mascaraExtend: db 0x00,0xFF,0x01,0xFF,0x02,0xFF,0x03,0xFF,0x04,0xFF,0x05,0xFF,0x06,0xFF,0x07,0xFF,0x08,0xFF
    mascaraOrdenadora: db 0x00, 0x02, 0x04, 0x06, 0x00, 0x02, 0x04, 0x06, 0x00, 0x02, 0x04, 0x06, 0x00, 0x02, 0x04, 0x06
    mascaraLOCA:       db 0x00, 0x00, 0x08, 0x09, 0x02, 0x03, 0x0a, 0x0b, 0x04, 0x05, 0x0c, 0x0d, 0x06, 0x07, 0x0e, 0x0f
section .text
 
pixelar_asm:
   
    xor r8,r8
    mov r8d,ecx                 ; r8 <- #filas
    xor r9,r9
    mov r9d,edx                 ; r9<- cols
    xor rcx,rcx
    mov ecx,edx                 ;ecx=cols
    shr ecx,1                   ;ecx=cols/2
    mov eax,r8d                 ;eax=filas
    sub eax,1                   ;eax=filas-1
    mul ecx                     ;eax=(cols/2)*(filas-1)
    mov rcx,rax                 ;ecx=(cols/2)*(filas-1)
 
movdqu xmm3,[mascaraExtend]
movdqu xmm4,[mascaraOrdenadora]
movdqu xmm5,[mascaraLOCA]
 
 .ciclo:
   
        movdqu xmm0, [rdi]
        ; xmm0 = |a[0]3 r[0]3 g[0]3 b[0]3 | a[0]2 r[0]2 g[0]2 b[0]2 | a[0]1 r[0]1 g[0]1 b[0]1 | a [0]0 r[0]0 g[0]0 b[0]0|
 
        movdqu xmm1, [rdi+4*r9] ;
        ;xmm1 = |a[1]3 r[1]3 g[1]3 b[1]3 | a[1]2 r[1]2 g[1]2 b[1]2 | a[1]1 r[1]1 g[1]1 b[1]1 | a[1]0 r[1]0 g[1]0 b[1]0|
        pshufb xmm0,xmm3
        ; xmm0=  | 0000 a[0]1 0000 r[0]1| 0000 g[0]1 0 b[0]1 | 0000 a[0]0 0 r[0]0| 0000 g[0]0 0000 b[0]0|
        pshufb xmm1,xmm3
        ; xmm1=   | 0000 a[1]1 0000 r[1]1| 0000 g[1]1 0 b[0]1 | 0000 a[1]0 0 r[1]0| 0000 g[1]0 0000 b[1]0|
        psrlw xmm0,2; REVISAR INSTRUCCION, QUIERO DIVIDIR POR CUATRO XMM0 DE A WORD
        psrlw xmm1,2; REVISAR INSTRUCCION, QUIERO DIVIDIR POR CUATRO XMM0 DE A WORD
 
        paddw xmm0,xmm1
        ;xmm0= | (a[0]1+a[1]1)  (r[0]1+r[1]1)|(g[0]1+g[1]1)  (b[0]1+b[1]1)|| (a[0]0+a[1]0)  (r[0]0+r[1]0)|(g[0]0+g[1]0)  (b[0]0+b[1]0)|
 
       
        pshufb xmm0 ,xmm5
 
        ; xmm0= |0000 (a[0]1+a[1]1)  0000 (a[0]0+a[1]0)|0000 (r[0]1+r[1]1)  0000 (r[0]0+r[1]0)|0000 (g[0]1+g[1]1) 0000 (g[0]0+g[1]0)|0000 (b[0]1+b[1]1) 0000 (b[0]0+b[1]0) |
       
        phaddw xmm0,xmm9
        ;xmm9=basur
        ;xmm0= |basura basura| basura basura|(a[0]1+a[1]1)+(a[0]0+a[1]0)(r[0]1+r[1]1)+(r[0]0+r[1]0)|(g[0]1+g[1]1)+(g[0]0+g[1]0) (b[0]1+b[1]1)+(b[0]0+b[1]0|
       
       
 
        ;xmm0[15..0]=promedioB =0000000 00000001
        ;xmm0[31..16]=promedioG
        ;xmm0[47..32]=promedioR
        ;xmm0[63..48]=promedioA
 
        pshufb xmm0,xmm4 ; |PIXELPROMEDIO|PIXELPROMEDIO|PIXELPROMEDIO|PIXELPROMEDIO|
        movq [rsi],xmm0
        movq [rdx*4+rsi],xmm0
       
        add rsi,8
        add rdi,8
       
        loop .ciclo
 
        ret
