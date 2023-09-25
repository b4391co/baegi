# Baegi

## Descripción

Baegi es un script de línea de comandos diseñado para simplificar la creación de contenedores Docker, con un enfoque en contenedores LAMP (Linux, Apache, MySQL, PHP) y un contenedor Kali Linux. El script permite crear y configurar fácilmente contenedores Docker para diferentes propósitos.

## Uso

1. Descarga el script `baegi.sh` a tu sistema.

2. Asegúrate de que el script tenga permisos de ejecución. Puedes hacerlo con el siguiente comando:

   ```bash
   chmod +x baegi.sh
   ```

3. Ejecuta el script utilizando el siguiente comando:

   ```bash
   ./baegi.sh
   ```

4. Sigue las instrucciones proporcionadas por el script para seleccionar y configurar el tipo de contenedor que deseas crear.

5. El script te guiará a través de la creación y configuración del contenedor Docker seleccionado.

## Opciones de Contenedor

Baegi actualmente admite dos opciones de contenedor:

- **Container LAMP (docker)**: Crea un contenedor Docker con el entorno LAMP (Linux, Apache, MySQL, PHP). Puedes especificar un directorio para crear la base del proyecto y configurar la carpeta web. También puedes optar por crear una carpeta para MySQL.

- **Container Kali Linux (docker)**: Crea un contenedor Docker con Kali Linux. Te lleva directamente al shell de Kali Linux dentro del contenedor.

## Alias Zsh

El script agrega un alias "baegi" a tu archivo `~/.zshrc` si aún no está presente. Esto facilita la ejecución del script en futuras sesiones de terminal.