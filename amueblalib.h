#ifndef AMUEBLALIB_H
#define AMUEBLALIB_H

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
    int fila[MAX];
    int total;

public:
    vars(); // Constructor
    bool putVar(char *name, int fila, int valor);
    bool putVar(char *name, int fila, float valor);
    bool putVar(char *name, int fila, char *valor);
    bool putVar(char *name, int fila, bool valor);
    ValorVariable getVar(char *name);
    void printVar(FILE* yyout);
    void printVar(); 
    void copiarVar(vars backup); 
};

#endif

