%{
#include <iostream>
#include <cmath>
#include <string>
#include <cstring>
#include <vector>
#include "tablaValores.h"
#include "tablaMuebles.h"

using namespace std;

//elementos externos al analizador sintácticos por haber sido declarados en el analizador léxico      			
extern int n_lineas;    			
extern int debug;
extern int yylex();
bool errorSemantico=false;

char msgMid[400];
int errorType;
char msgError[400];
vars variables;
vars variablesBackUp;
vector<string> auxiliar;
TipoVariable tipoActual=TERROR;
ValorVariable actual;
extern FILE* yyin;
extern FILE* yyout;
//definición de procedimientos auxiliares
void yyerror(const char* s){         /*    llamada por cada error sintactico de yacc */
	
      if(true)
        cout << "Error sintáctico en la instrucción "<< n_lineas+1<<endl;
      errorSemantico=false;	
      auxiliar.clear();
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




TipoVariable toType(int tipo){
    switch (tipo)
    {
    case 0:
        return TENTERO;
    case 1:
        return TREAL;
    case 2:
        return TBOOL;
    case 3:
        return TCADENA;
    default:
        return TERROR;
    }

}

colorMueble toColor(int color){
    switch (color)
    {
    case 0:
        return CNEGRO;
    case 1:
        return CGRIS;
    case 2:
        return CROJO;
    case 3:
        return CAZUL;
    case 4:
        return CAMARILLO;
    case 5:
        return CVERDE;
    case 6:
        return CMARRON;
    default:
        return CNEGRO;
    }
}

formaMueble toForma(int forma){
    switch (forma)
    {
    case 0:
        return FRECTANGULO;
    case 1:
        return FCIRCULO;
    default:
        return FRECTANGULO;
    }
}



%}

%union{
    int   c_entero;
    float c_real;
    char  c_cadena[20];
    char*  c_string; // Cambiado de char* a string
      bool  c_bool;
      struct {
            float valor;
            bool esReal;
      } c_expresion;
    int c_type;
    int c_color;
    int c_forma;
}

%start inicio
%token <c_entero> NUMERO
%token <c_real> REAL  
%token <c_cadena> ID NOMBRE
%token <c_string> CADENA
%token <c_bool> CIERTO FALSO
%token ASIGNATION SALIR NO EQ MENEQ MAYEQ DISTINCT AND OR INTDIV
%token VARIABLES MUEBLES HABITACION FINHABITACION 
%token <c_type> TIPO 
%token <c_color> COLOR
%token <c_forma> FORMA 
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

salto: '\n' 
      | salto '\n'

inicio: salto blVariables  blMuebles
      | blVariables  blMuebles
      ;

      blVariables:      
                  |     VARIABLES 	salto	listaDeclaraciones  {cout<<"VariaAAbles"<<endl; variables.printVar();}
                  ;

            listaDeclaraciones:
                             declaracion 
                        |     listaDeclaraciones declaracion 
                        ;           



                  declaracion:      TIPO seqIdentificadores salto { 
                        for(int i=0; i<auxiliar.size(); i++){
                              char *name = new char[auxiliar[i].length() + 1];
                              std::strcpy(name, auxiliar[i].c_str());
                              if(!variables.decVar(toType($1), name)){
                                    sprintf(msgMid, "Ya existe una variable con con el nombre %s", name);
                                    setError(msgMid);
                              }
                              delete[] name;
                              semanticError();
                        }
                        auxiliar.clear();
                  }
                  |     asignacion salto
                  |     declarar   salto		
                  ;      
                  
                        seqIdentificadores: ID {auxiliar.push_back($1);}
                                          | seqIdentificadores ',' ID {auxiliar.push_back($3);}
                                          ;

      blMuebles:      MUEBLES   salto listaMuebles  
            ;

            listaMuebles:
                                   listaMuebles defMueble 
                              |     defMueble  
                              ;      

                  defMueble:        NOMBRE '=''<'FORMA','expr','expr','COLOR'>' salto {}
                              |     NOMBRE '=''<'FORMA','expr','COLOR'>' salto {}
                              |     error	salto		{yyerrok;}   
                              ;      



asignacion:   ID ASIGNATION exBool   {if(!semanticError()){
                                                errorType=variables.putVar($1, $3);
                                                if(errorType==-2){
                                                      sprintf(msgMid, "La variable %s es de tipo Booleano y no se le puede asignar este valor", $1);
                                                      setError(msgMid);
                                                }
                                                if(errorType==-1){
                                                      sprintf(msgMid, "La variable %s no está declarada", $1);
                                                      setError(msgMid);
                                                }
                                                semanticError();
                                                }
                                          }

 


            | ID ASIGNATION expr    {if(!semanticError()){
                                                if(!$3.esReal){
                                                      errorType=variables.putVar($1, (int)$3.valor);
                                                      if(errorType==-2){
                                                            sprintf(msgMid, "La variable %s es de tipo real y no se le puede asignar un valor entero", $1);
                                                            setError(msgMid);

                                                      }
                                                } else{
                                                      errorType=variables.putVar($1, $3.valor);
                                                      if(errorType==-2){
                                                            sprintf(msgMid, "La variable %s es de tipo entero y no se le puede asignar un valor real", $1);
                                                            setError(msgMid);
                                                      }
                                                }
                                                if(errorType==-1){
                                                      sprintf(msgMid, "La variable %s no está declarada", $1);
                                                      setError(msgMid);
                                                }
                                                semanticError();
                                           } 
                                          }
      ;

declarar:   TIPO ID ASIGNATION expr      {if(!semanticError()){
                                                if(!$4.esReal){
                                                      errorType=variables.decVar(toType($1),$2, (int)$4.valor);
                                                      if(errorType==-2){
                                                            sprintf(msgMid, "A la variable %s no se le puede asignar un entero", $2);
                                                            setError(msgMid);
                                                      }
                                                } else{
                                                      errorType=variables.decVar(toType($1),$2, $4.valor);
                                                      if(errorType==-2){
                                                            sprintf(msgMid, "A la variable %s no se le puede asignar un real", $2);
                                                            setError(msgMid);
                                                      }
                                                }
                                                if(errorType==-1){
                                                      sprintf(msgMid, "Ya existe una variable con con el nombre %s", $2);
                                                      setError(msgMid);
                                                }
                                                semanticError();
                                           } 
                                          }
            | TIPO ID ASIGNATION exBool      {if(!semanticError()){
                                                      cout<<"asignacion de tipo booleano"<<endl;
                                                      errorType=variables.decVar(toType($1),$2, $4);
                                                      if(errorType==-2){
                                                            sprintf(msgMid, "A la variable %s no se le puede asignar un tipo Booleano", $2);
                                                            setError(msgMid);
                                                      }
                                                      if(errorType==-1){
                                                            sprintf(msgMid, "La variable %s no está declarada", $2);
                                                            setError(msgMid);
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
                                    //variables.printVar();
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