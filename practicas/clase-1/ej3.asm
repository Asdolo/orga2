global _start

section .data
msg: DB 'Hola mundo',10
par1: DQ 123456789ABCDEF0h

extern imprime_parametros
section .text
   _start:
   mov rdi,10
   movq xmm0, [par1]
   mov rsi,msg
   call imprime_parametros
   mov rax,1
   mov rbx,0
   int 0x80