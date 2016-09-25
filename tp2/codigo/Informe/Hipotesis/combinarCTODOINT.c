#include "../tp2.h"

float clamp(float pixel)
{
	float res = pixel < 0.0 ? 0.0 : pixel;
	return res > 255.0 ? 255 : res;
}




unsigned char formula (int alpha, unsigned char colorOrig, unsigned char colorEspej )
{
	
	int b = (((colorOrig - colorEspej) * alpha)>>8) + colorEspej;

	return (unsigned char) b;
}


void combinar_c (
	unsigned char *src, 
	unsigned char *dst, 
	int cols, 
	int filas, 
	int src_row_size,
	int dst_row_size,
	float alpha)
{
	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;
int alphaInt=(int) alpha;

//CREO EN DESTINO LA FOTO ESPEJADA
for (int f = 0; f < filas; f++) {
		for (int c = 0; c < cols; c++) {
			bgra_t *p_s = (bgra_t*) &src_matrix[f][c * 4];
			bgra_t *p_d = (bgra_t*) &dst_matrix[f][((cols - c) - 1) * 4];

            		p_d->g = p_s->g;
			p_d->r = p_s->r;
			p_d->b = p_s->b;
			p_d->a = p_s->a;


		}
	}


//CREO EN DESTINO EL DESTINO :P
for (int f = 0; f < filas; f++) {
		for (int c = 0; c < cols; c++) {
			bgra_t *p_s = (bgra_t*) &src_matrix[f][c * 4];
			bgra_t *p_d = (bgra_t*) &dst_matrix[f][c * 4];

            		
			p_d->g = formula(alphaInt, p_s->g, p_d->g);
			p_d->r = formula(alphaInt, p_s->r, p_d->r);
			p_d->b = formula(alphaInt, p_s->b, p_d->b);
			p_d->a = formula(alphaInt, p_s->a, p_d->a);

		}
	}
	
}
