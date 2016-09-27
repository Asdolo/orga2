
#include "../tp2.h"

//kdbg -a "-i c -v colorizar ./img/lena32.bmp 0.4" ./build/tp2

unsigned char max(bgra_t* (*list)[9], unsigned char component)
{
	unsigned char res;
		switch (component)
		{
			case 0: //R
				res = (*list)[0]->r;
				for (int i = 0; i < 9; ++i)
				{
						if ((*list)[i]->r > res) res = (*list)[i]->r;
				}

				break;
			case 1: //G
				res = (*list)[0]->g;
				for (int i = 0; i < 9; ++i)
				{
						if ((*list)[i]->g > res) res = (*list)[i]->g;
				}

				break;
			case 2: //B
				res = (*list)[0]->b;
				for (int i = 0; i < 9; ++i)
				{
						if ((*list)[i]->b > res) res = (*list)[i]->b;
				}

				break;
		}

		return res;

}

float phiR(float alpha, unsigned char maxR, unsigned char maxG, unsigned char maxB){

	float res;

	if (maxR >= maxG && maxR >= maxB){
		res = 1 + alpha;
	}
	else
	{
			res = 1 - alpha;
	}

	return res;
}

float phiG(float alpha, unsigned char maxR, unsigned char maxG, unsigned char maxB){

	float res;

	if (maxR < maxG && maxG >= maxB){
		res = 1 + alpha;
	}
	else
	{
			res = 1 - alpha;
	}

	return res;
}

float phiB(float alpha, unsigned char maxR, unsigned char maxG, unsigned char maxB){

	float res;

	if (maxR < maxB && maxG < maxB){
		res = 1 + alpha;
	}
	else
	{
			res = 1 - alpha;
	}

	return res;
}


unsigned char min(float a, float b)
{
		unsigned char res = (unsigned char) a;
		if (b < a) res = (unsigned char) b;
		return res;
}


