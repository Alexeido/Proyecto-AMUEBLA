%{
#include <iostream>
#include <cmath>
#include <cstring>
#include "tablavalores.h"

using namespace std;

//elementos externos al analizador sintácticos por haber sido declarados en el analizador léxico      			
extern int n_lineas;    			
extern int debug;
extern int yylex();
bool errorSemantico=false;
char msgMid[400];
char msgError[400];
vars variables;
vars variablesBackUp;
ValorVariable actual;
extern FILE* yyin;
extern FILE* yyout;

//definición de procedimientos auxiliares
void yyerror(const char* s){         /*    llamada por cada error sintactico de yacc */
	
      if(debug!=1)
        cout << "Error sintáctico en la instrucción "<< n_lineas+1<<endl;	
      errorSemantico=false;
} 



bool semanticError(){
      if(errorSemantico){
            if(debug!=1)
                cout<<"Error semántico en la instrucción "<<n_lineas<<": "<<msgError<<endl;
            errorSemantico=false;
            return true;
      }
      else{
            return false;
      }
}


bool semanticError(const char *msg){
      if(debug!=1)
        cout<<"Error semántico en la instrucción "<<n_lineas<<": "<<msg<<endl;
      errorSemantico=false;
      
      return true;
}

void setError(const char *msg){
      errorSemantico=true;
      strcpy(msgError,msg);
}


%}
%union{
	int   c_entero;
	float c_real;
	char  c_cadena[20];
	char*  c_string;
      bool  c_bool;
      struct {
            float valor;
            bool esReal;
      } c_expresion;
}

%start entrada
%token <c_entero> NUMERO
%token <c_real> REAL  
%token <c_cadena> ID NOMBRE
%token <c_string> CADENA
%token <c_bool> CIERTO FALSO
%token ASIGNATION SALIR NO EQ MENEQ MAYEQ DISTINCT AND OR INTDIV
%token VARIABLES MUEBLES HABITACION FINHABITACION 
%token RECTANGULO CIRCULO NEGRO GRIS ROJO AZUL AMARILLO VERDE MARRON
%token decENTERO decREAL decBOOL 
%token SITUAR PAUSA MENSAJE
%type <c_expresion> expr
%type <c_bool> exBool 

%left OR
%left AND
%left EQ DISTINCT
%left '<' MENEQ '>' MAYEQ
%left '+' '-' 
%left '*' '/' INTDIV '%' 
%left menos 
%right NO

%%
entrada: 		
      |entrada linea
      ;
      
linea: asignacion 
	|error	'\n'			{yyerrok;}   
	;

asignacion:   ID ASIGNATION exBool '\n'   {if(!semanticError()){
                                                if(!variables.putVar($1,n_lineas, $3)){
                                                      setError("La variable no es de este tipo");
                                                }
                                                semanticError();
                                                }
                                          }

 


            | ID ASIGNATION expr '\n'     {if(!semanticError()){
                                                if(!$3.esReal){
                                                      if(!variables.putVar($1,n_lineas, (int)$3.valor)){
                                                            sprintf(msgMid, "La variable %s es de tipo real y no se le puede asignar un valor entero", $1);
                                                            setError(msgMid);

                                                      }
                                                } else{
                                                      if(!variables.putVar($1,n_lineas, $3.valor)){
                                                            sprintf(msgMid, "La variable %s es de tipo entero y no se le puede asignar un valor real", $1);
                                                            setError(msgMid);
                                                      }
                                                }
                                                semanticError();
                                           } 
                                          }
            ;

