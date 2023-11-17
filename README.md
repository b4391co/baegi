# OBJETIVO
Este script, tiene como objetivo simplificar el manejo de contenedores Docker, facilitando la creación y ejecución de contenedores específicos para el desarrollo de aplicaciones web basadas en el stack LAMP (Linux, Apache, MySQL, PHP) y proporcionando una opción para ejecutar un contenedor Kali Linux con todas las herramientas preinstaladas.

# USO

## Uso Básico
Para ejecutar el script y obtener información sobre las opciones disponibles, puedes utilizar el siguiente comando:

```
baegi
```

Esto mostrará un menú con las opciones disponibles, incluyendo la creación de contenedores LAMP y la ejecución de un contenedor Kali Linux.

### Crear Contenedor LAMP (solo Apache)

```
baegi -a
```

Este comando creará y ejecutará un contenedor Docker LAMP que solo incluye Apache. El contenedor utilizará el directorio actual como directorio de trabajo.

### Crear Contenedor LAMP (Apache y MySQL)

```
baegi -as
```

Este comando creará y ejecutará un contenedor Docker LAMP que incluye tanto Apache como MySQL. Es necesario que en el directorio actual exista únicamente una carpeta llamada mysql (o se creará automáticamente) y otra carpeta donde se encuentren los archivos para Apache.

### Crear Contenedor Kali Linux

```
baegi -kali
```
Este comando creará y ejecutará un contenedor Docker con todas las herramientas de Kali Linux preinstaladas.

Recuerda que puedes salir del script en cualquier momento escribiendo "X". ¡Espero que este script te resulte útil!