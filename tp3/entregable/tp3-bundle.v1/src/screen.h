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
void screen_imprimir(char* mensaje, char forecolor, char bgcolor, char blink, char x, char y, char keepBGColor);
void screen_colorear(char fromX, char fromY, char toX, char toY, char bgcolor);
void screen_limpiar();
void screen_blink_colors();


#endif  /* !__SCREEN_H__ */