exBool:  CIERTO               {$$=true;}
       | FALSO                {$$=false;}
       | NO exBool            {$$=!($2);}
       | exBool OR exBool     {$$= $1||$3;}
       | exBool AND exBool    {$$= $1&&$3;}
       | '(' exBool ')'       {$$=$2;}      
       | exBool EQ exBool     {$$= $1==$3;}
       | exBool DISTINCT exBool    {$$= $1!=$3;}
       | expr EQ expr         {$$= $1.valor==$3.valor;}
       | expr DISTINCT expr   {$$= $1.valor!=$3.valor;}
       | expr '<' expr        {$$= $1.valor<$3.valor;}
       | expr MENEQ expr      {$$=$1.valor<=$3.valor;}
       | expr '>' expr        {$$=$1.valor>$3.valor;}
       | expr MAYEQ expr      {$$=$1.valor>=$3.valor;}
       ;

expr:   ID                   {actual=variables.getVar($1);
                              if (actual.tipo==TERROR){
                                    sprintf(msgMid, "La variable %s no está definida", actual.nombre);
                                    setError(msgMid);
                              }
                              
                              else if(actual.tipo==TENTERO){
                                    $$.esReal=false;
                                    $$.valor=actual.dato.entero;
                              }
                              else if(actual.tipo==TREAL){
                                    $$.esReal=true;
                                    $$.valor=actual.dato.real;
                              } 
                              else if(actual.tipo==TBOOL){
                                    setError("Las variables de tipo lógico no pueden aparecer en la parte derecha de una asignación");
                              } 
                              else if(actual.tipo==TCADENA){
                                    setError("Las variables de tipo cadena no pueden aparecer en la parte derecha de una asignación");
                              } 
                              else{
                                    setError("La variable no es númerica");
                              }
                              }
       | NUMERO 		      {$$.esReal=false;
                              $$.valor=(float)$1;}
      
                              
       | REAL                 {$$.esReal=true;
                              $$.valor=$1;}
	 | '(' expr ')'         {$$=$2;}                         
       | expr '+' expr 		{$$.valor=$1.valor+$3.valor;
                              $$.esReal=$1.esReal||$3.esReal;}              
       | expr '-' expr    	{$$.valor=$1.valor-$3.valor;
                              $$.esReal=$1.esReal||$3.esReal;}               
       | expr '*' expr        {$$.valor=$1.valor*$3.valor;
                              $$.esReal=$1.esReal||$3.esReal;}   
       | expr '/' expr        {
                              if($3.valor==0){
                                    setError("División entre 0");
                              }
                              else{
                                    $$.valor=$1.valor/$3.valor;
                                    $$.esReal=true;}
                              }   
       | expr INTDIV expr       {if (!$1.esReal&&!$3.esReal) {
                                    if($3.valor==0){
                                          setError("División entre 0");
                                    }
                                    else{
                                    $$.valor=(int)$1.valor/(int)$3.valor;
                                    $$.esReal=false;
                                    }
                               }
                               else{
                                    setError("Se usa el operador // con operandos reales");
                               }
                              }   
       | expr '%' expr       {if (!$1.esReal&&!$3.esReal) {
                                    if($3.valor==0){
                                          setError("División entre 0");
                                    }
                                    else{
                                    $$.valor=fmod($1.valor,$3.valor);
                                    $$.esReal=false;
                                    }
                               }
                               else{
                                    setError("Se usa el operador % con operandos reales");
                               }
                              }     
       |'-' expr %prec menos  {$$.valor= -$2.valor;
                               $$.esReal=$2.esReal;}
       ;


%%


int main(int argc, char* argv[]) {
     
     n_lineas = 0;

    if (argc != 2) {
        cout << "Uso: " << argv[0] << " <archivo_entrada>" << endl;
        return 1;
    }

    // Abre el archivo de entrada
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        cout << "No se pudo abrir el archivo de entrada." << endl;
        return 1;
    }
     
     //yylex();
     yyparse();

    // Abre el archivo de salida
    yyout = fopen("salidaAmu.cpp", "w");
    if (!yyout) {
        cout << "No se pudo abrir el archivo de salida." << endl;
        fclose(yyin);
        return 1;
    }
     variables.printVar(yyout);
     //variables.printVar();
     return 0;
}