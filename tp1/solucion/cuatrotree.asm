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
  push RBP
  mov RBP, RSP
  sub RSP, 8  ; alineo la pila
  push RBX
  push R12
  push R13
  push R14
  push R15

  ; Me llega una dirección en RDI (&miPuntero).
  ; La dirección tiene 8 bytes.
  mov RBX, RDI ; RBX <- RDI

  ; Voy a llamar a malloc, así que le seteo en RDI
  ; (primer parámetro) el tamaño de mi struct
  mov RDI, size_cttree ; RDI <- size_cttree
  call malloc
  ; si malloc respetó la convención c, no debería haber
  ; tocado mi preciado RBX...

  ; Malloc devuelve una direccion en RAX, donde
  ; me liberó 12 bytes para mi struct
  mov qword [RAX + offset_cttree_root_pointer], NULL
  mov dword [RAX + offset_cttree_size], 0

  ; [&miPuntero] <- RAX
  mov [RBX], RAX

  ;desarmo el stackframe
  pop R15
  pop R14
  pop R13
  pop R12
  pop RBX
  add RSP, 8  ; desalineo la pila
  pop RBP
  ret

; =====================================
; void ct_delete(ctTree** pct);
ct_delete:


  push RBP
  mov RBP, RSP
  sub RSP, 8  ; alineo la pila
  push RBX
  ; Me llega una dirección en RDI (&miPuntero).
  ; La dirección tiene 8 bytes.
  mov RBX, [RDI] ; RBX <- [RDI] (guardé en RBX la dirección donde empieza el struct)

  ; Duda: es muy turbia la línea de arriba? Si en RDI hay una dirección que
  ; no tengo acceso, explotaría. Pero cómo se si tengo acceso?
  mov qword [RDI], NULL ; te pongo un NULL para que sepas que se eliminó
  ; Duda: está bien la línea de arriba?

  ; Veo si el struct no tiene nodos
  cmp qword [RBX + offset_cttree_root_pointer], NULL
  jz borrar_struct; el nodo root es null, libero el espacio del struct y listo
  ; tiene nodo root

  ; Paso a RDI la dirección del root
  mov RDI, [RBX + offset_cttree_root_pointer]
  call nodo_delete

  ; Terminé de borrar los nodos, libero el espacio del struct y listo

  ; TODO: Ver el caso que el struct tenga nodos
  borrar_struct:
  mov RDI, RBX ; le paso a free la dirección donde empieza el struct
  call free

  pop RBX
  add RSP, 8
  pop RBP
  ret

; aux void nodo_delete(ctNodo *pcn);
nodo_delete:
  push RBP
  mov RBP, RSP
  sub RSP, 8  ; alineo la pila
  push RBX
  push R12
  push R13
  push R14
  push R15

  mov RBX, RDI

  ; Veo si el nodo actual es null
  cmp RBX, NULL
  jz fin_nodo_delete
  ; Es un nodo válido

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
  pop R15
  pop R14
  pop R13
  pop R12
  pop RBX
  add RSP, 8  ; desalineo la pila
  pop RBP
  ret


; ; =====================================
; ; void ct_aux_print(ctNode* node);
ct_aux_print:
        ret

; ; =====================================
; ; void ct_print(ctTree* ct);
ct_print:
        ret

; =====================================
; ctIter* ctIter_new(ctTree* ct);
ctIter_new:
        ret

; =====================================
; void ctIter_delete(ctIter* ctIt);
ctIter_delete:
        ret

; =====================================
; void ctIter_first(ctIter* ctIt);
ctIter_first:
        ret

; =====================================
; void ctIter_next(ctIter* ctIt);
ctIter_next:
        ret

; =====================================
; uint32_t ctIter_get(ctIter* ctIt);
ctIter_get:
        ret

; =====================================
; uint32_t ctIter_valid(ctIter* ctIt);
ctIter_valid:
        ret
