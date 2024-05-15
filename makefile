#Trabajo realizado por:
#Alejandro Barrena Millán
#Elena Barrera Rodrigo

all: expresiones

OBJ = expresiones.o lexico.o tablaValores.o tablaMuebles.o

expresiones : $(OBJ)     				#segunda fase de la traducción. Generación del código ejecutable 
	g++ -oexpresiones $(OBJ)
	./expresiones ./entrada.amu
#make -f makeAmuebla
#rm ./expresiones

expresiones.o : expresiones.c        	#primera fase de la traducción del analizador sintáctico
	g++ -c -Wno-deprecated -oexpresiones.o  expresiones.c 
	
lexico.o : lex.yy.c						#primera fase de la traducción del analizador léxico
	g++ -c -Wno-deprecated -olexico.o  lex.yy.c 	

expresiones.c : expresiones.y       	#obtenemos el analizador sintáctico en C
	bison -d -v -oexpresiones.c expresiones.y

tablaMuebles.o : tablaMuebles.cpp                # Compilar tablaMuebles.cpp
	g++ -c -Wno-deprecated -o tablaMuebles.o tablaMuebles.cpp

tablaValores.o : tablaValores.cpp                # Compilar tablaValores.cpp
	g++ -c -Wno-deprecated -o tablaValores.o tablaValores.cpp

lex.yy.c: lexico.l						#obtenemos el analizador léxico en C
	flex lexico.l

clean : 
	rm  -f  *.c *.o 
	rm -f basica.cpp expresiones expresiones.c expresiones.h expresiones.output lex.yy.c salida.txt salidaAmu.cpp
