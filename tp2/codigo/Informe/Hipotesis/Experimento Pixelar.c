
#include "../tp2.h"

void pixelar_c (
unsigned char *src,
unsigned char *dst,
int cols,
int filas,
int src_row_size,
int dst_row_size
) {

	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;
unsigned char promedioBlue;
unsigned char promedioGreen;
unsigned char promedioRed;
unsigned char promedioA;
bgra_t *p_d1;
bgra_t *p_d2;
bgra_t *p_d3;
bgra_t *p_d4 ;
bgra_t *p_s1;
bgra_t *p_s2;
bgra_t *p_s3;
bgra_t *p_s4;
	for (int f = 0; f < filas; f+=2) {
		for (int c = 0; c < cols; c+=2) {
			//Agarramos punteros a pixeles del bloque
			p_d1 = (bgra_t*) &dst_matrix[f][c<<2];
			p_d2 = (bgra_t*) &dst_matrix[f][(c+1)<<2];
			p_d3 = (bgra_t*) &dst_matrix[f+1][c<<2];
			p_d4 = (bgra_t*) &dst_matrix[f+1][(c+1)<<2];

			p_s1 = (bgra_t*) &src_matrix[f][c <<2];
			p_s2 = (bgra_t*) &src_matrix[f][(c+1) <<2];
			p_s3 = (bgra_t*) &src_matrix[f+1][c <<2];
			p_s4 = (bgra_t*) &src_matrix[f+1][(c+1)<<2];

			promedioBlue = (p_s1->b + p_s2->b + p_s3-> b + p_s4->b)>>2;
			 promedioGreen = (p_s1->g + p_s2->g + p_s3->g + p_s4->g)>>2;
			 promedioRed = (p_s1->r + p_s2->r + p_s3->r + p_s4->r)>>2;
			 promedioA = (p_s1->a + p_s2->a + p_s3->a + p_s4->a)>>2;

			p_d1->b=promedioBlue;
			p_d1->g=promedioGreen;
			p_d1->r=promedioRed;
			p_d1->a=promedioA;

			p_d2->b=promedioBlue;
			p_d2->g=promedioGreen;
			p_d2->r=promedioRed;
			p_d2->a=promedioA;

			p_d3->b=promedioBlue;
			p_d3->g=promedioGreen;
			p_d3->r=promedioRed;
			p_d3->a=promedioA;

			p_d4->b=promedioBlue;
			p_d4->g=promedioGreen;
			p_d4->r=promedioRed;
			p_d4->a=promedioA;
		}
	}



}
