%{
#include "expresiones.h"
#include <stdio.h>
#include <math.h>
#include <vector>
#include <string>
#include <cstring>
#include "tablaValores.h"
#include "tablaMuebles.h"
int n_lineas;
int debug = 0; // Variable debug para controlar la impresión de mensajes de depuración
%}

%option noyywrap
 
%%
"%%".*                           { /* Ignorar comentarios */ }
^[ \t]\n                         n_lineas++; if(debug) printf("\t\n"); // Espacio en lugar de nueva línea
^\n                              n_lineas++; if (debug) printf("\n"); // Nueva línea
"<-"                             if(debug) printf("ASIGNATION "); return ASIGNATION;  // Agregar regla para reconocer la asignación
"o"                              if(debug) printf("OR "); return OR;  // Agregar regla para reconocer ORs
"y"                              if(debug) printf("AND "); return AND;  // Agregar regla para reconocer ANDs
"no"                             if(debug) printf("NOT "); return NO;  // Agregar regla para reconocer la negación
"=="                             if(debug) printf("== "); return EQ;  // Agregar regla para reconocer la igualdad
"<>"                             if(debug) printf("!= "); return DISTINCT;  // Agregar regla para reconocer la desigualdad
"<="                             if(debug) printf("<= "); return MENEQ;  // Agregar regla para reconocer menor igual
">="                             if(debug) printf(">= "); return MAYEQ;  // Agregar regla para reconocer mayor igual
"//"                             if(debug) printf("// "); return INTDIV;


VARIABLES                                               if(debug) printf("VARIABLES ");     return VARIABLES;
MUEBLES                                                 if(debug) printf("MUEBLES ");       return MUEBLES;
HABITACION                                              if(debug) printf("HABITACION ");    return HABITACION;
FINHABITACION                                           if(debug) printf("FINHABITACION "); return FINHABITACION;




rectangulo                                              if(debug) printf("FORMAr "); yylval.c_forma=0; return FORMA; 
circulo                                                 if(debug) printf("FORMAc "); yylval.c_forma=1; return FORMA;

negro                                                   if(debug) printf("COLORn "); yylval.c_color=0; return COLOR;
gris                                                    if(debug) printf("COLORg "); yylval.c_color=1; return COLOR;
rojo                                                    if(debug) printf("COLORr "); yylval.c_color=2; return COLOR;
azul                                                    if(debug) printf("COLORaz "); yylval.c_color=3; return COLOR;
amarillo                                                if(debug) printf("COLORam "); yylval.c_color=4; return COLOR;
verde                                                   if(debug) printf("COLORv "); yylval.c_color=5; return COLOR;
marron                                                  if(debug) printf("COLORm "); yylval.c_color=6; return COLOR;

[Ee][Nn][Tt][Ee][Rr][Oo]                                if(debug) printf("TIPOi "); yylval.c_type=0; return TIPO; 
[Rr][Ee][Aa][Ll]                                        if(debug) printf("TIPOr "); yylval.c_type=1; return TIPO; 
[Bb][Oo][Oo][Ll]                                        if(debug) printf("TIPOb "); yylval.c_type=2; return TIPO; 

situar                                                  if(debug) printf("SITUAR "); return SITUAR;
pausa                                                   if(debug) printf("PAUSA "); return PAUSA;
mensaje                                                 if(debug) printf("MENSAJE "); return MENSAJE;
repetir                                                 if(debug) printf("REPETIR "); return REPETIR;
si                                                      if(debug) printf("SI"); return SI;
si_no                                                   if(debug) printf("SINO"); return SINO;

[Cc][Ii][Ee][Rr][Tt][Oo]        { yylval.c_bool = true; if(debug) printf("CIERTO "); return CIERTO; }
[Ff][Aa][Ll][Ss][Oo]            { yylval.c_bool = false; if(debug) printf("FALSO "); return FALSO; }
[0-9]+                          yylval.c_entero = atoi(yytext); if(debug) printf("INT "); return NUMERO;

\"[^\"]*\"          { strcpy(yylval.c_cadena, yytext); return CADENA; }
[A-ZÁÉÍÓÚüÜ][A-Za-z0-9_áéíóúÁÉÍÓÚüÜ]* strcpy(yylval.c_cadena, yytext); if(debug) printf("NOMBRE "); return NOMBRE;
[a-záéíóú][A-Za-z0-9_áéíóúÁÉÍÓÚüÜ]* strcpy(yylval.c_cadena, yytext); if(debug) printf("ID "); return ID;

[0-9]*"."[0-9]+                 yylval.c_real = atof(yytext); if(debug) printf("FLOAT "); return REAL;
[0-9]+"."[0-9]*                 yylval.c_real = atof(yytext); if(debug) printf("FLOAT "); return REAL;
([0-9]*[.][0-9]|[0-9][.][0-9]+)[eE][+-]?[0-9]+ yylval.c_real = atof(yytext); if(debug) printf("FFLOAT "); return REAL;



\n                              n_lineas++; if (debug) printf("\n"); return (yytext[0]); // Nueva línea
[\t ]                           ;   
.                               if(debug) printf("%c",yytext[0]); return (yytext[0]);
%%
