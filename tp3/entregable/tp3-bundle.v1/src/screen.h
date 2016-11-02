/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#ifndef __SCREEN_H__
#define __SCREEN_H__


/* Definicion de la pantalla */
#define VIDEO_FILS 25
#define VIDEO_COLS 80

#define VIDEO_CANTBYTES 4000
#define VIDEO_BUFFER_LOCATION 0xB8000

void screen_pintar_pantalla();
void screen_imprimir(char* mensaje, char forecolor, char bgcolor, char blink, char x, char y, char keepBGColor, char buffer);
void screen_colorear(char fromX, char fromY, char toX, char toY, char bgcolor, char buffer);
void screen_limpiar();
void screen_blink_colors();

void screen_print_grupo();
void screen_modo_estado();
void screen_modo_mapa();

void actualizar_pantalla();

char modo_pantalla;


void int_to_string_hex8(int numero, char* str);
void string_hex8_to_byte_hex8_format(char input[9], char output[9]);


void screen_proximo_reloj();
#endif  /* !__SCREEN_H__ */
