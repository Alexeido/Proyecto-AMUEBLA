#ifndef TABLAVALORES_H
#define TABLAVALORES_H

#include <cstring>
#include <fstream>

#define MAX 100
#define MAXchar 25

// Definición de tipos de variables posibles
enum TipoVariable { TENTERO, TREAL, TCADENA, TBOOL, TERROR };

union valor{
    int entero;
    float real;
    char cadena[MAXchar];
    bool booleano;
};

struct ValorVariable {
    valor dato;
    TipoVariable tipo;
    char nombre[MAXchar];
};
    
using namespace std; // Incluir el espacio de nombres std

class vars {

private: 
    ValorVariable valores[MAX];
    int total;

public:
    vars(); // Constructor
    bool putVar(char *name, int valor);
    bool putVar(char *name, float valor);
    bool putVar(char *name, char *valor);
    bool putVar(char *name, bool valor);
    ValorVariable getVar(char *name);
    void printVar(FILE* yyout);
    void printVar(); 
    void copiarVar(vars backup); 
};


/*


Sofa = < rectangulo, cc, 600.0, azul>
Mesa =<circulo, 150.5, marron>
Sillon = <rectangulo, cc, cc, azul>  
Mueble = < rectangulo, 200.0, 800.0, negro>

*/


enum formaMueble { FRECTANGULO, FCIRCULO};
enum colorMueble { CNEGRO, CGRIS, CROJO, CAZUL, CAMARILLO, CVERDE, CMARRON};

struct sizes{
    float radio;
    float ancho;
    float alto;
};

struct mueble {
    formaMueble forma;
    colorMueble color;
    sizes medida;
    char nombre[MAXchar];
};

class mueblesVars{
private:
    mueble muebles[MAX];
    int total;

public:
    mueblesVars(); // Constructor
    bool putMueble(char *name, formaMueble forma, colorMueble color, float ancho, float alto);
    bool putMueble(char *name, formaMueble forma, colorMueble color, float radio);
    mueble getMueble(char *name);
    void printMuebles(FILE* yyout);
    void printMuebles(); 
    void copiarMuebles(vars backup); 
};

#endif

