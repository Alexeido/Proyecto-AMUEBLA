#include "tablaMuebles.h"
#include <iostream>

mueblesVars::mueblesVars() {
    total = 0;
    for (int i = 0; i < MAX; i++) {
        muebles[i].nombre[0] = '\0';
    }
}

bool mueblesVars::putMueble(char *name, formaMueble forma, float ancho, float alto, colorMueble color) {
    bool enc=false;
    bool inserted=false;
    int i=0;
    if(forma==FCIRCULO){
        return false;
    }
    while(!enc&&i<total){
        if (!strcmp(muebles[i].nombre, name)) {
            enc=true;  
        }
        i++;
    }
    if(!enc){
        strcpy(muebles[total].nombre, name);
        muebles[total].forma = forma;
        muebles[total].color = color;
        muebles[total].medida.rect.ancho = ancho;
        muebles[total].medida.rect.alto = alto;
        total++;
        inserted=true;
    }
    return inserted;
}

bool mueblesVars::putMueble(char *name, formaMueble forma, float radio, colorMueble color) {
    bool enc=false;
    bool inserted=false;
    int i=0;
    if(forma==FRECTANGULO){
        return false;
    }
    while(!enc&&i<total){
        if (!strcmp(muebles[i].nombre, name)) {
            enc=true;  
        }
        i++;
    }
    if(!enc){
        strcpy(muebles[total].nombre, name);
        muebles[total].forma = forma;
        muebles[total].color = color;
        muebles[total].medida.radio = radio;
        total++;
        inserted=true;
    }
    return inserted;
}

mueble mueblesVars::getMueble(char *name) {
    for (int i = 0; i < total; i++) {
        if (!strcmp(muebles[i].nombre, name)) {
            return muebles[i];
        }
    }
    mueble error;
    error.forma = FERROR;
    // Return a default mueble if not found
    return mueble();
}

void mueblesVars::printMuebles(FILE* yyout) {
    fprintf(yyout, "\033[35mTabla de muebles:\033[0m\n");
    for (int i = 0; i < total; i++) {
        switch (muebles[i].forma)
        {
        case FRECTANGULO:
            if (strlen(muebles[i].nombre) >= 7) { //Cuando el nombre mide mas de 7 caracteres un doble tabulado es demasiado y descoloca la salida
                fprintf(yyout, "\033[32m%s:\033[0m\trectángulo\t%f\t%f\n", muebles[i].nombre, muebles[i].medida.rect.ancho, muebles[i].medida.rect.alto);
            }
            else{
                fprintf(yyout, "\033[32m%s:\033[0m\t\trectángulo\t%f\t%f\n", muebles[i].nombre, muebles[i].medida.rect.ancho, muebles[i].medida.rect.alto);
            }
            break;
        case FCIRCULO:
            if (strlen(muebles[i].nombre) >= 7) { //Cuando el nombre mide mas de 7 caracteres un doble tabulado es demasiado y descoloca la salida
                fprintf(yyout, "\033[32m%s:\033[0m\tcírculo\t\t%f\n", muebles[i].nombre, muebles[i].medida.radio);
            }
            else{
                fprintf(yyout, "\033[32m%s:\033[0m\t\tcírculo\t\t%f\n", muebles[i].nombre, muebles[i].medida.radio);
            }
            break;
        
        default:
            break;
        }
        // Add more print statements for other mueble properties
    }
}

void mueblesVars::printMuebles() {
    printMuebles(stdout);
}

void mueblesVars::copiarMuebles(mueblesVars backup) {
    total = backup.total;
    for (int i = 0; i < total; i++) {
        muebles[i] = backup.muebles[i];
    }
}