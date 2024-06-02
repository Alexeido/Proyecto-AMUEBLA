
#ifndef COLAINSTRUCCIONES_H
#define COLAINSTRUCCIONES_H

#include <iostream>
#include <queue>
#include <string>

using namespace std;

class ColaInstrucciones {
private:
    queue<string> cola;
    const int capacidadMaxima = 2000;

public:
    ColaInstrucciones();
    
    void addInstruccion(const string& instruccion);

    void vaciarCola();
    void anidarCola(ColaInstrucciones colaInstrucciones);
    void printCola(FILE* YYOUT);
    void printCola(FILE* YYOUT, int n);
};
#endif