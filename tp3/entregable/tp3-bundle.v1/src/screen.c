/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#include "defines.h"
#include "screen.h"
#include "colors.h"
#include "idt.h"
#include "isr.h"
#include "mmu.h"

char* nombre_grupo = "Burj Al Arab - Tom Wright";

char modo_pantalla = 0;
// 0 = modo estado
// 1 = modo mapa


/*
void screen_imprimir(char* mensaje, char forecolor, char bgcolor, char blink, char x, char y, char buffer){

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

char buffer
0 = BUFFER ESTADO
1 = BUFFER MAPA
2 = MEMORIA DE VIDEO

*/

void screen_imprimir(char* mensaje, char forecolor, char bgcolor, char blink, char x, char y, char keepBGColor, char buffer){

	int bufferActual;
	switch (buffer)
	{
		case 0:
			bufferActual = BUFFER_ESTADO;
			break;
		case 1:
			bufferActual = BUFFER_MAPA;
			break;
		case 2:
			bufferActual = VIDEO;
			break;
	}

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
					short* pos = (short*)(bufferActual + x*2 + y*80*2 + i*2);

					// leo el attr de la ram
					attr =  *((char*)(bufferActual + x*2 + y*80*2 + i*2 + 1));

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
					short* pos = (short*)(bufferActual + x*2 + y*80*2 + i*2);
	
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


void screen_colorear(char fromX, char fromY, char toX, char toY, char bgcolor, char buffer)
{
	
	int bufferActual;
	switch (buffer)
	{
		case 0:
			bufferActual = BUFFER_ESTADO;
			break;
		case 1:
			bufferActual = BUFFER_MAPA;
			break;
		case 2:
			bufferActual = VIDEO;
			break;
	}

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

			for (actualY = fromY; actualY <= toY; actualY++){
				for (actualX = fromX; actualX <= toX; actualX++){
					short* pos = (short*)(bufferActual + actualX*2 + actualY*80*2);
					*pos = ((short) bgcolor) << 8;
				}	
			}
			
		}
	}
}


void screen_limpiar()
{
	screen_colorear(0, 0, 80, 25, C_BG_BLACK, 2);
}


void screen_print_grupo()
{
	screen_imprimir(nombre_grupo, C_FG_WHITE, C_BG_GREEN, 0, 1, 0, 1, 0);

}


void actualizar_pantalla()
{
	if (modo_pantalla == 0)
    {
        // quiero estado
        copiar((int*) BUFFER_ESTADO, (int*) VIDEO, 4000);
    }
    else
    {
    	// quiero mapa
        copiar((int*) BUFFER_MAPA, (int*) VIDEO, 4000);
    }
    return;
}



