; FUNCIONES de C
  extern malloc
  extern free
  extern fprintf

; FUNCIONES
  global ct_new
  global ct_delete
  global ct_print
  global ctIter_new
  global ctIter_delete
  global ctIter_first
  global ctIter_next
  global ctIter_get
  global ctIter_valid

section .data

  str_print:  DB '%d', 10, 0

  ; Constantes
  %define NULL 0

  ; Sizes
  %define size_cttree 12
  %define size_ctnode 53
  %define size_ctiter 21
  %define size_int32 4
  %define size_int8 1
  %define size_pointer 8

  ; Offsets de struct ctTree
  %define offset_cttree_root_pointer 0
  %define offset_cttree_size 8

  ; Offsets de struct ctNode
  %define offset_ctnode_father_pointer 0
  %define offset_ctnode_value_0 8
  %define offset_ctnode_value_1 12
  %define offset_ctnode_value_2 16
  %define offset_ctnode_len 20
  %define offset_ctnode_child_pointer_0 21
  %define offset_ctnode_child_pointer_1 29
  %define offset_ctnode_child_pointer_2 37
  %define offset_ctnode_child_pointer_3 45

  ; Offsets de struct ctIter
  %define offset_ctiter_tree_pointer 0
  %define offset_ctiter_node_pointer 8
  %define offset_ctiter_current 16
  %define offset_ctiter_count 17

section .text

; =====================================
; void ct_new(ctTree** pct);
ct_new:

  ; armo el stackframe
  push RBP        ; A
  mov RBP, RSP
  push RBX        ; D
  push R12        ; A

  ; Me llega una dirección en RDI (&miPuntero).
  ; La dirección tiene 8 bytes.
  mov RBX, RDI ; RBX <- RDI

  mov RDI, 0xffffffffeeeeeeee
  ; Voy a llamar a malloc, así que le seteo en RDI
  ; (primer parámetro) el tamaño de mi struct
  mov RDI, size_cttree ; RDI <- size_cttree
  call malloc
  ; si malloc respetó la convención c, no debería haber tocado RBX...

  mov R12, RAX ; R12 <- RAX (tengo en R12 la direccion donde empieza el Tree)

  ; Voy a llamar a malloc, así que le seteo en RDI
  ; (primer parámetro) el tamaño de un nodo (nodo vacío)
  mov RDI, size_ctnode ; RDI <- size_ctnode
  call malloc
  ; si malloc respetó la convención c, no debería haber
  ; tocado mis preciados RBX y R12...

  ; Estado actual:
  ; RBX = parámetro de entrada = &miPuntero
  ; R12 = dirección donde empieza el struct del Tree
  ; RAX = dirección donde empieza mi nodo vacío (recién retornada por el último malloc)

  ; Seteo el nodo:
  mov qword [RAX + offset_ctnode_father_pointer], NULL
  mov dword [RAX + offset_ctnode_value_0], 0
  mov dword [RAX + offset_ctnode_value_1], 0
  mov dword [RAX + offset_ctnode_value_2], 0
  mov byte [RAX + offset_ctnode_len], 0
  mov qword [RAX + offset_ctnode_child_pointer_0], NULL
  mov qword [RAX + offset_ctnode_child_pointer_1], NULL
  mov qword [RAX + offset_ctnode_child_pointer_2], NULL
  mov qword [RAX + offset_ctnode_child_pointer_3], NULL

  ; Seteo el struct del Tree
  mov qword [R12 + offset_cttree_root_pointer], RAX
  mov dword [R12 + offset_cttree_size], 0

  ; [&miPuntero] <- R12
  mov [RBX], R12

  ;desarmo el stackframe
  pop R12
  pop RBX
  pop RBP
  ret

