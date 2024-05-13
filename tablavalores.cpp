#include "tablavalores.h"
#include <iostream>

vars::vars() {
    total = 0;
    for (int i = 0; i < MAX; i++) {
        valores[i].nombre[0] = '\0';
    }
}


bool vars::putVar(char *name, int valor) {
    bool enc=false;
    bool inserted=false;
    int i=0;
    while(!enc&&i<total){
        if (!strcmp(valores[i].nombre, name)) {
            if(valores[i].tipo!=TENTERO){
        	    enc=true;  //Si la variable existe pero no es un entero no se cambia el valor del mismo
            }
            else{
            valores[i].dato.entero = valor;
            enc=true;  //Si es entero actualizamos el valor del entero 
            inserted=true;
            }
        }
        i++;
    }
    if(!enc){
        strcpy(valores[total].nombre, name);
        valores[total].tipo = TENTERO;
        valores[total].dato.entero = valor;
        total++;
        inserted=true;
    }
    return inserted;
}

bool vars::putVar(char *name, float valor) {
    bool enc=false;
    bool inserted=false;
    int i=0;
    while(!enc&&i<total){
        if (!strcmp(valores[i].nombre, name)) {
            if(valores[i].tipo!=TREAL){
        	    enc=true;  //Si la variable existe pero no es un real no se cambia el valor del mismo
            }
            else{
            valores[i].dato.real = valor;
            enc=true;  //Si es real actualizamos el valor del real 
            inserted=true;
            }
        }
        i++;
    }
    if(!enc){
        strcpy(valores[total].nombre, name);
        valores[total].tipo = TREAL;
        valores[total].dato.real = valor;
        total++;
        inserted=true;
    }
    return inserted;
}

bool vars::putVar(char *name, char *valor) {
    for (int i = 0; i < total; i++) {
        if (!strcmp(valores[i].nombre, name)) {
            if(valores[i].tipo!=TCADENA)
        	    return false;  //Si la variable existe pero no es una cadena no se cambia el valor del mismo
            strcpy(valores[i].dato.cadena, valor);
            return true;  //Si es cadena actualizamos el valor de la cadena 
        }
    }
    strcpy(valores[total].nombre, name);
    valores[total].tipo = TCADENA;
    strcpy(valores[total].dato.cadena, valor);
    total++;
    return true;
}

bool vars::putVar(char *name, bool valor) {
    for (int i = 0; i < total; i++) {
        if (!strcmp(valores[i].nombre, name)) {
            if(valores[i].tipo!=TBOOL)
        	    return false;  //Si la variable existe pero no es una cadena no se cambia el valor del mismo
            valores[i].dato.booleano= valor;
            return true;  //Si es cadena actualizamos el valor de la cadena 
        }
    }
    strcpy(valores[total].nombre, name);
    valores[total].tipo = TBOOL;
    valores[total].dato.booleano= valor;
    total++;
    return true;
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