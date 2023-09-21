pwd=`pwd`
username=`whoami`
selec=0
app=0
t=0
i=0
check=`grep baegi ~/.zshrc | wc -l`

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
    if [ $existe != 1 ]
    then
        logo
        docker pull $1
    fi
}

if [ $check = 0 ]
then
    echo "alias baegi=\"$pwd/baegi.sh\"" >> ~/.zshrc
    echo "Alias 'baegi' agregado a ~/.zshrc"
fi

while [ $selec = 0 ]
do
    logo
    printf "[ + ] ( 1"; if [ $app = '1' ] ; then printf '*'; fi; printf " ) - Container LAMP ( docker ) \n"
    printf "[ + ] ( 2"; if [ $app = '2' ] ; then printf '*'; fi; printf " ) - Container Kali Linux ( docker ) \n"
    printf "[ + ] ( X"; if [ $app = 'X' ] ; then printf '*'; fi; printf " ) - close\n"
    echo ""
    printf "―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――"
    echo ""
    read app
    T=$app
    if [ $app = "X" ]
    then
        exit
    fi
    if [ $app = "1" ]
    then
        f_existe mattrayner/lamp
        logo
        printf "[ + ] Indica un directorio para crear la base  \n"
        printf "[ + ] pe: '~/Documentos', '/home/user/Documentos' , '.' \n"
        echo ""
        printf "―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――"
        echo ""
        read directorioLAMP
        cd $directorioLAMP
        logo
        printf "[ + ] como se llamara el proyecto, se creara la carpeta web \n"
        printf "[ + ] pe: 'web1' '" 
        printf "'N' para trabajar en el anterior directirio' \n"
        echo ""
        printf "―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――"
        echo ""
        read carpetaLAMP
        logo
        printf "[ + ] Crear carpeta de mysql \n"
        printf "[ + ] y/n' \n"
        echo ""
        printf "―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――"
        echo ""
        read yesSQL
        if [ $carpetaLAMP = "N" ] || [ $carpetaLAMP = "n" ]
        then
            carpetaLAMP=$pwd
        fi
        mkdir $carpetaLAMP
        cd $directirioLAMP $carpetaLAMP

        if [ "$yesSQL" = "y" ] || [ "$yesSQL" = "Y" ]
        then
            docker run -i -t --name lamp -p "80:80" -v $carpetaLAMP/app:/app -v $carpetaLAMP/mysql:/var/lib/mysql mattrayner/lamp:latest
            docker rm lamp
            break
        elif [ "$yesSQL" = "N" ] || [ "$yesSQL" = "n" ]
        then
            docker run -i -t --name lamp -p "80:80" -v $carpetaLAMP/app:/app -v  mattrayner/lamp:latest
            docker rm lamp               
            break
        fi
    fi
    if [ $app = "2" ]
    then
        f_existe jasonchaffee/kali-linux
        docker run -it jasonchaffee/kali-linux:latest zsh
        break
    fi
    
done


