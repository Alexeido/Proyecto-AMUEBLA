// Traducción del lenguaje AMUEBLA
#include "amuebla.h"
#include <allegro5/allegro5.h>

using namespace std;

int main(int argc, char *argv[]) {
	// Se inicia el entorno gráfico
	iniciarAmu();
	pausaAmu(1.5);

 	// Nueva habitación
	nuevaHabitacionAmu("PRIMERA habitación", 100, 100);
	// Pausa final de habitación
	pausaAmu(1.5);

 	// Nueva habitación
	nuevaHabitacionAmu("SEGUNDA habitación", 200, 200);
	// Pausa final de habitación
	pausaAmu(1.5);

	// Se liberan los recursos del entorno gráfico
	terminarAmu();
	return 0;
}
