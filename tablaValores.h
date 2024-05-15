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


#endif

