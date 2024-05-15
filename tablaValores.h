#ifndef TABLAVALORES_H
#define TABLAVALORES_H

#include <cstring>
#include <fstream>

#define MAX 100
#define MAXchar 25

// Definición de tipos de variables posibles
enum TipoVariable {TENTERO, TREAL, TBOOL, TERROR, TCADENA};

union valor{
    int entero;
    float real;
    char cadena[MAXchar];
    bool booleano;
};

struct ValorVariable {
    valor dato;
    bool inicializado;
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

    
    bool decVar(TipoVariable type, char *name);

    int decVar(TipoVariable type, char *name, int valor);
    int decVar(TipoVariable type, char *name, float valor);
    int decVar(TipoVariable type, char *name, char *valor);
    int decVar(TipoVariable type, char *name, bool valor);


    /**
     * @brief Inserta una variable en la tabla de valores.
     * 
     * @param name El nombre de la variable a insertar.
     * @param valor El valor de la variable a insertar.
     * @return int El resultado de la operación, 0= EXITO, -1= ERROR NO DECLARADA, -2= ERROR TIPO DISTINTO.
     */
    int putVar(char *name, int valor);
    int putVar(char *name, float valor);
    int putVar(char *name, char *valor);
    int putVar(char *name, bool valor);

    /**
     * @brief Obtiene el valor de una variable de la tabla de valores.
     * 
     * @param name El nombre de la variable a obtener.
     * @return ValorVariable La variable obtenida.
     */
    ValorVariable getVar(char *name);

    /**
     * @brief Imprime la tabla de valores en un archivo.
     * 
     * @param yyout El archivo en el que se imprimirá la tabla de valores.
     */
    void printVar(FILE* yyout);

    /**
     * @brief Imprime la tabla de valores en la consola.
     */
    void printVar(); 
    
    /**
     * @brief Copia la tabla de valores en otra tabla de valores.
     * 
     * @param backup La tabla de valores a copiar.
     */
    void copiarVar(vars backup); 
};


#endif

