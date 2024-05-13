%{
#include "expresiones.h"
#include <stdio.h>
#include <math.h>
int n_lineas;
int debug = 1; // Variable debug para controlar la impresión de mensajes de depuración
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


[Vv][Aa][Rr][Ii][Aa][Bb][Ll][Ee][Ss]                    if(debug) printf("VARIABLES ");     return VARIABLES;
[Mm][Uu][Ee][Bb][Ll][Ee][Ss]                            if(debug) printf("MUEBLES ");       return MUEBLES;
[Hh][Aa][Bb][Ii][Tt][Aa][Cc][Ii][Oo][Nn]                if(debug) printf("HABITACION ");    return HABITACION;
[Ff][Ii][Nn][Hh][Aa][Bb][Ii][Tt][Aa][Cc][Ii][Oo][Nn]    if(debug) printf("FINHABITACION "); return FINHABITACION;

[Rr][Ee][Cc][Tt][Aa][Nn][Gg][Uu][Ll][Oo]                if(debug) printf("RECTANGULO "); return RECTANGULO;
[Cc][Ii][Rr][Cc][Uu][Ll][Oo]                            if(debug) printf("CIRCULO "); return CIRCULO; 
"negro"                                                 if(debug) printf("NEGRO "); return NEGRO;
"gris"                                                  if(debug) printf("GRIS "); return GRIS;
"rojo"                                                  if(debug) printf("ROJO "); return ROJO;
"azul"                                                  if(debug) printf("AZUL "); return AZUL;
"amarillo"                                              if(debug) printf("AMARILLO "); return AMARILLO;
"verde"                                                 if(debug) printf("VERDE "); return VERDE;
"marron"                                                if(debug) printf("MARRON "); return MARRON;

[Ee][Nn][Tt][Ee][Rr][Oo]                                if(debug) printf("decENTERO "); return decENTERO;
[Rr][Ee][Aa][Ll]                                        if(debug) printf("decREAL "); return decREAL;
[Bb][Oo][Oo][Ll]                                        if(debug) printf("decBOOL "); return decBOOL;

[Ss][Ii][Tt][Uu][Aa][Rr]                                if(debug) printf("SITUAR "); return SITUAR;
[Pp][Aa][Uu][Ss][Aa]                                    if(debug) printf("PAUSA "); return PAUSA;
[Mm][Ee][Nn][Ss][Aa][Jj][Ee]                            if(debug) printf("MENSAJE "); return MENSAJE;

[Cc][Ii][Ee][Rr][Tt][Oo]        { yylval.c_bool = true; if(debug) printf("CIERTO "); return CIERTO; }
[Ff][Aa][Ll][Ss][Oo]            { yylval.c_bool = false; if(debug) printf("FALSO "); return FALSO; }
[0-9]+                          yylval.c_entero = atoi(yytext); if(debug) printf("INT "); return NUMERO

[A-ZÁÉÍÓÚüÜ][A-Za-z0-9_áéíóúÁÉÍÓÚüÜ]* strcpy(yylval.c_cadena, yytext); if(debug) printf("NOMBRE "); return NOMBRE;
[a-záéíóú][A-Za-z0-9_áéíóúÁÉÍÓÚüÜ]* strcpy(yylval.c_cadena, yytext); if(debug) printf("ID "); return ID;
;
[0-9]*"."[0-9]+                 yylval.c_real = atof(yytext); if(debug) printf("FLOAT "); return REAL;
[0-9]+"."[0-9]*                 yylval.c_real = atof(yytext); if(debug) printf("FLOAT "); return REAL;
([0-9]*[.][0-9]|[0-9][.][0-9]+)[eE][+-]?[0-9]+ yylval.c_real = atof(yytext); if(debug) printf("FFLOAT "); return REAL;
\"[^\"\n]*\"                    {yylval.c_string = strdup(yytext); if(debug) printf("CADENA "); return CADENA;}



\n                              n_lineas++; if (debug) printf("\n"); return (yytext[0]); // Nueva línea
[\t ]                           ;   
.                               if(debug) printf("%c",yytext[0]); return (yytext[0]);
%%
