/**

 Teoría de lenguajes
 Curso 2023/2024

 Nombre: amuebla.h
 Descripción: Implementación de la librería gráfica para el lenguaje AMUEBLA
 Autor:	Profesorado de la asignatura
 Fecha:	15/04/2024

 */


#ifndef MONDRIAN_H_
#define MONDRIAN_H_

#include <iostream>
#include <string>

using namespace std;


/*
 * DESCRIPCIÓN: Colores usados
*/
const int BLANCO    = 0;
const int NEGRO     = 1;
const int GRIS		= 2;
const int ROJO      = 3;
const int AZUL      = 4;
const int AMARILLO  = 5;
const int VERDE     = 6;
const int MARRON    = 7;

/*
 *	DESCRIPCIÓN: Inicia el entorno gráfico. Abre una ventana con nombre "AMUEBLA" en la parte superior
 */
void iniciarAmu ();


/*
 *	DESCRIPCIÓN: Cierra la ventana. Libera los recursos usados por el entorno gráfico
 */
void terminarAmu ();


/*
 * PRE: {s >= 0}
 * DESCRIPCIÓN: Detiene la ejecución durante s segundos
 */
void pausaAmu (float s);


/*
 * PRE: {0<alto, ancho <= 1000}
 * DESCRIPCIÓN: Limpia la ventana y la deja en blanco con un tamaño de alto por ancho. 
 * Usa título como nombre de la ventana en la parte superior
 */
void nuevaHabitacionAmu (string titulo, int alto, int ancho);


/*
 * PRE = {0<=fila, columna, alto, ancho <999; 0 <= color <= 7}
 * DESCRIPCIÓN: dibuja un rectángulo del color indicado cuya esquina superior izquierda está en (fila, columna) y
 *              el alto y ancho indicados.
 */
void rectanguloAmu (int fila, int columna, float alto, float ancho, int color);


/*
 * PRE = {0<=fila, columna, radio <999; 0 <= color <= 7}
 * DESCRIPCIÓN: dibuja un círculo del color indicado cuya centro está en (fila, columna) y
 *              el radio indicado.
 */
void circuloAmu (int fila, int columna, float radio, int color);


#endif