void screen_modo_estado()
{
	screen_limpiar();
	screen_colorear(0, 0, 79, 1, C_BG_BLACK, 0);
	screen_colorear(0, 1, 79, 24, C_BG_LIGHT_GREY, 0);

	// Imprimo consola de registros
	screen_colorear(50, 1, 77, 14, C_BG_BLACK, 0);

	// Imprimo el ultimo problema
	screen_colorear(50, 1, 77, 1, C_BG_RED, 0);
	screen_imprimir(idt_ultimo_problema, C_FG_WHITE, C_BG_GREEN, 0, 50, 1, 1, 0);
	
	char asd1[9];
	
	int_to_string_hex8(0x6789ABCD, asd1);
	
	screen_imprimir("EAX", C_FG_WHITE, C_BG_GREEN, 0, 51, 2, 1, 0);
	screen_imprimir(asd1, C_FG_WHITE, C_BG_GREEN, 0, 55, 2, 1, 0);

	screen_imprimir("EBX", C_FG_WHITE, C_BG_GREEN, 0, 51, 3, 1, 0);
	screen_imprimir(asd1, C_FG_WHITE, C_BG_GREEN, 0, 55, 3, 1, 0);

	screen_imprimir("ECX", C_FG_WHITE, C_BG_GREEN, 0, 51, 4, 1, 0);
	screen_imprimir(asd1, C_FG_WHITE, C_BG_GREEN, 0, 55, 4, 1, 0);

	screen_imprimir("EDX", C_FG_WHITE, C_BG_GREEN, 0, 51, 5, 1, 0);
	screen_imprimir(asd1, C_FG_WHITE, C_BG_GREEN, 0, 55, 5, 1, 0);

	screen_imprimir("ESI", C_FG_WHITE, C_BG_GREEN, 0, 51, 6, 1, 0);
	screen_imprimir(asd1, C_FG_WHITE, C_BG_GREEN, 0, 55, 6, 1, 0);

	screen_imprimir("EDI", C_FG_WHITE, C_BG_GREEN, 0, 51, 7, 1, 0);
	screen_imprimir(asd1, C_FG_WHITE, C_BG_GREEN, 0, 55, 7, 1, 0);

	screen_imprimir("EBP", C_FG_WHITE, C_BG_GREEN, 0, 51, 8, 1, 0);
	screen_imprimir(asd1, C_FG_WHITE, C_BG_GREEN, 0, 55, 8, 1, 0);

	screen_imprimir("ESP", C_FG_WHITE, C_BG_GREEN, 0, 51, 9, 1, 0);
	screen_imprimir(asd1, C_FG_WHITE, C_BG_GREEN, 0, 55, 9, 1, 0);

	screen_imprimir("EIP", C_FG_WHITE, C_BG_GREEN, 0, 51, 10, 1, 0);
	screen_imprimir(asd1, C_FG_WHITE, C_BG_GREEN, 0, 55, 10, 1, 0);

	screen_imprimir("CR0", C_FG_WHITE, C_BG_GREEN, 0, 51, 11, 1, 0);
	screen_imprimir(asd1, C_FG_WHITE, C_BG_GREEN, 0, 55, 11, 1, 0);

	screen_imprimir("CR2", C_FG_WHITE, C_BG_GREEN, 0, 51, 12, 1, 0);
	screen_imprimir(asd1, C_FG_WHITE, C_BG_GREEN, 0, 55, 12, 1, 0);

	screen_imprimir("CR3", C_FG_WHITE, C_BG_GREEN, 0, 51, 13, 1, 0);
	screen_imprimir(asd1, C_FG_WHITE, C_BG_GREEN, 0, 55, 13, 1, 0);

	screen_imprimir("CR4", C_FG_WHITE, C_BG_GREEN, 0, 51, 14, 1, 0);
	screen_imprimir(asd1, C_FG_WHITE, C_BG_GREEN, 0, 55, 14, 1, 0);


	screen_imprimir("CS", C_FG_WHITE, C_BG_GREEN, 0, 66, 2, 1, 0);
	screen_imprimir(asd1, C_FG_WHITE, C_BG_GREEN, 0, 69, 2, 1, 0);

	screen_imprimir("DS", C_FG_WHITE, C_BG_GREEN, 0, 66, 3, 1, 0);
	screen_imprimir(asd1, C_FG_WHITE, C_BG_GREEN, 0, 69, 3, 1, 0);

	screen_imprimir("ES", C_FG_WHITE, C_BG_GREEN, 0, 66, 4, 1, 0);
	screen_imprimir(asd1, C_FG_WHITE, C_BG_GREEN, 0, 69, 4, 1, 0);

	screen_imprimir("FS", C_FG_WHITE, C_BG_GREEN, 0, 66, 5, 1, 0);
	screen_imprimir(asd1, C_FG_WHITE, C_BG_GREEN, 0, 69, 5, 1, 0);

	screen_imprimir("GS", C_FG_WHITE, C_BG_GREEN, 0, 66, 6, 1, 0);
	screen_imprimir(asd1, C_FG_WHITE, C_BG_GREEN, 0, 69, 6, 1, 0);

	screen_imprimir("SS", C_FG_WHITE, C_BG_GREEN, 0, 66, 7, 1, 0);
	screen_imprimir(asd1, C_FG_WHITE, C_BG_GREEN, 0, 69, 7, 1, 0);

	
	screen_imprimir("EFLAGS", C_FG_WHITE, C_BG_GREEN, 0, 66, 9, 1, 0);
	screen_imprimir(asd1, C_FG_WHITE, C_BG_GREEN, 0, 69, 10, 1, 0);

	// Imprimo banderas
	screen_imprimir("NAVIO 1", C_FG_BLACK, C_BG_GREEN, 0, 5, 2, 1, 0);
	screen_colorear(2, 3, 11, 7, C_BG_BLACK, 0);
	screen_imprimir("NAVIO 2", C_FG_BLACK, C_BG_GREEN, 0, 14+3, 3-1, 1, 0);
	screen_colorear(14, 3, 23, 7, C_BG_BLACK, 0);
	screen_imprimir("NAVIO 3", C_FG_BLACK, C_BG_GREEN, 0, 26+3, 3-1, 1, 0);
	screen_colorear(26, 3, 35, 7, C_BG_BLACK, 0);
	screen_imprimir("NAVIO 4", C_FG_BLACK, C_BG_GREEN, 0, 38+3, 3-1, 1, 0);
	screen_colorear(38, 3, 47, 7, C_BG_BLACK, 0);

	screen_imprimir("NAVIO 5", C_FG_BLACK, C_BG_GREEN, 0, 5, 9, 1, 0);
	screen_colorear(2, 10, 11, 14, C_BG_BLACK, 0);
	screen_imprimir("NAVIO 6", C_FG_BLACK, C_BG_GREEN, 0, 17, 9, 1, 0);
	screen_colorear(14, 10, 23, 14, C_BG_BLACK, 0);
	screen_imprimir("NAVIO 7", C_FG_BLACK, C_BG_GREEN, 0, 29, 9, 1, 0);
	screen_colorear(26, 10, 35, 14, C_BG_BLACK, 0);
	screen_imprimir("NAVIO 8", C_FG_BLACK, C_BG_GREEN, 0, 41, 9, 1, 0);
	screen_colorear(38, 10, 47, 14, C_BG_BLACK, 0);

	screen_colorear(2, 16, 78, 23, C_BG_BLUE, 0);
	screen_imprimir("1", C_FG_BLACK, C_BG_GREEN, 0, 1, 16, 1, 0);
	screen_imprimir("2", C_FG_BLACK, C_BG_GREEN, 0, 1, 17, 1, 0);
	screen_imprimir("3", C_FG_BLACK, C_BG_GREEN, 0, 1, 18, 1, 0);
	screen_imprimir("4", C_FG_BLACK, C_BG_GREEN, 0, 1, 19, 1, 0);
	screen_imprimir("5", C_FG_BLACK, C_BG_GREEN, 0, 1, 20, 1, 0);
	screen_imprimir("6", C_FG_BLACK, C_BG_GREEN, 0, 1, 21, 1, 0);
	screen_imprimir("7", C_FG_BLACK, C_BG_GREEN, 0, 1, 22, 1, 0);
	screen_imprimir("8", C_FG_BLACK, C_BG_GREEN, 0, 1, 23, 1, 0);



	// Imprimo el nombre del grupo
	screen_print_grupo();
}


