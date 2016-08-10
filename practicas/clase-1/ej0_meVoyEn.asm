section .data
   
   msg:  DB 'Me voy en ','9', 10
   largo EQU $ - msg
   nro EQU $ - 2
   
   
global _start
section .text
   _start:
   mov rax, 4     ; funcion 4
   mov rbx, 1     ; stdout
   mov rcx, msg   ; mensaje
   mov rdx, largo ; longitud
   int 0x80
   mov AL,[nro]
   sub AL,1
   mov [nro],AL
   cmp AL,'0'
   jnz _start 
   mov rax, 1
   mov rbx, 0
   int 0x80





