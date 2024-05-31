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
    queue<string> colaCopia = cola;

    while (!colaCopia.empty()) {
        string instruccion = colaCopia.front();
        colaCopia.pop();
        fprintf(YYOUT, "%s\n", instruccion.c_str());
    }
}