; =====================================
; void ct_delete(ctTree** pct);
ct_delete:

  push RBP        ; A
  mov RBP, RSP
  sub RSP, 8      ; D
  push RBX        ; A

  ; Me llega una dirección en RDI (&miPuntero).
  ; La dirección tiene 8 bytes.
  mov RBX, [RDI] ; RBX <- [RDI] (guardé en RBX la dirección donde empieza el struct)

  ; Duda: es muy turbia la línea de arriba? Si en RDI hay una dirección que
  ; no tengo acceso, explotaría. Pero cómo se si tengo acceso?
  mov qword [RDI], NULL ; te pongo un NULL para que sepas que se eliminó
  ; Duda: está bien la línea de arriba?

  ; Paso a RDI la dirección del root
  mov RDI, [RBX + offset_cttree_root_pointer]
  call nodo_delete

  ; Terminé de borrar los nodos, libero el espacio del struct y listo
  mov RDI, RBX ; le paso a free la dirección donde empieza el struct
  call free

  pop RBX
  add RSP, 8
  pop RBP
  ret

; aux void nodo_delete(ctNodo *pcn);
nodo_delete:
  push RBP        ; A
  mov RBP, RSP
  sub RSP, 8      ; D
  push RBX        ; A

  mov RBX, RDI
  ; Veo si el nodo actual es null
  cmp RBX, NULL
  jz fin_nodo_delete
  ; Es un nodo válido

  ;Elimino los 4 hijos
  mov RDI, [RBX + offset_ctnode_child_pointer_0]
  call nodo_delete
  mov RDI, [RBX + offset_ctnode_child_pointer_1]
  call nodo_delete
  mov RDI, [RBX + offset_ctnode_child_pointer_2]
  call nodo_delete
  mov RDI, [RBX + offset_ctnode_child_pointer_3]
  call nodo_delete

  ; Terminé!
  ; Me libero a mi mismo (no soy null)
  mov RDI, RBX
  call free

fin_nodo_delete:
  pop RBX
  add RSP, 8  ; desalineo la pila
  pop RBP
  ret


; ; =====================================
; ; void ct_aux_print(ctNode* node, FILE *pFile);
ct_aux_print:
  push RBP        ; A
  mov RBP, RSP
  push RBX        ; D
  push R12        ; A

  mov RBX, RDI ; Me guardo el parámetro 1 (dirección del nodo actual)
  mov R12, RSI ; Me guardo el parámetro 2 (dirección del archivo)

  cmp RBX, NULL
  jz fin_ct_aux_print

  ; Es un nodo válido

  ; Veo si tiene elementos
  cmp byte [RBX + offset_ctnode_len], 0
  jz fin_ct_aux_print ; Si no tiene, no hay nada que imprimir en este nodo => salgo

  ; Es un nodo con elementos (el único nodo que no tiene elementos es
  ; un nodo root de un ctTree recién creado)

  ; Ok, tiene elementos (por lo menos uno).
  ; Luego vemos cuántos exactamente, pero si estoy acá
  ; es seguro que tengo algo en value[0], y además, puedo imprimir los nodos
  ; child[0] y child[1] (todo en su correspondiente orden). Recordar que este
  ; auxiliar recursivo se fija al principio si el nodo es null o no...
  ; Hagamos eso!!
  ; fprintf(pFile,"%d\n", valor);

  ; Imprimo el nodo child[0]
  mov RDI, [RBX + offset_ctnode_child_pointer_0] ; parámetro 1 = dirección del nodo
  mov RSI, R12, ; parámetro 2 = dirección del archivo
  call ct_aux_print

  ; Imprimo value[0] (primer elemento)
  mov RDI, R12 ; parámetro 1 = Dirección del archivo
  mov RSI, str_print ; parámetro 2 = string (puntero char[]*) con el formato a imprimir
  mov EDX, [RBX + offset_ctnode_value_0] ; parámetro 3 = valor int a imprimir
  call fprintf

  ; Imprimo el nodo child[1]
  mov RDI, [RBX + offset_ctnode_child_pointer_1] ; parámetro 1 = dirección del nodo
  mov RSI, R12, ; parámetro 2 = dirección del archivo
  call ct_aux_print

  ; Ahora sí, veamos si hay un segundo elemento
  cmp byte [RBX + offset_ctnode_len], 2
  jl fin_ct_aux_print ; Si tiene menos de dos elementos (uno), listo, ya los habíamos impreso, vámonos

  ; Tiene un segundo elemento (o 3, vemos después)
  ; Imprimo value[1] (segundo elemento)
  mov RDI, R12 ; parámetro 1 = Dirección del archivo
  mov RSI, str_print ; parámetro 2 = string (puntero char[]*) con el formato a imprimir
  mov EDX, [RBX + offset_ctnode_value_1] ; parámetro 3 = valor int a imprimir
  call fprintf

  ; Imprimo el nodo child[2]
  mov RDI, [RBX + offset_ctnode_child_pointer_2] ; parámetro 1 = dirección del nodo
  mov RSI, R12, ; parámetro 2 = dirección del archivo
  call ct_aux_print

  ; Por último, veamos si hay un tercer elemento
  cmp byte [RBX + offset_ctnode_len], 3
  jl fin_ct_aux_print ; Si tiene menos de tres elementos, listo, ya los habíamos impreso, vámonos

  ; Tiene un tercer elemento
  ; Imprimo value[2] (tercer elemento)
  mov RDI, R12 ; parámetro 1 = Dirección del archivo
  mov RSI, str_print ; parámetro 2 = string(puntero char[]*) con el formato a imprimir
  mov EDX, [RBX + offset_ctnode_value_2] ; parámetro 3 = valor int a imprimir
  call fprintf
  ; Imprimo el nodo child[3]
  mov RDI, [RBX + offset_ctnode_child_pointer_3] ; parámetro 1 = dirección del nodo
  mov RSI, R12, ; parámetro 2 = dirección del archivo
  call ct_aux_print

