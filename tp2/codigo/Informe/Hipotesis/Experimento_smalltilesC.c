
#include "../tp2.h"

void smalltiles_c (unsigned char *src, unsigned char *dst, int cols, int filas, int src_row_size, int dst_row_size) {

unsigned char *puntero=src;
unsigned char *abajoIzqDes=dst;
unsigned char *abajoDerDes=dst+cols*2;
unsigned char *arribaIzqDes=dst+(cols*4)*(filas/2);
unsigned char *arribaDerDes=arribaIzqDes+cols*2;

	for (int f = 0; f < filas; f+=2) {
		for (int c = 0; c < cols; c+=2) {
			bgra_t *p_s = (bgra_t*) puntero;
			puntero+=8;

//ABAJO A LA IZQUIERDA
			bgra_t *p_d = (bgra_t*) abajoIzqDes;
			p_d->b = p_s->b;
			p_d->g = p_s->g;
			p_d->r = p_s->r;
			p_d->a = p_s->a;
abajoIzqDes+=4;
//ABAJO A LA DERECHA
			p_d = (bgra_t*) abajoDerDes;
			p_d->b = p_s->b;
			p_d->g = p_s->g;
			p_d->r = p_s->r;
			p_d->a = p_s->a;
abajoDerDes+=4;

//ARRIBA A LA IZQUIERDA
			p_d = (bgra_t*) arribaIzqDes;
			p_d->b = p_s->b;
			p_d->g = p_s->g;
			p_d->r = p_s->r;
			p_d->a = p_s->a;
arribaIzqDes+=4;



//ARRIBA A LA DERECHA
			p_d = (bgra_t*) arribaDerDes;
			p_d->b = p_s->b;
			p_d->g = p_s->g;
			p_d->r = p_s->r;
			p_d->a = p_s->a;
			arribaDerDes+=4;

		}

		puntero+=cols*4;
		abajoIzqDes+=cols*2;
		abajoDerDes+=cols*2;
		arribaIzqDes+=cols*2;
		arribaDerDes+=cols*2;

	}



	
	
}
