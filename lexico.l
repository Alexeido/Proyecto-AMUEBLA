%{
#include "expresiones.h"
#include <math.h>
int n_lineas;
%}

%option noyywrap
 
%%
"%%".*                           { /* Ignorar comentarios */ }
^[ \t]\n                         n_lineas++;
^\n                              n_lineas++;
"<-"                             return ASIGNATION;  // Agregar regla para reconocer la asignación
"o"                              return OR;  // Agregar regla para reconocer ORs
"y"                              return AND;  // Agregar regla para reconocer ANDs
"no"                             return NO;  // Agregar regla para reconocer la negación
"=="                             return EQ;  // Agregar regla para reconocer la igualdad
"<>"                             return DISTINCT;  // Agregar regla para reconocer la desigualdad
"<="                             return MENEQ;  // Agregar regla para reconocer menor igual
">="                             return MAYEQ;  // Agregar regla para reconocer mayor igual
"//"                             return INTDIV;
[Cc][Ii][Ee][Rr][Tt][Oo]        { yylval.c_bool = true; return CIERTO; }
[Ff][Aa][Ll][Ss][Oo]            { yylval.c_bool = false; return FALSO; }
[A-Za-z_][A-Za-z0-9_]*   		strcpy(yylval.c_cadena, yytext); return ID;
[0-9]+							yylval.c_entero = atoi(yytext);return NUMERO;
[0-9]*"."[0-9]+     			yylval.c_real = atof(yytext);return REAL;
[0-9]+"."[0-9]*     			yylval.c_real = atof(yytext);return REAL;
([0-9]*[.][0-9]|[0-9][.][0-9]+)[eE][+-]?[0-9]+ yylval.c_real = atof(yytext);return REAL;
\n								n_lineas++; return (yytext[0]);
[\t ]							;	
. 								return (yytext[0]);
%%