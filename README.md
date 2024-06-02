# Proyecto AMUEBLA

El proyecto **AMUEBLA** es un traductor diseñado para un lenguaje específico que permite definir plantas de habitaciones utilizando recuadros y círculos para representar muebles. Este traductor toma un programa escrito en el lenguaje AMUEBLA (archivo con extensión `.amu`) y genera un archivo `salidaAmu.cpp` con el resultado traducido.

## Ampliaciones del Proyecto

El proyecto ha sido ampliado con las siguientes funcionalidades:

- **Primera ampliación**: Se han incluido bucles sin anidación.
- **Segunda ampliación**: Se han añadido estructuras de control (bucles y sentencia `si-sino`) anidadas.

Actualmente, el número de anidaciones permitido es 50, aunque se puede modificar cambiando la constante `NUMANIDADOS` en el archivo `expresiones.y`.

## Autores

El proyecto ha sido realizado por:
- Alejandro Barrena Millán
- Elena Barrera Rodrigo

## Contenido

- [Clases Auxiliares](#clases-auxiliares)
- [Funciones Auxiliares](#funciones-auxiliares)

## Clases Auxiliares

Las clases auxiliares proporcionan estructuras y métodos que facilitan la gestión de variables, muebles e instrucciones en el lenguaje AMUEBLA.

### Clase `vars`

La clase `vars` gestiona una tabla de valores de varios tipos (entero, real, booleano, cadena) asegurando su correcta inicialización y manejo de errores. Sus principales métodos incluyen:

- **`decVar`**: Declara variables con o sin valor inicial.
- **`putVar`**: Inserta o actualiza valores de variables existentes.
- **`getVar`**: Obtiene el valor de una variable.
- **`printVar`**: Imprime la tabla de valores en un archivo o en la consola.
- **`copiarVar`**: Copia la tabla de valores de otra instancia de `vars`.

### Clase `mueblesVars`

La clase `mueblesVars` administra una tabla de muebles de distintas formas y colores. Sus principales métodos incluyen:

- **`putMueble`**: Agrega muebles con sus respectivos tamaños y colores.
- **`getMueble`**: Obtiene un mueble por su nombre.
- **`printMuebles`**: Imprime la tabla de muebles en un archivo o en la consola.
- **`copiarMuebles`**: Copia la tabla de muebles de otra instancia de `mueblesVars`.

### Clase `ColaInstrucciones`

La clase `ColaInstrucciones` facilita la gestión de una cola de instrucciones, permitiendo su almacenamiento, impresión y manipulación. Sus principales métodos incluyen:

- **`addInstruccion`**: Añade una instrucción a la cola.
- **`vaciarCola`**: Vacía la cola de instrucciones.
- **`anidarCola`**: Anida otra cola de instrucciones dentro de la cola actual.
- **`printCola`**: Imprime la cola de instrucciones en un archivo, una vez o varias veces.

## Funciones Auxiliares

Estas funciones auxiliares se utilizan en el programa para tareas específicas, tales como comprobaciones de errores semánticos, conversiones de tipos y formateos.

### Manejo de Errores Semánticos

- **`semanticError()`**: Comprueba si hay un error semántico y muestra el mensaje correspondiente.
- **`semanticError(const char *msg)`**: Establece y muestra un mensaje de error semántico.
- **`setError(const char *msg)`**: Establece la bandera de error semántico y almacena el mensaje de error.

### Conversiones de Tipos

- **`toType(int tipo)`**: Convierte un entero en un tipo de variable (`TipoVariable`).
- **`toColor(int color)`**: Convierte un entero en un tipo de color (`colorMueble`).
- **`toForma(int forma)`**: Convierte un entero en un tipo de forma (`formaMueble`).

### Conversión a Cadena

- **`colorToString(colorMueble color)`**: Convierte un tipo de color en su representación en cadena.
- **`floatToString(float value)`**: Convierte un valor flotante a su representación en cadena, eliminando ceros no significativos.

### Impresión de Cabeceras y Pies de Página

- **`printHeader(FILE* yyout)`**: Imprime la cabecera del archivo de salida.
- **`printFooter(FILE* yyout)`**: Imprime el pie de página del archivo de salida.

## Conclusiones

Las clases y funciones auxiliares implementadas en el proyecto AMUEBLA proporcionan una estructura robusta y modular para la gestión de variables, muebles e instrucciones. Estas herramientas permiten una mayor flexibilidad y control en la traducción de programas escritos en el lenguaje AMUEBLA, facilitando su ampliación y mantenimiento.