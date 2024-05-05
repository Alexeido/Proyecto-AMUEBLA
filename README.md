# AMUEBLA: Un lenguaje para amueblar habitaciones

Este proyecto es parte de la asignatura Teoría de Lenguajes y consiste en la construcción de un traductor para un lenguaje llamado AMUEBLA. El objetivo es crear un programa en C++ que, al compilarse y ejecutarse, muestre en pantalla una secuencia de habitaciones con muebles según la definición que aparezca en el fichero de entrada.

## Descripción del proyecto

El traductor para el lenguaje AMUEBLA se estructura en tres módulos principales: el analizador léxico, el analizador sintáctico y el gestor de la tabla de símbolos. El traductor tendrá un único parámetro que será el nombre del fichero de texto de entrada con extensión `.amu`, generando un archivo con extensión `.cpp`.

El proyecto debe cumplir con los siguientes aspectos:

- Detectar errores gramaticales o semánticos y mostrar un mensaje indicando la línea en la que se ha cometido el error.
- Entregar el proyecto con una breve documentación en PDF que preste especial atención al diseño de las estructuras de datos y funciones auxiliares utilizadas en la implementación, así como a cualquier otro aspecto relevante del proyecto.
- En caso de conflictos gramaticales, estos deben explicarse y justificarse en la documentación.
- Valoración en la evaluación del proyecto incluirá la claridad y corrección de la gramática, la eficiencia del código C/C++ y de las estructuras de datos definidas.

## Ampliaciones del proyecto

Se pueden realizar ampliaciones al proyecto para obtener una calificación más alta:

1. **Primera ampliación:** Incluir bucles sin anidación.
2. **Segunda ampliación:** Incluir estructuras de control anidadas (bucles y sentencia si-sino).
3. **Tercera ampliación:** Almacenamiento en una estructura de control auxiliar (se recomienda un árbol) de las expresiones aritméticas y lógicas para que puedan ser evaluadas varias veces.

El proyecto puede ser realizado de forma individual o en pareja.

## Requisitos

Para ejecutar la librería Amuebla, es necesario tener instalada la librería gráfica Allegro 5.

## Ejecución del programa

Para ejecutar el programa, sigue estos pasos:

1. Asegúrate de tener instalada la librería gráfica Allegro 5 en tu sistema.
2. Compila el traductor utilizando el `makefile`.
3. Ejecuta el programa compilado.
4. Proporciona como parámetro el nombre del fichero de texto de entrada con extensión `.amu` y traducirá este fichero a un archivo llamado `salidaAmu.cpp`.

Por ejemplo, si el fichero de entrada se llama `entrada.amu`, puedes ejecutar el programa de la siguiente manera:

```bash
./expresiones entrada.amu
```
Tras esto ejecuta el makeAmuebla con el siguiente comando

```bash
make -f makeAmuebla
```
El programa mostrará en pantalla una secuencia de habitaciones con muebles según la definición que se encuentre en el fichero de entrada.
