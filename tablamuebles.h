#ifndef TABLAMUEBLES_H
#define TABLAMUEBLES_H

#include <cstring>
#include <fstream>

#define MAX 100
#define MAXchar 25

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
    void copiarMuebles(mueblesVars backup); 
};

#endif

