#ifndef TABLAMUEBLES_H
#define TABLAMUEBLES_H

#include <cstring>
#include <fstream>

#define MAX 100
#define MAXchar 25


enum formaMueble { FRECTANGULO, FCIRCULO, FERROR};
enum colorMueble { CNEGRO, CGRIS, CROJO, CAZUL, CAMARILLO, CVERDE, CMARRON};


struct rectSize {
    float ancho;
    float alto;
};

union muebleSize {
    float radio;
    rectSize rect;
};

struct mueble {
    formaMueble forma;
    colorMueble color;
    muebleSize medida;
    char nombre[MAXchar];
};


/*


Sofa = < rectangulo, cc, 600.0, azul>
Mesa =<circulo, 150.5, marron>
Sillon = <rectangulo, cc, cc, azul>  
Mueble = < rectangulo, 200.0, 800.0, negro>

*/



/**
 * @brief Clase que representa una tabla de muebles.
 * 
 * Esta clase almacena una lista de muebles y proporciona métodos para agregar, obtener y copiar muebles.
 */
class mueblesVars{
private:
    mueble muebles[MAX]; // Array de muebles
    int total; // Total de muebles en la tabla

public:

    /**
     * @brief Constructor de la clase mueblesVars.
     */
    mueblesVars(); 

    /**
     * @brief Agrega un mueble a la tabla.
     * 
     * @param name Nombre del mueble.
     * @param forma Forma del mueble.
     * @param color Color del mueble.
     * @param ancho Ancho del mueble (solo para muebles de forma rectangular).
     * @param alto Alto del mueble (solo para muebles de forma rectangular).
     * @return true si se agrega el mueble correctamente, false en caso contrario.
     */
    bool putMueble(char *name, formaMueble forma, float ancho, float alto, colorMueble color);

    /**
     * @brief Agrega un mueble a la tabla.
     * 
     * @param name Nombre del mueble.
     * @param forma Forma del mueble.
     * @param color Color del mueble.
     * @param radio Radio del mueble (solo para muebles de forma circular).
     * @return true si se agrega el mueble correctamente, false en caso contrario.
     */
    bool putMueble(char *name, formaMueble forma, float radio, colorMueble color);

    /**
     * @brief Obtiene un mueble de la tabla.
     * 
     * @param name Nombre del mueble a obtener.
     * @return El mueble correspondiente al nombre especificado.
     */
    mueble getMueble(char *name);

    /**
     * @brief Imprime los muebles de la tabla en un archivo.
     * 
     * @param yyout Puntero al archivo de salida.
     */
    void printMuebles(FILE* yyout);

    /**
     * @brief Imprime los muebles de la tabla en la consola.
     */
    void printMuebles(); 

    /**
     * @brief Copia los muebles de otra tabla a esta tabla.
     * 
     * @param backup Tabla de muebles de donde se copiarán los muebles.
     */
    void copiarMuebles(mueblesVars backup); 
};

#endif