void screen_modo_mapa()
{
	screen_limpiar();
	screen_colorear(0, 0, 79, 2, C_BG_GREEN, 1);
	screen_colorear(0, 3, 15, 3, C_BG_GREEN, 1);

	screen_colorear(16, 3, 79, 3, C_BG_BLUE, 1);
	screen_colorear(0, 4, 79, 23, C_BG_BLUE, 1);

}





void int_to_string_hex8(int numero, char str[9])
{
    char letras[16] = "0123456789ABCDEF";
    str[8] = 0; //null terminated
    str[7] = letras[ ( numero & 0x0000000F ) >> 0  ];
    str[6] = letras[ ( numero & 0x000000F0 ) >> 4  ];
    str[5] = letras[ ( numero & 0x00000F00 ) >> 8  ];
    str[4] = letras[ ( numero & 0x0000F000 ) >> 12 ];
    str[3] = letras[ ( numero & 0x000F0000 ) >> 16 ];
    str[2] = letras[ ( numero & 0x00F00000 ) >> 20 ];
    str[1] = letras[ ( numero & 0x0F000000 ) >> 24 ];
    str[0] = letras[ ( numero & 0xF0000000 ) >> 28 ];
    
    
}


void screen_proximo_reloj()
{
	proximo_reloj();
}