%{
#include <iostream>
#include <cmath>
#include <string>
#include <cstring>
#include <vector>
#include <sstream>
#include "tablaValores.h"
#include "tablaMuebles.h"
#include "colaInstrucciones.h"

using namespace std;

//elementos externos al analizador sintácticos por haber sido declarados en el analizador léxico      			
extern int n_lineas;    			
extern int debug;
extern int yylex();
const int NUMANIDADOS =50;
bool errorSemantico=false;

char msgMid[400];
int errorType;
char msgError[400];
vars variables;
mueblesVars muebles;
vars variablesBackUp;
vector<string> auxiliar;
ValorVariable actual;
mueble mActual;
ColaInstrucciones instrucciones[NUMANIDADOS];
int instruccionActual=0;
bool ejecutarInstruccion[NUMANIDADOS];
int ifActual=0;
bool errorHabitacion=false;
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
string colorToString(colorMueble color) {
    switch(color) {
        case CNEGRO: return "NEGRO";
        case CGRIS: return "GRIS";
        case CROJO: return "ROJO";
        case CAZUL: return "AZUL";
        case CAMARILLO: return "AMARILLO";
        case CVERDE: return "VERDE";
        case CMARRON: return "MARRON";
        default: return "Unknown";
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

//Metodo para que el toString de los floats sea bonitos

string floatToString(float value) {
    ostringstream out;
    out << value;
    string result = out.str();

    // Remover los ceros no significativos y el punto decimal si es necesario
    if (result.find('.') != string::npos) {
        // Eliminar ceros al final
        result.erase(result.find_last_not_of('0') + 1);
        // Si el último carácter es un punto, eliminarlo
        if (result.back() == '.') {
            result.pop_back();
        }
    }

    return result;
}
void printHeader(FILE* yyout){
                  fprintf(yyout,    "// Traducción del lenguaje AMUEBLA\n"
                                    "#include \"amuebla.h\"\n"
                                    "#include <allegro5/allegro5.h>\n"
                                    "\n"
                                    "using namespace std;\n"
                                    "\n"
                                    "int main(int argc, char *argv[]) {\n"
                                    "\t// Se inicia el entorno gráfico\n"
                                    "\tiniciarAmu();\n"
                                    "\tpausaAmu(1.5);\n");
}
void printFooter(FILE* yyout){
                  fprintf(yyout,    "\n\t// Se liberan los recursos del entorno gráfico\n"
                                    "\tterminarAmu();\n"
                                    "\treturn 0;\n"
                                    "}"
                                    );
                              }

%}

%union{
    int   c_entero;
    float c_real;
    char  c_cadena[300];
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
%token <c_cadena> CADENA
%token <c_bool> CIERTO FALSO
%token ASIGNATION NO EQ MENEQ MAYEQ DISTINCT AND OR INTDIV
%token VARIABLES MUEBLES HABITACION FINHABITACION 
%token <c_type> TIPO 
%token <c_color> COLOR
%token <c_forma> FORMA 
%token SITUAR PAUSA MENSAJE REPETIR SI SINO
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

inicio: salto blVariables  blMuebles listaHabitaciones
      | blVariables  blMuebles listaHabitaciones
      ;

//BLOQUE INICIAL DE VARIABLES
blVariables:      
      |     VARIABLES 	salto	listaDeclaraciones 
      ;

listaDeclaraciones:     declaracion 
                  |     listaDeclaraciones declaracion 
                  ;           



declaracion:      TIPO seqIdentificadores salto { 
                  for(int i=0; i<auxiliar.size(); i++){
                        char *name = new char[auxiliar[i].length() + 1];
                        strcpy(name, auxiliar[i].c_str());
                        if(!variables.decVar(toType($1), name)){
                              sprintf(msgMid, "Ya existe una variable con con el nombre %s", name);
                              setError(msgMid);
                        }
                        delete[] name; //Liberamos la memoria del puntero name
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

//BLOQUE DE MUEBLES
blMuebles:      MUEBLES   salto listaMuebles  
      ;

listaMuebles:     listaMuebles defMueble 
            |     defMueble  
            ;      
                  //$1=forma, $4=FORMA, $6=expr, $8=expr, $10=COLOR
defMueble:        NOMBRE '=''<'FORMA','expr','expr','COLOR'>' salto {if(!muebles.putMueble($1, toForma($4), $6.valor, $8.valor, toColor($10))){
                                                                  sprintf(msgMid, "Ya existe un mueble con el nombre %s", $1);
                                                                  setError(msgMid);
                                                                  semanticError();
                                                                  }}
            |     NOMBRE '=''<'FORMA','expr','COLOR'>' salto {if(!muebles.putMueble($1, toForma($4), $6.valor, toColor($8))){
                                                                  sprintf(msgMid, "Ya existe un mueble con el nombre %s", $1);
                                                                  setError(msgMid);
                                                                  semanticError();
                                                            }}
            |     error	salto		{yyerrok;}   
            ;      


//BLOQUE DE HABITACIONES

listaHabitaciones:      listaHabitaciones defHabitacion 
                  |     defHabitacion
                  ;      

defHabitacion:        HABITACION '(' expr ',' expr ')' CADENA ':' salto {if(!$3.esReal&&!$5.esReal){
                                                                              fprintf(yyout,"\n\t// Nueva habitación\n"
                                                                              "\tnuevaHabitacionAmu(%s, %d, %d);\n", $7, (int)$3.valor, (int)$5.valor);
                                                                              instrucciones[0].vaciarCola(); 
                                                                              errorHabitacion=false;
                                                                        }
                                                                        else{
                                                                              setError("Las dimensiones de la habitación deben ser enteras");
                                                                              errorHabitacion=true;
                                                                              semanticError();
                                                                        }
                                                                        }

                                                                        listaInstrucciones FINHABITACION salto {      

                                                                        if(!errorHabitacion){      
                                                                              
                                                                              instrucciones[0].addInstruccion("\t// Pausa final de habitación\n"
                                                                              "\tpausaAmu(1.5);");          
                                                                              instrucciones[0].printCola(yyout); 
                                                                              for(int i=0; i<NUMANIDADOS; i++){//Vaciar las colas de instrucciones anidadas (por si acaso)
                                                                                    instrucciones[i].vaciarCola();
                                                                              }
                                                                              instruccionActual=0; //Reiniciar el contador de instrucciones por si acaso
                                                                              ifActual=0; //Reiniciar la flag if Actual de instrucciones por si acaso
                                                                        }                                                                                        
                                                                        else{
                                                                              for(int i=0; i<NUMANIDADOS; i++){//Vaciar las colas de instrucciones anidadas (por si acaso)
                                                                                    instrucciones[i].vaciarCola();
                                                                              }
                                                                        }
                                                                        }//Comprobar que expr son ints y pasarlos
                                                                        
                  ;

listaInstrucciones:     listaInstrucciones instruccion {semanticError();}
                  |     instruccion  {semanticError();}
                  ;

instruccion:      asignacion salto
            |     SITUAR '(' NOMBRE ',' expr ',' expr ')' salto {if(ejecutarInstruccion[ifActual]&&!errorHabitacion){
                                                                        mActual=muebles.getMueble($3);
                                                                        if(mActual.forma==FERROR){
                                                                              sprintf(msgMid, "El mueble %s no está definido", $3);
                                                                              setError(msgMid);
                                                                        }
                                                                        else if($7.esReal||$5.esReal){
                                                                              setError("Las coordenadas de situar deben ser enteras");
                                                                        }
                                                                        else{
                                                                              if(mActual.forma==FRECTANGULO){
                                                                                    instrucciones[instruccionActual].addInstruccion("\trectanguloAmu(" +to_string((int)$5.valor) + ", " + to_string((int)$7.valor) +", "+ floatToString(mActual.medida.rect.ancho) + ", " + floatToString(mActual.medida.rect.alto)+", "+ colorToString(mActual.color) +");");
                                                                              }
                                                                              else{
                                                                                    instrucciones[instruccionActual].addInstruccion("\tcirculoAmu(" + to_string((int)$5.valor) + ", " + to_string((int)$7.valor) + ", " + floatToString(mActual.medida.radio) + ", " + colorToString(mActual.color) + ");");
                                                                              }
                                                                        }
                                                                        semanticError();
                                                                  }}
            |     PAUSA '(' expr ')' salto            {if(ejecutarInstruccion[ifActual]&&!errorHabitacion){
                                                            instrucciones[instruccionActual].addInstruccion("\tpausaAmu(" + floatToString($3.valor) + ");");}}
            |     MENSAJE '(' CADENA ')' salto        {if(ejecutarInstruccion[ifActual]&&!errorHabitacion){
                                                            instrucciones[instruccionActual].addInstruccion("\t// "+ string($3).erase(0,1));
                                                      }}
            |     REPETIR expr {instruccionActual++; 
                                if($2.esReal){
                                    setError("La instrucción repetir debe ir acompañada de un entero");
                                    semanticError();
                                    }
                              } 
                  '{' salto listaInstrucciones '}' salto {if(ejecutarInstruccion[ifActual]&&!errorHabitacion&&!$2.esReal){
                                                                  for(int i=0; i<$2.valor; i++){
                                                                        instrucciones[instruccionActual-1].anidarCola(instrucciones[instruccionActual]);
                                                                  }
                                                            }
                                                            instrucciones[instruccionActual].vaciarCola();
                                                            instruccionActual--;
                                                            }
            |     SI '(' exBool ')' {ifActual++; 
                                    if(ejecutarInstruccion[ifActual-1]){
                                          ejecutarInstruccion[ifActual]=$3;
                                    }
                                    else{
                                          ejecutarInstruccion[ifActual]=false;
                                    }}
                  '{' salto listaInstrucciones '}' salto sino_opcional {ejecutarInstruccion[ifActual]=true; ifActual--;}
            |     error	salto		{yyerrok;}   
            ;

sino_opcional:   
            |    SINO { if(ejecutarInstruccion[ifActual-1]){
                              ejecutarInstruccion[ifActual]=!ejecutarInstruccion[ifActual];
                        }} '{' salto listaInstrucciones '}' salto
            ;

//Elementos recurrentes

asignacion:   ID ASIGNATION exBool   {if(!semanticError()&&ejecutarInstruccion[ifActual]){
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

            | ID ASIGNATION expr    {if(!semanticError()&&ejecutarInstruccion[ifActual]){
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


salto: '\n' 
      | salto '\n'



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
                              if (actual.tipo==TERROR||!actual.inicializado){
                                    sprintf(msgMid, "La variable %s no está definida", actual.nombre);
                                    cout<<n_lineas<<endl;
                                    //variables.printVar();
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
     
      for(int i=0; i<NUMANIDADOS; i++){
            ejecutarInstruccion[i]=true;
      }
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
    yyout = fopen("salidaAmu.cpp", "w");
    if (!yyout) {
        cout << "No se pudo abrir el archivo de salida." << endl;
        fclose(yyin);
        return 1;
    }

      printHeader(yyout);
     
      yyparse();
      printFooter(yyout);
    // Abre el archivo de salida
     //variables.printVar();
     return 0;
}