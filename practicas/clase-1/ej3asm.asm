global main
section .data
msg: DB 'Hola mundo',0
par1: DQ 3.2

extern imprime_parametros
section .text
   main:
mov rdi,10
sub rsp,8
movq xmm0, [par1]
mov rsi,msg
mov rax,1
call imprime_parametros
mov rax,1
mov rbx,0
int 0x80