fin_ct_aux_print:

  pop R12
  pop RBX
  pop RBP
  ret

; ; =====================================
; ; void ct_print(ctTree* ct,FILE *pFile);
ct_print:
  push RBP        ; A
  mov RBP, RSP
  push RBX        ; D
  push R12        ; A

  mov RBX, RDI ; Me guardo el parámetro 1 (dirección del struct)
  mov R12, RSI ; Me guardo el parámetro 2 (dirección del archivo)

  mov RDI, [RBX + offset_cttree_root_pointer]
  mov RSI, R12 ; No hace falta pero bue
  call ct_aux_print

  pop R12
  pop RBX
  pop RBP
  ret

; =====================================
; ctIter* ctIter_new(ctTree* ct);
ctIter_new:

  ; armo el stackframe
  push RBP        ; A
  mov RBP, RSP
  sub RSP, 8      ; D
  push RBX        ; A

  ; Me llega una dirección en RDI
  mov RBX, RDI ; RBX <- RDI

  ; Voy a llamar a malloc, así que le seteo en RDI
  ; (primer parámetro) el tamaño de mi struct
  mov RDI, size_ctiter ; RDI <- size_ctiter
  call malloc
  ; si malloc respetó la convención c, no debería haber tocado RBX...
  ; mov R12, RAX ; R12 <- RAX (tengo en R12 la direccion donde empieza el Iter)

  ; Seteo el struct del Tree
  mov qword [RAX + offset_ctiter_tree_pointer], RBX
  mov qword [RAX + offset_ctiter_node_pointer], NULL
  mov byte [RAX + offset_ctiter_current], 0
  mov dword [RAX + offset_ctiter_count], 0

  ;desarmo el stackframe
  pop RBX
  add RSP, 8
  pop RBP
  ret

; =====================================
; void ctIter_delete(ctIter* ctIt);
ctIter_delete:
  ; Aprovecho que me llega el puntero al iterador por RDI y se lo mando a free
  call free
  ret

