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
 
section .text

; =====================================
; void ct_new(ctTree** pct);
ct_new:
        ret

; =====================================
; void ct_delete(ctTree** pct);
ct_delete:
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



