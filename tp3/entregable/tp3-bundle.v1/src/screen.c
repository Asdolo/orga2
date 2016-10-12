/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#include "screen.h"

void screen_imprimir(char* mensaje, char forecolor, char bgcolor, char blink, char x, char y){

	// El mensaje tiene que terminar en null
	// C ya hace eso con los strings entre comillas

	if (x >= 0 && x <= VIDEO_COLS){		
		if (y >= 0 && y <= VIDEO_FILS){
			// posicion valida

			// limpio las partes altas
			forecolor = forecolor & 0x0F;			
			bgcolor = bgcolor & 0x07;
			blink = blink & 0x01;

			// acomodo los char
			bgcolor = bgcolor << 4;
			blink = blink << 7;


			char byte2 = forecolor | bgcolor;
			byte2 = byte2 | blink;

			char charActual = *(mensaje);
			int i = 0;
			while (charActual != 0x00){
				
				// Me construyo el short para video
				short elemento = byte2;
				elemento = elemento << 8;
				elemento = elemento + charActual;

				// calculo donde poner el char actual
				short* pos = (short*)(0xb8000 + x*2 + y*80*2 + i*2);

				// Lo escribo en memoria
				*pos = elemento;

				// Incremento el contador
				i++;
				// Avanzo el siguiente char
				charActual = *(mensaje + i);
			}
		}
	}
}

void screen_limpiar(){
	int i;
	for (i = 0; i < VIDEO_CANTBYTES; i++){
		char* pos = (char*)(0xb8000 + i);

		*pos = 0x00;
	}
}
