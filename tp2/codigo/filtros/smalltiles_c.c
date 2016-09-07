
#include "../tp2.h"

void smalltiles_c (unsigned char *src, unsigned char *dst, int cols, int filas, int src_row_size, int dst_row_size) {
	//COMPLETAR
	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;
/*	
EJEMPLO DE COPIA ENTERA DE LA FOTO
// ejemplo de uso de src_matrix y dst_matrix (copia la imagen)
	for (int f = 0; f < filas; f++) {
		for (int c = 0; c < cols; c++) {
			bgra_t *p_d = (bgra_t*) &dst_matrix[f][c * 4];
            bgra_t *p_s = (bgra_t*) &src_matrix[f][c * 4];

			p_d->b = p_s->b;
			p_d->g = p_s->g;
			p_d->r = p_s->r;
			p_d->a = p_s->a;

		}
	}
*/

	for (int f = 0; f < filas; f+=2) {
		for (int c = 0; c < cols; c+=2) {
			bgra_t *p_s = (bgra_t*) &src_matrix[f][c * 4];

//ABAJO A LA IZQUIERDA
			bgra_t *p_d = (bgra_t*) &dst_matrix[f/2][(c * 4)/2];
			p_d->b = p_s->b;
			p_d->g = p_s->g;
			p_d->r = p_s->r;
			p_d->a = p_s->a;

//ABAJO A LA DERECHA
			p_d = (bgra_t*) &dst_matrix[f/2][((c * 4)/2) + (cols*4)/2];
			p_d->b = p_s->b;
			p_d->g = p_s->g;
			p_d->r = p_s->r;
			p_d->a = p_s->a;

//ARRIBA A LA IZQUIERDA
			p_d = (bgra_t*) &dst_matrix[(f/2)+(filas/2)][(c * 4)/2];
			p_d->b = p_s->b;
			p_d->g = p_s->g;
			p_d->r = p_s->r;
			p_d->a = p_s->a;



//ARRIBA A LA DERECHA
			p_d = (bgra_t*) &dst_matrix[(f/2)+(filas/2)][((c * 4)/2) + (cols*4)/2];
			p_d->b = p_s->b;
			p_d->g = p_s->g;
			p_d->r = p_s->r;
			p_d->a = p_s->a;
		}
	}



	
	
}