; =====================================
; void ctIter_first(ctIter* ctIt);
ctIter_first:
  push RBP        ; A
  mov RBP, RSP
  push RBX        ; D
  push R12        ; A
  ; Me llega en RDI la dirección donde empieza mi iterador
  mov RBX, RDI

  ; Primero me fijo si el árbol tiene elementos
  mov R12, [RBX + offset_ctiter_tree_pointer]
  cmp dword [R12 + offset_cttree_size], 0
  jz fin_ctIter_first

  ; Tengo elementos
  ; El elemento más pequeño sí o sí va a estar en value[0] de un nodo,
  ; así que seteo current en 0
  mov byte [RBX + offset_ctiter_current], 0

  ; Pongo count en 1 (según el ejemplo en el PDF esto está bien)
  mov dword [RBX + offset_ctiter_count], 1

  ; Ahora busco el nodo con el elemento menor
  mov RDI, [R12 + offset_cttree_root_pointer] ; Puse en RDI el puntero al nodo root del árbol
  call aux_min_nodo
  ; La función aux_min_nodo me devuelve el puntero al nodo con el mínimo elemento

  mov [RBX + offset_ctiter_node_pointer], RAX

fin_ctIter_first:

  pop R12
  pop RBX
  pop RBP
  ret

; ; ctNode* aux_min_nodo(ctNode* node);

aux_min_nodo:
  push RBP        ; A
  mov RBP, RSP
  push RBX        ; D
  push R12        ; A

  mov RBX, RDI
  mov RAX, RDI ; Pongo el valor a retornar en RAX (en principio podría ser el nodo actual)

  ; Me fijo si tengo algo en child[0]
  mov R12, [RBX + offset_ctnode_child_pointer_0]
  cmp R12, NULL
  jz fin_aux_min_nodo

  ; Tengo un hijo ahi, bajo llamándome a mi misma con ése hijo
  mov RDI, R12
  call aux_min_nodo

  ; Ahora tengo en RAX el verdadero nodo (si es que entré a la recursión)

fin_aux_min_nodo:

  pop R12
  pop RBX
  pop RBP
  ret ; Retorno RAX

; =====================================
; void ctIter_next(ctIter* ctIt);
ctIter_next:
  push RBP        ; A
  mov RBP, RSP
  push RBX        ; D
  push R12        ; A
  push R13        ; D
  push R14        ; A

  mov RBX, RDI ; Pongo el RBX la dirección del iter
  mov R14, [RBX + offset_ctiter_node_pointer] ; Pongo el R14 la dirección del nodo actual

  mov R12, [RBX + offset_ctiter_tree_pointer]
  mov R12D, [R12 + offset_cttree_size]
  cmp R12D, [RBX + offset_ctiter_count]
  jg iter_ok_ctIter_next ; si llegué al final y hago next, lo invalido
  mov qword [RBX + offset_ctiter_node_pointer], NULL
  jmp fin_ctIter_next

iter_ok_ctIter_next:

  inc dword [RBX + offset_ctiter_count] ; Incremento el contador

  inc byte [RBX + offset_ctiter_current] ; Incremento al siguiente elemento
  xor R12, R12
  mov R12B, [RBX + offset_ctiter_current] ; Pongo en R12 el current

  add R14, offset_ctnode_child_pointer_0 ; Ahora tengo en R14 la dirección de la propiedad child[0]
  ; Si el hijo no existe, entones sigo en el mismo nodo
  cmp qword [R14 + R12*8], NULL ; (pongo 8 porque el un puntero ocupa 8 bytes)
  jnz hay_hijos_ctIter_next
  ; si recorri todos los elementos del nodo subo
  mov R13, [RBX + offset_ctiter_node_pointer]
  cmp [R13 + offset_ctnode_len], R12B
  jg  fin_ctIter_next

  call ctIter_aux_up
  jmp fin_ctIter_next

