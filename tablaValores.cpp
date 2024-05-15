#include "tablaValores.h"
#include <iostream>

vars::vars() {
    total = 0;
    for (int i = 0; i < MAX; i++) {
        valores[i].nombre[0] = '\0';
    }
}

bool vars::decVar(TipoVariable type, char *name) {
    for (int i = 0; i < total; i++) {
        if (!strcmp(valores[i].nombre, name)) {
            return false;  // If the variable already exists, return false
        }
    }
    // If the variable does not exist, declare it
    strcpy(valores[total].nombre, name);
    valores[total].tipo = type;
    valores[total].inicializado = false;
    total++;
    return true;
}

int vars::decVar(TipoVariable type, char *name, int valor) {
    if(type != TENTERO) return -2; // Si el tipo no es entero devolvemos -2
    for (int i = 0; i < total; i++) {
        if (!strcmp(valores[i].nombre, name)) {
            return -1;  // Si la variable ya existe devolvemos -1
        }
    }
    // Si la variable no existe en la tabla de valores la creamos y la inicializamos
    strcpy(valores[total].nombre, name);
    valores[total].tipo = type;
    valores[total].dato.entero = valor;
    valores[total].inicializado = true;
    total++;
    return 0;
}

int vars::decVar(TipoVariable type, char *name, float valor) {
    if(type != TREAL) return -2; // Si el tipo no es real devolvemos -2
    for (int i = 0; i < total; i++) {
        if (!strcmp(valores[i].nombre, name)) {
            return -1;  // Si la variable ya existe devolvemos -1
        }
    }
    // Si la variable no existe en la tabla de valores la creamos y la inicializamos
    strcpy(valores[total].nombre, name);
    valores[total].tipo = type;
    valores[total].dato.real = valor;
    valores[total].inicializado = true;
    total++;
    return 0;
}

int vars::decVar(TipoVariable type, char *name, char *valor) {
    if(type != TCADENA) return -2;  // Si el tipo no es cadena devolvemos -2
    for (int i = 0; i < total; i++) {
        if (!strcmp(valores[i].nombre, name)) {
            return -1;  // Si la variable ya existe devolvemos -1
        }
    }
    // Si la variable no existe en la tabla de valores la creamos y la inicializamos
    strcpy(valores[total].nombre, name);
    valores[total].tipo = type;
    strcpy(valores[total].dato.cadena, valor);
    valores[total].inicializado = true;
    total++;
    return 0;
}

int vars::decVar(TipoVariable type, char *name, bool valor) {
    if(type != TBOOL) return -2; // Si el tipo no es booleano devolvemos -2
    for (int i = 0; i < total; i++) {
        if (!strcmp(valores[i].nombre, name)) {
            return -1;  // Si la variable ya existe devolvemos -1
        }
    }
    // Si la variable no existe en la tabla de valores la creamos y la inicializamos
    strcpy(valores[total].nombre, name);
    valores[total].tipo = type;
    valores[total].dato.booleano = valor;
    valores[total].inicializado = true;
    total++;
    return 0;
}

int vars::putVar(char *name, int valor) {
    int enc=false;
    int i=0;
    while(!enc&&i<total){
        if (!strcmp(valores[i].nombre, name)) {
            if(valores[i].tipo!=TENTERO){
                return -2;  //Si la variable existe pero no es un entero no se cambia el valor del mismo
            }
            else{
            valores[i].dato.entero = valor;
            return 0;  //Si es entero actualizamos el valor del entero 
            }
        }
        i++;
    }
    return -1;
}

int vars::putVar(char *name, float valor) {
    int enc=false;
    int i=0;
    while(!enc&&i<total){
        if (!strcmp(valores[i].nombre, name)) {
            if(valores[i].tipo!=TREAL){
                return -2;  //Si la variable existe pero no es un real no se cambia el valor del mismo
            }
            else{
            valores[i].dato.real = valor;
            return 0;  //Si es real actualizamos el valor del real 
            }
        }
        i++;
    }
    return -1;
}

int vars::putVar(char *name, char *valor) {
    for (int i = 0; i < total; i++) {
        if (!strcmp(valores[i].nombre, name)) {
            if(valores[i].tipo!=TCADENA)
                return -2;  //Si la variable existe pero no es una cadena no se cambia el valor del mismo
            strcpy(valores[i].dato.cadena, valor);
            return 0;  //Si es cadena actualizamos el valor de la cadena 
        }
    }
    return -1;
}

int vars::putVar(char *name, bool valor) {
    for (int i = 0; i < total; i++) {
        if (!strcmp(valores[i].nombre, name)) {
            if(valores[i].tipo!=TBOOL)
                return -2;  //Si la variable existe pero no es una cadena no se cambia el valor del mismo
            valores[i].dato.booleano= valor;
            return 0;  //Si es cadena actualizamos el valor de la cadena 
        }
    }
    return -1;
}
ValorVariable vars::getVar(char *name){
    ValorVariable vacio;
    vacio.tipo=TERROR;
    strcpy(vacio.nombre,name);
    bool enc=false;
    int i=0;
    while(!enc&&i<total){
        if (!strcmp(valores[i].nombre, name)) {
            vacio.tipo=valores[i].tipo;
            strcpy(vacio.nombre,valores[i].nombre);
            vacio.dato=valores[i].dato;
            enc=true;
        }
        i++;
    }
    return vacio;
}


void vars::printVar(FILE* yyout) {
    fprintf(yyout,"Tabla de símbolos:\n");
    for (int i = 0; i < total; i++) {
        switch(valores[i].tipo){
            case TENTERO:
                fprintf(yyout,"%s\tentero\t%d\n", valores[i].nombre , valores[i].dato.entero);
                break;
            case TREAL:
                fprintf(yyout,"%s\treal\t%f\n", valores[i].nombre , valores[i].dato.real);
                break;
            case TBOOL:
                if (valores[i].dato.booleano) {
                    fprintf(yyout, "%s\tlógico\tcierto\n", valores[i].nombre);
                } else {
                    fprintf(yyout, "%s\tlógico\tfalso\n", valores[i].nombre);
                }
                break;
            default:
            break;
        }
    }
    fprintf(yyout,"\n");
}


void vars::printVar() {
    cout << "Tabla de símbolos:\t "<<total<<endl;
    for (int i = 0; i < total; i++) {
        switch(valores[i].tipo){
            case TENTERO:
                cout << valores[i].nombre << "\tentero\t" << valores[i].dato.entero<< "\t";
                break;
            case TREAL:
                cout << valores[i].nombre << "\treal\t" << valores[i].dato.real << "\t";
                break;
            case TBOOL:
                if (valores[i].dato.booleano) {
                    cout << valores[i].nombre << "\tlógico\tcierto" << "\t";
                } else {
                    cout << valores[i].nombre << "\tlógico\tfalso" << "\t";
                }
                break;
            default:
                break;
        }
    }
    cout << endl;
}



void vars::copiarVar(vars backup) {
    total = backup.total;
    for (int i = 0; i < MAX; i++) {
        strcpy(valores[i].nombre,backup.valores[i].nombre);
        valores[i].tipo = backup.valores[i].tipo;
        valores[i].dato.real = backup.valores[i].dato.real;
    }
}