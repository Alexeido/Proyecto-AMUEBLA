#include "colaInstrucciones.h"

ColaInstrucciones::ColaInstrucciones() {
    while (!cola.empty()) {
        cola.pop();
    }
}

void ColaInstrucciones::addInstruccion(const string& instruccion) {
    if (cola.size() < capacidadMaxima) {
        cola.push(instruccion);
    } else {
        cout << "La cola está llena. No se puede agregar más instrucciones." << endl;
    }
}

void ColaInstrucciones::vaciarCola() {
    while (!cola.empty()) {
        cola.pop();
    }
}

void ColaInstrucciones::printCola(FILE* YYOUT) {

    while (!cola.empty()) {
        string instruccion = cola.front();
        cola.pop();
        fprintf(YYOUT, "%s\n", instruccion.c_str());
    }
}

void ColaInstrucciones::printCola(FILE* YYOUT, int n) {
    for(int i = 0; i < n; i++) {
        queue<string> colaCopia = cola;
        while (!colaCopia.empty()) {
            string instruccion = colaCopia.front();
            colaCopia.pop();
            fprintf(YYOUT, "%s\n", instruccion.c_str());
        }
    }
}

void ColaInstrucciones::anidarCola(ColaInstrucciones hijo) {
    ColaInstrucciones colaInstrucciones = hijo;
    while (!colaInstrucciones.cola.empty()) {
        string instruccion = colaInstrucciones.cola.front();
        colaInstrucciones.cola.pop();
        cola.push(instruccion);
    }
}