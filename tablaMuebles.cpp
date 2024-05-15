#include "tablaMuebles.h"
#include <iostream>

mueblesVars::mueblesVars() {
    total = 0;
    for (int i = 0; i < MAX; i++) {
        muebles[i].nombre[0] = '\0';
    }
}

bool mueblesVars::putMueble(char *name, formaMueble forma, colorMueble color, float ancho, float alto) {
    bool enc=false;
    bool inserted=false;
    int i=0;
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

bool mueblesVars::putMueble(char *name, formaMueble forma, colorMueble color, float radio) {
    bool enc=false;
    bool inserted=false;
    int i=0;
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
    // Return a default mueble if not found
    return mueble();
}

void mueblesVars::printMuebles(FILE* yyout) {
    for (int i = 0; i < total; i++) {
        fprintf(yyout, "Mueble: %s\n", muebles[i].nombre);
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