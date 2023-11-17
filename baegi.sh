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


function noSelectLamp {
    local app=$1
    local pwd=$(pwd)
    local NombreLamp=$(generarNombre)
    local carpetaLAMP=$pwd
    if [ $(ls -d */ | grep "mysql/"  | wc -l) = 1 ]
    then
        local carpetaFiles=$carpetaLAMP/$(ls -d */ | grep -v "sql")
    else
        local carpetaFiles=$carpetaLAMP
    fi

    if [ "$app" = "a" ]
    then
        f_existe baegilamp
        docker run -i -t --name $NombreLamp -p "80:80" -p "3306:3306" -v $carpetaFiles:/app baegilamp
        docker rm $NombreLamp
        exit
    fi

    if [ "$app" = "as" ]
    then
        f_existe baegilamp
        docker run -i -t --name $NombreLamp -p "80:80" -p "3306:3306" -v $carpetaFiles:/app -v $carpetaLAMP/mysql:/var/lib/mysql baegilamp
        docker rm $NombreLamp
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
        -a)
        app="a"
        shift
        ;;
        -as)
        app="as"
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

noSelectLamp "$app"

while [ $selec = 0 ]
do
    logo
    printf "\n- baegi -a \t contenedor docker lamp sobre el directorio en el que este situado ( solo apache )"
    printf "\n- baegi -as \t contenedor docker lamp sobre el directorio en el que este situado ( apache & sql )"
    printf "\n\t\t es necesario que en la carpeta donde este situado exista unicamente una carpeta mysql (o se ceara automaticamente)"
    printf "\n\t\t y otra donde se enecuentren los archivos para apache"
    printf "\n- baegi -kali \t contenedor docker con todas las herramientas de kali linux"
    printf "\n"
    printf "―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――"
    echo ""
    read app
    T=$app
    if [ $app = "X" ]
    then
        exit
    fi

    noSelectLamp "$app"
done