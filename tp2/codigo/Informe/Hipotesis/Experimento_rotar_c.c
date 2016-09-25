
#include "../tp2.h"

void rotar_c (unsigned char *src, unsigned char *dst, int cols, int filas, int src_row_size, int dst_row_size) {
	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;

	for (int f = 0; f < filas; f++) {
		for (int c = 0; c < cols; c+=64) {
			bgra_t *p_d = (bgra_t*) &dst_matrix[f][c * 4];
            bgra_t *p_s = (bgra_t*) &src_matrix[f][c * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+1) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+1) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;



			p_d = (bgra_t*) &dst_matrix[f][(c+2) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+2) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+3) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+3) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;




			p_d = (bgra_t*) &dst_matrix[f][(c+4) * 4];
           	p_s = (bgra_t*) &src_matrix[f][(c+4) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+5) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+5) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;



			p_d = (bgra_t*) &dst_matrix[f][(c+6) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+6) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+7) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+7) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;










			p_d = (bgra_t*) &dst_matrix[f][(c+8) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+8) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+9) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+9) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;



			p_d = (bgra_t*) &dst_matrix[f][(c+10) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+10) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+11) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+11) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;




			p_d = (bgra_t*) &dst_matrix[f][(c+12) * 4];
           	p_s = (bgra_t*) &src_matrix[f][(c+12) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+13) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+13) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;



			p_d = (bgra_t*) &dst_matrix[f][(c+14) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+14) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+15) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+15) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;


			p_d = (bgra_t*) &dst_matrix[f][(c+16) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+16) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+17) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+17) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;



			p_d = (bgra_t*) &dst_matrix[f][(c+18) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+18) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 

			p_d = (bgra_t*) &dst_matrix[f][(c+19) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+19) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+20) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+20) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;




			p_d = (bgra_t*) &dst_matrix[f][(c+21) * 4];
           	p_s = (bgra_t*) &src_matrix[f][(c+21) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+22) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+22) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;



			p_d = (bgra_t*) &dst_matrix[f][(c+23) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+23) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+24) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+24) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;










			p_d = (bgra_t*) &dst_matrix[f][(c+25) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+25) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+26) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+26) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;



			p_d = (bgra_t*) &dst_matrix[f][(c+27) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+27) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+28) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+28) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;




			p_d = (bgra_t*) &dst_matrix[f][(c+29) * 4];
           	p_s = (bgra_t*) &src_matrix[f][(c+29) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+30) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+30) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;



			p_d = (bgra_t*) &dst_matrix[f][(c+31) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+31) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


p_d = (bgra_t*) &dst_matrix[f][(c+32) * 4];
p_s = (bgra_t*) &src_matrix[f][(c+32) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+33) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+33) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;



			p_d = (bgra_t*) &dst_matrix[f][(c+34) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+34) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+35) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+35) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;




			p_d = (bgra_t*) &dst_matrix[f][(c+36) * 4];
           	p_s = (bgra_t*) &src_matrix[f][(c+36) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+37) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+37) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;



			p_d = (bgra_t*) &dst_matrix[f][(c+38) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+38) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+39) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+39) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;










			p_d = (bgra_t*) &dst_matrix[f][(c+40) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+40) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+41) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+41) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;



			p_d = (bgra_t*) &dst_matrix[f][(c+42) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+42) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+43) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+43) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;




			p_d = (bgra_t*) &dst_matrix[f][(c+44) * 4];
           	p_s = (bgra_t*) &src_matrix[f][(c+44) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+45) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+45) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;



			p_d = (bgra_t*) &dst_matrix[f][(c+46) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+46) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+47) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+47) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;


			p_d = (bgra_t*) &dst_matrix[f][(c+48) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+48) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+49) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+49) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;



			p_d = (bgra_t*) &dst_matrix[f][(c+50) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+50) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 

			p_d = (bgra_t*) &dst_matrix[f][(c+51) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+51) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+52) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+52) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;




			p_d = (bgra_t*) &dst_matrix[f][(c+53) * 4];
           	p_s = (bgra_t*) &src_matrix[f][(c+53) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+54) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+54) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;



			p_d = (bgra_t*) &dst_matrix[f][(c+55) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+55) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+56) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+56) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;










			p_d = (bgra_t*) &dst_matrix[f][(c+57) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+57) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+58) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+58) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;



			p_d = (bgra_t*) &dst_matrix[f][(c+59) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+59) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+60) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+60) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;




			p_d = (bgra_t*) &dst_matrix[f][(c+61) * 4];
           	p_s = (bgra_t*) &src_matrix[f][(c+61) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 


			p_d = (bgra_t*) &dst_matrix[f][(c+62) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+62) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a;



			p_d = (bgra_t*) &dst_matrix[f][(c+63) * 4];
            p_s = (bgra_t*) &src_matrix[f][(c+63) * 4];

			p_d->g = p_s->r;
			p_d->r = p_s->b;
			p_d->b = p_s->g;
			p_d->a = p_s->a; 
		}
	}
}