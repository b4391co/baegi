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
echo "[ + ] Install YAY Paru(s/N)"
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
    mkdir ~/Descargas
    cd ~/Descargas
    sudo pacman -S --needed base-devel --noconfirm
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd $pwd
fi
echo ""
echo ""
echo "[ + ] Install Basics (s/N)"
echo ""
read yesno
if [ $yesno = "s" ]
then
    sudo pacman -S neovim kitty net-tools --noconfirm
    sudo pacman -S rclone openresolv systemd-resolvconf --noconfirm
    sudo pacman -S neofetch sshfs vifm curl htop wget neofetch tree fzf python-pip npm ranger ueberzug ripgrep fd universal-ctags --noconfirm
    yay flameshot
    yay wireguard-tools
    sudo systemctl enable --now systemd-resolved.service
    mkdir ~/.config/kitty
    cp .config/kitty/kitty.conf ~/.config/kitty
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
fi
fi
echo ""
echo ""
echo "[ + ] Install Fonts (s/N)"
echo ""
read yesno
if [ $yesno = "s" ]
then
    yay victor ttf --noconfirm
    yay hack nerd font --noconfirm
    yay fonts-powerline
    yay iosevka ttf
    yay font-manager
    mkdir /usr/local/share/fonts
    cd /usr/local/share/fonts
    sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
    sudo unzip Hack.zip
    sudo wget https://rubjo.github.io/victor-mono/VictorMonoAll.zip
	sudo unzip VictorMonoAll.zip
    sudo mv VictorMonoAll/TTF/* .
    cd $pwd
fi
echo ""
echo ""
echo "[ + ] Install Awesome dependences[paru] (s/N)"
echo ""
read yesno
if [ $yesno = "s" ]
then
    paru -S awesome-git
    paru -Sy picom-git wezterm rofi acpi acpid acpi_call upower lxappearance-gtk3 \
    jq inotify-tools polkit-gnome xdotool xclip gpick ffmpeg blueman redshift \
    pipewire pipewire-alsa pipewire-pulse alsa-utils brightnessctl feh maim \
    mpv mpd mpc mpdris2 python-mutagen ncmpcpp playerctl --needed
    
    # Instalador
    sudo systemctl enable --now mpd.service
    sudo pacman -S polybar nitrogen --noconfirm
    
    # Copias
    cp -r ./polybar ~/.config
    cp picom.conf ~/.config
    
    # Lock
    yay i3lock-color

    #Rofi
    mkdir -p ~/.config/rofi/themes/
    git clone https://github.com/lr-tech/rofi-themes-collection.git
    cd rofi-themes-collection
    mkdir ~/.config/rofi
    mkdir ~/.config/rofi/themes/
    cp themes/* ~/.config/rofi/themes/
    cd ..
    rm -rfv rofi-themes-collection
fi
echo ""
echo ""
echo "[ + ] Install zsh, omzsh (s/N)"
echo ""
read yesno
if [ $yesno = "s" ]
then
    cd $pwd
    sudo pacman -S zsh
    sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
    cp p10k.zsh ~/.p10k.zsh
    cp zshrc ~/.zshrc
    yay -S --noconfirm zsh-theme-powerlevel10k-git
    echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
    sudo pacman -S powerline-common awesome-terminal-fonts
    yay -S --noconfirm ttf-meslo-nerd-font-powerlevel10k
    sed -i "s/username/$username/g" ~/.zshrc
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ~/.zsh/zsh-autocomplete
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
    wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh -P ~/.zsh
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



