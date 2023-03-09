pwd=`pwd`
username=`whoami`

echo ""
echo ""
echo "[ + ] ( 1 ) - Instalacion en REAL"
echo "[ + ] ( 2 ) - Instalacion em VM"
echo ""

read var_opcion

echo ""
echo ""
echo "[ + ] Install YAY (s/N)"
echo ""
read yesno
if [ $yesno = "s" ]
then
    cd /opt
    sudo git clone https://aur.archlinux.org/yay-git.git
    sudo chown -R $username:$username ./yay-git
    cd yay-git
    makepkg -si
    sudo yay -Syu
fi
echo ""
echo ""
echo "[ + ] Install VSCode (s/N)"
echo ""
read yesno
if [ $yesno = "s" ]
then
    cd ~/Downloads
    git clone https://AUR.archlinux.org/visual-studio-code-bin.git
    cd visual-studio-code-bin/
    makepkg -s
    sudo pacman -U visual-studio-code-bin-*.tar*
fi