hay_hijos_ctIter_next:

  ; asigno un nuevo nodo en el iterador
  mov R13, [R14 + R12*8]
  mov [RBX + offset_ctiter_node_pointer], R13
  ; bajo hasta encontrar el menor del subarbol
  mov RDI, R13 ; Puse en RDI el puntero al nodo donde quiero empezar a buscar
  call aux_min_nodo
  ; La función aux_min_nodo me devuelve el puntero al nodo con el mínimo elemento
  mov [RBX + offset_ctiter_node_pointer], RAX
  ; pongo el current en 0 (siempre va a pasar así)
  mov byte [RBX + offset_ctiter_current], 0

fin_ctIter_next:

  pop R14
  pop R13
  pop R12
  pop RBX
  pop RBP
  ret

; =====================================
; uint32_t ctIter_aux_up(ctIter* ctIt);
ctIter_aux_up:
  push RBP        ; A
  mov RBP, RSP
  push RBX        ; D
  push R12        ; A
  push R13        ; D
  push R14        ; A

  mov RBX, RDI
  ; Obtengo el puntero actual
  mov R12, [RBX + offset_ctiter_node_pointer]
  ; Obtengo el padre del nodo actual
  mov R13, [R12 + offset_ctnode_father_pointer]

  mov RDI, R12
  mov RSI, R13
  call ctIter_aux_isIn

  ; seteo el nodo actual del iterador al father
  mov [RBX + offset_ctiter_node_pointer], R13

  ; seteo el current del iterador a lo que me devolvió el aux
  mov [RBX + offset_ctiter_current], AL
  cmp EAX, 3
  jne fin_ctIter_aux_up
  ; Si el aux devolvió 3, sigo subiendo
  mov RDI, RBX
  call ctIter_aux_up

fin_ctIter_aux_up:

  pop R14
  pop R13
  pop R12
  pop RBX
  pop RBP
  ret
; =====================================

; =====================================
; uint32_t ctIter_aux_isIn(ctNode* current, ctNode* father);
ctIter_aux_isIn:
  mov R10D, [RDI + offset_ctnode_value_0] ; Pongo en R10D el value[0] de current

  cmp [RSI + offset_ctnode_value_0], R10D ; comparo current.value[0] con father.value[0]
  jl else1_ctIter_aux_isIn
  ; current.value[0] < father.value[0]
  mov EAX, 0
  jmp fin_ctIter_aux_isIn

else1_ctIter_aux_isIn:
  cmp [RSI + offset_ctnode_value_1], R10D ; comparo current.value[0] con father.value[1]
  jl else2_ctIter_aux_isIn
  ; current.value[0] < father.value[1]
  mov EAX, 1
  jmp fin_ctIter_aux_isIn

else2_ctIter_aux_isIn:
  cmp [RSI + offset_ctnode_value_2], R10D ; comparo current.value[0] con father.value[2]
  jl else3_ctIter_aux_isIn
  ; current.value[0] < father.value[2]
  mov EAX, 2
  jmp fin_ctIter_aux_isIn

else3_ctIter_aux_isIn:
  mov EAX, 3

fin_ctIter_aux_isIn:
  ret
; =====================================

; =====================================
; uint32_t ctIter_get(ctIter* ctIt);
ctIter_get:
  mov R8, [RDI + offset_ctiter_node_pointer] ; Pongo en R8 la dirección del nodo
  add R8, offset_ctnode_value_0 ; Le sumo a R8 el offset de value[0], así que ahora R8 apunta a value[0]
  mov R9B, [RDI + offset_ctiter_current] ; Pongo el R9 el current del iterador
  mov EAX, [R8 + R9*4] ; Eso (pongo 4 porque el uint32_t ocupa 4 bytes)
  ret

; =====================================
; uint32_t ctIter_valid(ctIter* ctIt);
ctIter_valid:
  mov EAX, 0
  cmp qword [RDI + offset_ctiter_node_pointer], NULL
  jz ctIter_valid_fin
  mov EAX, 1
ctIter_valid_fin:
  ret
