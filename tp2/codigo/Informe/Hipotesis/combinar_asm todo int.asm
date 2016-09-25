global combinar_asm
 
section .rodata
 
mascInversa:      db 0x0c,0x0d,0x0e,0x0f,0x08,0x09,0x0a,0x0b,0x04,0x05,0x06,0x07,0x00,0x01,0x02,0x03
numero255: dd 255.0,255.0,255.0,255.0
numeroMenos1: dd -1,-1,-1,-1
 
; void combinar_asm    (unsigned char *src, unsigned char *dst, int cols, int filas,
;                     int src_row_size, int dst_row_size,float alpha);
; Parámetros:
;   rdi = src
;   rsi = dst
;   rdx = cols
;   rcx = filas
;   r8 = src_row_size
;   r9 = dst_row_size
;   xmm0 = alpha
 
section .text
 
combinar_asm:
  push rbp ;A
  mov rbp,rsp
  push r10;D
  push r11;A
  push r12;D
  push r13;A
  push r15;D
  sub rsp,8;A
 
 
mov r10,rdi
mov r11,rsi
mov r13,rcx ; r13=filas
xor r12,r12
mov r12d,edx
shl r12,2 ; r12=cols*4
add r11,r12;
 
xor rcx,rcx
xor r12,r12
mov r12d,edx
shr r12,2 ; r12=cols/4
mov ecx,r12d
;     ------------
;     ------------
;     ------------
;     ------------
;  r10^       r11^
 
 
  movdqu xmm5,[mascInversa]
  mov r15,r13
  .ciclo:
    sub r11,16
    movdqu xmm1,[r10]
    pshufb xmm1,xmm5
    movdqu [r11],xmm1
    add r10,16
    loop .ciclo
mov r12d,edx
shl r12,2 ; r12=cols*4
add r11,r12;
add r11,r12;
 
xor rcx,rcx
xor r12,r12
mov r12d,edx
shr r12,2 ; r12=cols/4
mov ecx,r12d
 
sub r15,1
 
cmp r15,0
jne .ciclo
 
 
;TENGO EN DESTINO LA FOTO ESPEJADA
;TENGO EN XMM0 ALPHA(FLOAT 4BYTES)
movups xmm1,xmm0
shufps xmm0,xmm1,0x00 ; xmm0=|alpha|alpha|alpha|alpha|
movups xmm15,xmm0
CVTPS2DQ xmm15,xmm15; xmm15=ALPHA ALPHA ALPHA ALPHA TODO INT
 pxor xmm13,xmm13
movups xmm8,[numero255] ; xmm8=|255.0|255.0|255.0|255.0
divps xmm0,xmm8         ;xmm0=|alpha/255.0|alpha/255.0|alpha/255.0|alpha/255.0|
 movdqu xmm14,[numeroMenos1]
xor rcx,rcx
mov r10d,edx
shr r10d,2 ; r10=ancho/4
mov r11d,r13d; r11=filas
 
mov eax,r13d
mul r10d
mov ecx,eax
;ecx=(ancho/4)*(filas)




.ciclo2:
 
;AGARRO FOTO ORIGINAL
  movdqu xmm1,[rdi] ;xmm1=|pixel3|pixel2|pixel1|pixel0
 
movdqu xmm3,xmm1
;CONVIERTO BYTES A WORDS FOTO ORIGINAL
punpcklbw xmm1,xmm13;xmm1=| sa1  sg1 |  sr1  sb1| sa0  sg0 |  sr0  sb0| s=source
punpckhbw xmm3,xmm13;xmm2=| sa3  sg3 |  sr3  sb3| sa2  sg2 |  sr2  sb2|
 
;final = 76543210
;xmm1=1-0
;xmm3=3-2
 
;CONVIERTO WORDS A 32 BITS INT
movdqu xmm2,xmm1
punpcklwd xmm1,xmm13
punpckhwd xmm2,xmm13
;xmm1=0
;xmm2=1
;xmm3=3-2
 
movdqu xmm4,xmm3
punpcklwd xmm3,xmm13
punpckhwd xmm4,xmm13
 
;xmm1=0
;xmm2=1
;xmm3=2
;xmm4=3
 
 
 ;AGARRO FOTO ESPEJADA
  movdqu xmm5,[rsi]
  movdqu xmm7,xmm5
 ;CONVIERTO BYTES A WORDS FOTO ESPEJADA
punpcklbw xmm5,xmm13
punpckhbw xmm7,xmm13
 
;xmm5=1-0
;xmm7=3-2
 
;CONVIERTO WORDS A 32 BITS INT
movdqu xmm6,xmm5
punpcklwd xmm5,xmm13
punpckhwd xmm6,xmm13
;xmm5=0
;xmm6=1
;xmm7=3-2
 
movdqu xmm8,xmm7
punpcklwd xmm7,xmm13
punpckhwd xmm8,xmm13
 
;xmm5=0
;xmm6=1
;xmm7=2
;xmm8=3
 
 
;Hago la resta de int 32 bits
 
psubd xmm1,xmm5
psubd xmm2,xmm6
psubd xmm3,xmm7
psubd xmm4,xmm8

pmulld xmm1,xmm15
pmulld xmm2,xmm15
pmulld xmm3,xmm15
pmulld xmm4,xmm15
PSRAW xmm1,8
PSRAW xmm2,8
PSRAW xmm3,8
PSRAW xmm4,8

;Le sumo la espejada
 
paddd xmm1,xmm5
paddd xmm2,xmm6
paddd xmm3,xmm7
paddd xmm4,xmm8
 
;CONVIERTO DE INT 32 A SHORT
 
packusdw xmm1,xmm2
packusdw xmm3,xmm4
 
;CONVIERTO A BYTE
 
PACKUSWB xmm1,xmm3
 
  movdqu [rsi],xmm1
  add rdi,16
  add rsi,16
 
  DEC ECX
  JNZ .ciclo2
 
add rsp,8;D
pop r15;A
pop r13;D
pop r12;A
pop r11;D
pop r10;A
pop rbp;d
ret;a