void colorizar_c (
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
	for (int f = 1; f < filas-1; f++) {
			for (int c = 1; c < cols-1; c+=1) {
				bgra_t *p_s = (bgra_t*) &src_matrix[f][c * 4];
				bgra_t *p_d = (bgra_t*) &dst_matrix[f][c * 4];

				bgra_t* vecinos_y_yo[9] =
					{
						(bgra_t*) &src_matrix[(f-1)][(c-1) * 4],
						(bgra_t*) &src_matrix[(f-1)][(c) * 4],
						(bgra_t*) &src_matrix[(f-1)][(c+1) * 4],
						(bgra_t*) &src_matrix[(f)][(c-1) * 4],
						p_s,
						(bgra_t*) &src_matrix[(f)][(c+1) * 4],
						(bgra_t*) &src_matrix[(f+1)][(c-1) * 4],
						(bgra_t*) &src_matrix[(f+1)][(c) * 4],
						(bgra_t*) &src_matrix[(f+1)][(c+1) * 4]
					};

				float maxR = max(&vecinos_y_yo, 0);
				float maxG = max(&vecinos_y_yo, 1);
				float maxB = max(&vecinos_y_yo, 2);


				float phi = phiR(alpha, maxR, maxG, maxB);
				p_d->r = min(255.0, phi * p_s->r);

				phi = phiG(alpha, maxR, maxG, maxB);
				p_d->g = min(255.0, phi * p_s->g);

				phi = phiB(alpha, maxR, maxG, maxB);
				p_d->b = min(255.0, phi * p_s->b);

				p_d->a = p_s->a;




			if (c+1!=cols-1){

					c=c+3;
				p_s = (bgra_t*) &src_matrix[f][c * 4];
				p_d = (bgra_t*) &dst_matrix[f][c * 4];
				bgra_t* vecinos_y_yo2[9] =
					{
						(bgra_t*) &src_matrix[(f-1)][(c-1) * 4],
						(bgra_t*) &src_matrix[(f-1)][(c) * 4],
						(bgra_t*) &src_matrix[(f-1)][(c+1) * 4],
						(bgra_t*) &src_matrix[(f)][(c-1) * 4],
						p_s,
						(bgra_t*) &src_matrix[(f)][(c+1) * 4],
						(bgra_t*) &src_matrix[(f+1)][(c-1) * 4],
						(bgra_t*) &src_matrix[(f+1)][(c) * 4],
						(bgra_t*) &src_matrix[(f+1)][(c+1) * 4]
					};
				 maxR = max(&vecinos_y_yo2, 0);
				 maxG = max(&vecinos_y_yo2, 1);
				 maxB = max(&vecinos_y_yo2, 2);


				 phi = phiR(alpha, maxR, maxG, maxB);
				p_d->r = min(255.0, phi * p_s->r);

				phi = phiG(alpha, maxR, maxG, maxB);
				p_d->g = min(255.0, phi * p_s->g);

				phi = phiB(alpha, maxR, maxG, maxB);
				p_d->b = min(255.0, phi * p_s->b);

				p_d->a = p_s->a;



				p_s = (bgra_t*) &src_matrix[f][(c-1) * 4];
p_d = (bgra_t*) &dst_matrix[f][(c-1) * 4];
				bgra_t* vecinos_y_yo3[9] ={
					vecinos_y_yo[2],
					vecinos_y_yo2[0],
					vecinos_y_yo2[1],
					vecinos_y_yo[5],
					vecinos_y_yo2[3],
					vecinos_y_yo2[4],
					vecinos_y_yo[8],
					vecinos_y_yo2[6],
					vecinos_y_yo2[7]
				};


				maxR = max(&vecinos_y_yo3, 0);
				 maxG = max(&vecinos_y_yo3, 1);
				 maxB = max(&vecinos_y_yo3, 2);


				 phi = phiR(alpha, maxR, maxG, maxB);
				p_d->r = min(255.0, phi * p_s->r);

				phi = phiG(alpha, maxR, maxG, maxB);
				p_d->g = min(255.0, phi * p_s->g);

				phi = phiB(alpha, maxR, maxG, maxB);
				p_d->b = min(255.0, phi * p_s->b);

				p_d->a = p_s->a;

				p_s = (bgra_t*) &src_matrix[f][(c-2) * 4];

				p_d = (bgra_t*) &dst_matrix[f][(c-2) * 4];
				bgra_t* vecinos_y_yo4[9] ={
					vecinos_y_yo[1],
					vecinos_y_yo[2],
					vecinos_y_yo2[0],
					vecinos_y_yo[4],
					vecinos_y_yo[5],
					vecinos_y_yo2[3],
					vecinos_y_yo[7],
					vecinos_y_yo[8],
					vecinos_y_yo2[6]
				};

				maxR = max(&vecinos_y_yo4, 0);
				 maxG = max(&vecinos_y_yo4, 1);
				 maxB = max(&vecinos_y_yo4, 2);
				 phi = phiR(alpha, maxR, maxG, maxB);
				p_d->r = min(255.0, phi * p_s->r);

				phi = phiG(alpha, maxR, maxG, maxB);
				p_d->g = min(255.0, phi * p_s->g);

				phi = phiB(alpha, maxR, maxG, maxB);
				p_d->b = min(255.0, phi * p_s->b);

				p_d->a = p_s->a;

					}else{

					c=c-1;
				p_d = (bgra_t*) &dst_matrix[f][c * 4];
				bgra_t* vecinos_y_yo2[9] =
					{
						(bgra_t*) &src_matrix[(f-1)][(c-1) * 4],
						(bgra_t*) &src_matrix[(f-1)][(c) * 4],
						(bgra_t*) &src_matrix[(f-1)][(c+1) * 4],
						(bgra_t*) &src_matrix[(f)][(c-1) * 4],
						p_s,
						(bgra_t*) &src_matrix[(f)][(c+1) * 4],
						(bgra_t*) &src_matrix[(f+1)][(c-1) * 4],
						(bgra_t*) &src_matrix[(f+1)][(c) * 4],
						(bgra_t*) &src_matrix[(f+1)][(c+1) * 4]
					};

 				maxR = max(&vecinos_y_yo2, 0);
				 maxG = max(&vecinos_y_yo2, 1);
				 maxB = max(&vecinos_y_yo2, 2);


				 phi = phiR(alpha, maxR, maxG, maxB);
				p_d->r = min(255.0, phi * p_s->r);

				phi = phiG(alpha, maxR, maxG, maxB);
				p_d->g = min(255.0, phi * p_s->g);

				phi = phiB(alpha, maxR, maxG, maxB);
				p_d->b = min(255.0, phi * p_s->b);

				p_d->a = p_s->a;


					}


			}
		}


}
