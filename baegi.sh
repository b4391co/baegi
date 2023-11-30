pwd=`pwd`
username=`whoami`
baegidir=`grep "baegi" ~/.zshrc | awk -F '=' '{print $2}' | tr -d '"' | xargs dirname`
selec=0
app=0
t=0
i=0

function logo {
clear
echo "██████╗░░█████╗░███████╗░██████╗░██╗"
echo "██╔══██╗██╔══██╗██╔════╝██╔════╝░██║"
echo "██████╦╝███████║█████╗░░██║░░██╗░██║"
echo "██╔══██╗██╔══██║██╔══╝░░██║░░╚██╗██║"
echo "██████╦╝██║░░██║███████╗╚██████╔╝██║"
echo "╚═════╝░╚═╝░░╚═╝╚══════╝░╚═════╝░╚═╝"
echo ""
echo "========================================================================"
echo ""
}

function f_existe {
    existe=$(docker images | grep $1 | wc -l)
    echo $existe
    if [ $existe -eq 0 -a "$1" = "baegilamp" ]
    then
        logo
        cd $baegidir
        cd .config/lampDockerFile
        docker build -t baegilamp .
        cd $pwd
    fi
    if [ $existe -eq 0 -a "$1" != "baegilamp" ]
    then
        logo
        docker pull $1
    fi
}

function generarNombre {
    echo "lamp-"$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 15)
}


function baegi_exec {
    local app=$1
    local pwd=$(pwd)
    local carpetaLAMP=$pwd
    if [ $(ls -d */ | grep -e "db/"  | wc -l) = 1 ] && [ "$app" = "lamp" ] || [ "$app" = "mlamp" ] 
    then
        local carpetaFiles=$carpetaLAMP/$(ls -d */ | grep -v "db/")
        local carpetaDb=$carpetaLAMP/$(ls -d */ | grep "db/")
    else
        local carpetaFiles=$carpetaLAMP
        if [ "$app" = "mlamp" ] 
        then
            local carpetaDb=$carpetaFiles
        elif [ "$app" = "lamp" ] 
        then
            local carpetaDb=/tmp/
        fi
    fi

    if [ "$app" = "lamp" ]
    then
        logo
        cd $baegidir/.config/lampDockerFile
        export APP_VOLUME=$carpetaFiles
        export DB_VOLUME=$carpetaDb
        docker-compose -f docker-compose-mongodb.yml run --rm db bash

        docker rm lampdockerfile-phpmyadmin-1 lampdockerfile-app-1 lampdockerfile-db-1
        rm -rfv ./mysql
        cd $carpetaLAMP
        sudo chown $USER:$USER * -R
        exit
    fi

    if [ "$app" = "mlamp" ]
    then
        logo
        cd $baegidir/.config/lampDockerFile
        export APP_VOLUME=$carpetaFiles
        export DB_VOLUME=$carpetaDb
        docker-compose -f docker-compose-mongodb.yml up
        docker rm lampdockerfile-app-1 lampdockerfile-db-1
        cd $carpetaLAMP
        sudo chown $USER:$USER * -R
        exit
    fi

    if [ "$app" = "nlamp" ]
    then
        logo
        echo "DB-USER: admin"
        echo "BD-PASSWD: QpWBHu9ni0J4"
        echo "Cambiar contraseña!!!"
        echo "========================================================================"
        cp $baegidir/.config/mysql . -r
        cd $baegidir/.config/lampDockerFile
        export APP_VOLUME=$carpetaFiles
        export DB_VOLUME=$carpetaDb
        docker-compose -f docker-compose-mysql.yml up
        docker rm lampdockerfile-phpmyadmin-1 lampdockerfile-app-1 lampdockerfile-db-1
        rm -rfv ./mysql
        cd $carpetaLAMP
        sudo chown $USER:$USER * -R
        exit
    fi

    if [ $app = "kali" ]
    then
        f_existe jasonchaffee/kali-linux
        docker run -it jasonchaffee/kali-linux:latest zsh
        break
    fi
}


check_zsh=$(grep baegi ~/.zshrc | wc -l)
check_bash=$(grep baegi ~/.bashrc | wc -l)

if [ $check_zsh -eq 0 ] && [ $check_bash -eq 0 ]
then
    echo "alias baegi=\"$PWD/baegi.sh\"" >> ~/.zshrc
    echo "alias baegi=\"$PWD/baegi.sh\"" >> ~/.bashrc
elif [ $check_zsh -eq 0 ]
then
    echo "alias baegi=\"$PWD/baegi.sh\"" >> ~/.zshrc
    echo "Alias 'baegi' agregado a ~/.zshrc"
elif [ $check_bash -eq 0 ]
then
    echo "alias baegi=\"$PWD/baegi.sh\"" >> ~/.bashrc
    echo "Alias 'baegi' agregado a ~/.bashrc"
fi


while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -lamp)
        app="lamp"
        shift
        ;;
        -mlamp)
        app="mlamp"
        shift
        ;;
        -nlamp)
        app="nlamp"
        shift
        ;;
        -kali)
        app="kali"
        shift
        ;;
        *)    # default case
        shift
        ;;
    esac
done

baegi_exec "$app"

while [ $selec = 0 ]
do
    logo
    printf "\n- baegi -lamp \t contenedor docker lamp sobre el directorio en el que este situado"
    printf "\n- baegi -nlamp \t (new lamp) crea una carpeta ./mysql en el directorio acutal para que lamp la pueda utilizar"
    printf "\n\t\t es necesario que en la carpeta donde este situado exista unicamente una carpeta mysql (o se ceara automaticamente)"
    printf "\n\t\t y otra donde se enecuentren los archivos para apache"
    printf "\n- baegi -kali \t contenedor docker con todas las herramientas de kali linux"
    printf "\n"
    printf "========================================================================"
    echo ""
    read app
    T=$app
    if [ $app = "X" ]
    then
        exit
    fi

    baegi_exec "$app"
done