/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#include "screen.h"
#include "colors.h"


/*
void screen_imprimir(char* mensaje, char forecolor, char bgcolor, char blink, char x, char y){

atributos:

char* mensaje: string del texto a imprimir. Debe ser null-terminated

char forecolor: color del texto a imprimir, según esta tabla:

forecolor table:
Value 	Color
0 		BLACK 	
1 		BLUE 	
2 		GREEN 	
3 		CYAN 	
4 		RED 	
5 		MAGENTA 	
6 		BROWN 	
7 		LIGHT GREY 	
8 		DARK GREY
9 		LIGHT BLUE
10 		LIGHT GREEN
11 		LIGHT CYAN
12 		LIGHT RED
13 		LIGHT MAGENTA
14 		LIGHT BROWN
15 		WHITE

char bgcolor: color del fondo a imprimir, según esta tabla:



char blink: 1 = blink on, 0 = blink off
char x: posición x entre 0 y VIDEO_COLS donde comienza el texto
char y: posición y entre 0 y VIEDO_FILS donde comienza el texto

char keepBGColor: 1 = ignora el bgcolor y blink que le pasamos y usa el que ya está guardado en memoria

*/

void screen_imprimir(char* mensaje, char forecolor, char bgcolor, char blink, char x, char y, char keepBGColor){

	// El mensaje tiene que terminar en null
	// C ya hace eso con los strings entre comillas

	if (x >= 0 && x <= VIDEO_COLS){		
		if (y >= 0 && y <= VIDEO_FILS){
			// posicion valida

			keepBGColor = keepBGColor & 0x01;


			char attr;
			
			// limpio la partes altas de forecolor
			forecolor = forecolor & 0x0F;

			if (keepBGColor == 0){
				// limpio las partes altas de bgcolor y blink
				bgcolor = bgcolor & 0x07;
				blink = blink & 0x01;

				// me construyo el byte de attribute
				bgcolor = bgcolor << 4;
				blink = blink << 7;


				attr = forecolor + bgcolor + blink;
			}
			

			char charActual = *(mensaje);
			short elemento;
			int i = 0;
			while (charActual != 0x00){


				if (keepBGColor == 1){

					// calculo dónde escribir el short correspondiente al char actual del mensaje
					short* pos = (short*)(VIDEO_BUFFER_LOCATION + x*2 + y*80*2 + i*2);

					// leo el attr de la ram
					attr =  *((char*)(VIDEO_BUFFER_LOCATION + x*2 + y*80*2 + i*2 + 1));

					// me construyo el nuevo attr con el forecolor que quiero
					attr = attr & 0xF0;
					attr = attr | forecolor;
					elemento = attr;
					elemento = elemento << 8;
					elemento = elemento + charActual;

					*pos = elemento;
				}
				else
				{
					// Me construyo el short para escribir en memoria de video
					elemento = attr;
					elemento = elemento << 8;
					elemento = elemento + charActual;

					// calculo dónde escribir el short correspondiente al char actual del mensaje
					short* pos = (short*)(VIDEO_BUFFER_LOCATION + x*2 + y*80*2 + i*2);
	
					// Lo escribo en memoria
					*pos = elemento;
				}

				
				

				// Incremento el contador
				i++;
				// Avanzo el siguiente char
				charActual = *(mensaje + i);
			}
		}
	}
}


void screen_colorear(char fromX, char fromY, char toX, char toY, char bgcolor){
	
	// Me fijo que las coordenadas sean válidas
	if (toX > VIDEO_COLS) return;
	if (toY > VIDEO_FILS) return;

	if (fromX >= 0 && fromX <= toX){		
		if (fromY >= 0 && fromY <= toY){

			// limpio las partes altas
			bgcolor = bgcolor & 0x07;

			// me construyo el byte de attribute
			bgcolor = bgcolor << 4;

			int actualX;
			int actualY;

			for (actualY = fromY; actualY < toY; actualY++){
				for (actualX = fromX; actualX < toX; actualX++){
					short* pos = (short*)(VIDEO_BUFFER_LOCATION + actualX*2 + actualY*80*2);
					*pos = ((short) bgcolor) << 8;
				}	
			}
			
		}
	}
}


void screen_limpiar(){
	screen_colorear(0, 0, 80, 25, C_BG_BLACK);
}

void screen_blink_colors(){
	screen_colorear(0, 0, 80, 25, C_BG_BLUE);
	screen_colorear(0, 0, 80, 25, C_BG_GREEN);
	screen_colorear(0, 0, 80, 25, C_BG_CYAN);
	screen_colorear(0, 0, 80, 25, C_BG_RED);
	screen_colorear(0, 0, 80, 25, C_BG_MAGENTA);
	screen_colorear(0, 0, 80, 25, C_BG_BROWN);
	screen_colorear(0, 0, 80, 25, C_BG_LIGHT_GREY);

}
