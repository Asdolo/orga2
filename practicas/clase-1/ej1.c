#include <stdio.h>
extern int fun(int, int);
int main(int argc, char *argv[]){
	int h= fun(atoi(argv[1]),atoi(argv[2]));
	printf("%d\r\n",h);
	return 0;
}
