# OBJETIVO
Este script, tiene como objetivo simplificar el manejo de contenedores Docker, facilitando la creación y ejecución de contenedores específicos para el desarrollo de aplicaciones web basadas en el stack LAMP (Linux, Apache, MySQL, PHP) y proporcionando una opción para ejecutar un contenedor Kali Linux con todas las herramientas preinstaladas.

# USO

## Uso Básico
Para ejecutar el script y obtener información sobre las opciones disponibles, puedes utilizar el siguiente comando:

```bash
baegi
```

Esto mostrará un menú con las opciones disponibles, incluyendo la creación de contenedores LAMP y la ejecución de un contenedor Kali Linux.

### Crear Contenedor LAMP (Apache y MySQL)

```bash
baegi -lamp
```

Este comando creará y ejecutará un contenedor Docker LAMP que incluye tanto Apache como MySQL. Es necesario que en el directorio actual exista únicamente una carpeta llamada mysql (o se creará automáticamente) y otra carpeta donde se encuentren los archivos para Apache.

### Crear Contenedor LAMP y nueva base de datos (Apache y MySQL)

```bash
baegi -nlamp
```

Este comando creará y ejecutará un contenedor Docker LAMP que incluye tanto Apache como MySQL. Se creará una carpeta mysql en el directorio actual con una base de datos vacía, se mostrará la contraseña al ser creada para poder cambiarla. La próxima vez que quiera ejecutar el mismo directorio simplemente tendrá que usar la instrucción `-lamp`

### Crear Contenedor LAMP (Apache y MongoDB)

```bash
baegi -mlamp
```

Este comando creará y ejecutará un contenedor Docker LAMP que incluye tanto Apache como MongoDB. En este caso los archivos de la web como los de la base de datos deben estar en la misma carpeta, asegurese de establecer bien la conexion a la base de datos con:

```php
(new MongoDB\Client("mongodb://172.20.0.5:27017"))
```

### Crear Contenedor Kali Linux

```bash
baegi -kali
```
Este comando creará y ejecutará un contenedor Docker con todas las herramientas de Kali Linux preinstaladas.

Recuerda que puedes salir del script en cualquier momento escribiendo "X". ¡Espero que este script te resulte útil!


### Crear Contenedor con utilidades Osint

```bash
baegi -osrf 
```

contenedor docker con todas herramientas de Osint.