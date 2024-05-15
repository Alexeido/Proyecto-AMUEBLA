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




[Rr][Ee][Cc][Tt][Aa][Nn][Gg][Uu][Ll][Oo]                if(debug) printf("FORMAr "); return FORMA; yylval.c_forma=0;   
[Cc][Ii][Rr][Cc][Uu][Ll][Oo]                            if(debug) printf("FORMAc "); return FORMA; yylval.c_forma=1;
"negro"                                                 if(debug) printf("COLORn "); return COLOR; yylval.c_color=0;
"gris"                                                  if(debug) printf("COLORg "); return COLOR; yylval.c_color=1;
"rojo"                                                  if(debug) printf("COLORr "); return COLOR; yylval.c_color=2;
"azul"                                                  if(debug) printf("COLORaz "); return COLOR; yylval.c_color=3;
"amarillo"                                              if(debug) printf("COLORam "); return COLOR; yylval.c_color=4;
"verde"                                                 if(debug) printf("COLORv "); return COLOR; yylval.c_color=5;
"marron"                                                if(debug) printf("COLORm "); return COLOR; yylval.c_color=6;

[Ee][Nn][Tt][Ee][Rr][Oo]                                if(debug) printf("TIPOi "); return TIPO; yylval.c_type=0;
[Rr][Ee][Aa][Ll]                                        if(debug) printf("TIPOr "); return TIPO; yylval.c_type=1;
[Bb][Oo][Oo][Ll]                                        if(debug) printf("TIPOb "); return TIPO; yylval.c_type=2;

[Ss][Ii][Tt][Uu][Aa][Rr]                                if(debug) printf("SITUAR "); return SITUAR;
[Pp][Aa][Uu][Ss][Aa]                                    if(debug) printf("PAUSA "); return PAUSA;
[Mm][Ee][Nn][Ss][Aa][Jj][Ee]                            if(debug) printf("MENSAJE "); return MENSAJE;

[Cc][Ii][Ee][Rr][Tt][Oo]        { yylval.c_bool = true; if(debug) printf("CIERTO "); return CIERTO; }
[Ff][Aa][Ll][Ss][Oo]            { yylval.c_bool = false; if(debug) printf("FALSO "); return FALSO; }
[0-9]+                          yylval.c_entero = atoi(yytext); if(debug) printf("INT "); return NUMERO;

[A-ZÁÉÍÓÚüÜ][A-Za-z0-9_áéíóúÁÉÍÓÚüÜ]* strcpy(yylval.c_cadena, yytext); if(debug) printf("NOMBRE "); return NOMBRE;
[a-záéíóú][A-Za-z0-9_áéíóúÁÉÍÓÚüÜ]* strcpy(yylval.c_cadena, yytext); if(debug) printf("ID "); return ID;

[0-9]*"."[0-9]+                 yylval.c_real = atof(yytext); if(debug) printf("FLOAT "); return REAL;
[0-9]+"."[0-9]*                 yylval.c_real = atof(yytext); if(debug) printf("FLOAT "); return REAL;
([0-9]*[.][0-9]|[0-9][.][0-9]+)[eE][+-]?[0-9]+ yylval.c_real = atof(yytext); if(debug) printf("FFLOAT "); return REAL;
"\"[^\"\n]*\"" { yylval.c_string = strdup(yytext); if(debug) printf("CADENA "); return CADENA; }


\n                              n_lineas++; if (debug) printf("\n"); return (yytext[0]); // Nueva línea
[\t ]                           ;   
.                               if(debug) printf("%c",yytext[0]); return (yytext[0]);
%%
