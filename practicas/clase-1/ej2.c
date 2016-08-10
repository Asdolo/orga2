#include <stdio.h>
#include <stdlib.h>
extern double fun(double, double);
int main(int argc, char *argv[]){
	double h= fun(atof(argv[1]),atof(argv[2]));
	printf("%f\n",h);
	return 0;
}
