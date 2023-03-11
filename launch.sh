pwd=`pwd`
username=`whoami`
selec=0
while [ $selec = 0 ]
do
echo ""
echo ""
echo "[ + ] ( 1 ) - Instalacion Apps"
echo "[ + ] ( 2 ) - Instalacion Entorno"
echo "[ + ] ( X ) - Close"
echo ""
read selec

    while [ $selec = "1" ]
    do
        echo ""
        echo ""
        echo "[ + ] ( 1 ) - Yay & Paru"
        echo "[ + ] ( 2 ) - apps basicas [yay]"
        echo "[ + ] ( 3 ) - Install zsh, omzsh"
        echo "[ + ] ( 4 ) - vscode"
        echo "[ + ] ( T ) - All"
        echo "[ + ] ( X ) - close"
        echo ""
        read app
        if [ $app = "1" ]
        then
            cd $pwd
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
        if [ $app = "2" ]
        then
            cd $pwd
            echo ""
            echo ""
            echo "[ + ] ( 1 ) - Instalacion en REAL"
            echo "[ + ] ( 2 ) - Instalacion en VM"
            echo ""
            read realVM
            sudo pacman -S neovim wezterm net-tools lsd thunar --noconfirm
            sudo pacman -S rclone openresolv systemd-resolvconf cron ranger fuse --noconfirm
            sudo pacman -S neofetch sshfs vifm curl htop wget neofetch tree fzf python-pip npm ranger ueberzug ripgrep fd universal-ctags --noconfirm
            yay flameshot
            yay wireguard-tools
            sudo systemctl enable --now systemd-resolved.service
            mkdir ~/.config/wezterm
            cp config/wezterm/wezterm.lua ~/.config/wezterm
            git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
            git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
            ~/.fzf/install
            if [ $realVM = "2" ]
            then
                sudo pacman -S open-vm-tools --noconfirm
                sudo pacman -S xf86-video-vmware xf86-input-vmmouse --noconfirm
                sudo systemctl enable --now vmtoolsd
                sudo pacman -S virtualbox-guest-iso
                sudo mount /usr/lib/virtualbox/additions/VboxGuestAdditions.iso /mnt
                sudo /mnt/VBoxLinuxAdditions.run
                sudo umount /mnt
            fi
        fi  
        if [ $app = "3" ]
        then    
            cd $pwd
            sudo pacman -S zsh
            sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
            cp p10k.zsh ~/.p10k.zsh
            cp zshrc ~/.zshrc

            yay -S --noconfirm zsh-theme-powerlevel10k-git
            sudo pacman -S powerline-common awesome-terminal-fonts
            yay -S --noconfirm ttf-meslo-nerd-font-powerlevel10k
            sed -i "s/username/$username/g" ~/.zshrc
            git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
            git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ~/.zsh/zsh-autocomplete
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
            wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh -P ~/.zsh
            cd $pwd
        fi
        if [ $app = "4" ]
        then
            cd $pwd 
            cd ~/Downloads
            git clone https://AUR.archlinux.org/visual-studio-code-bin.git
            cd visual-studio-code-bin/
            makepkg -s
            sudo pacman -U visual-studio-code-bin-*.tar*
            rm -rfv visual-studio* 
        fi
        if [ $app = "T" ]
        then
            #1
            cd $pwd
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
            #2
            cd $pwd
            echo ""
            echo ""
            echo "[ + ] ( 1 ) - Instalacion en REAL"
            echo "[ + ] ( 2 ) - Instalacion en VM"
            echo ""
            read realVM
            sudo pacman -S neovim wezterm net-tools lsd thunar --noconfirm
            sudo pacman -S rclone openresolv systemd-resolvconf cron ranger fuse --noconfirm
            sudo pacman -S neofetch sshfs vifm curl htop wget neofetch tree fzf python-pip npm ranger ueberzug ripgrep fd universal-ctags --noconfirm
            yay flameshot
            yay wireguard-tools
            sudo systemctl enable --now systemd-resolved.service
            mkdir ~/.config/wezterm
            cp config/wezterm/wezterm.lua ~/.config/wezterm
            git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
            git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
            ~/.fzf/install
            if [ $realVM = "2" ]
            then
                sudo pacman -S open-vm-tools --noconfirm
                sudo pacman -S xf86-video-vmware xf86-input-vmmouse --noconfirm
                sudo systemctl enable --now vmtoolsd
                sudo pacman -S virtualbox-guest-iso
                sudo mount /usr/lib/virtualbox/additions/VboxGuestAdditions.iso /mnt
                sudo /mnt/VBoxLinuxAdditions.run
                sudo umount /mnt
            fi
            #3
            cd $pwd
            sudo pacman -S zsh
            sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
            cp p10k.zsh ~/.p10k.zsh
            cp zshrc ~/.zshrc
            #4
            cd $pwd
            yay -S --noconfirm zsh-theme-powerlevel10k-git
            sudo pacman -S powerline-common awesome-terminal-fonts
            yay -S --noconfirm ttf-meslo-nerd-font-powerlevel10k
            sed -i "s/username/$username/g" ~/.zshrc
            git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
            git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ~/.zsh/zsh-autocomplete
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
            wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh -P ~/.zsh
            cd $pwd

            cd $pwd 
            cd ~/Downloads
            git clone https://AUR.archlinux.org/visual-studio-code-bin.git
            cd visual-studio-code-bin/
            makepkg -s
            sudo pacman -U visual-studio-code-bin-*.tar*
            rm -rfv visual-studio* 
        fi  
        if [ $app = "X" ]
        then
            selec=0
        fi     
    done
    while [ $selec = "2" ]
    do
        echo ""
        echo ""
        echo "[ + ] ( 1 ) - Awesome [Paru]"
        echo "[ + ] ( 2 ) - fonts [yay]"
        echo "[ + ] ( T ) - All"
        echo "[ + ] ( X ) - close"
        echo ""
        read app
        if [ $app = "1" ]
        then
            cd $pwd
            sudo pacman -S gnome
            paru -S awesome-git
            paru -Sy picom-git wezterm rofi acpi acpid acpi_call upower lxappearance-gtk3 \
            jq inotify-tools polkit-gnome xdotool xclip gpick ffmpeg blueman redshift \
            pipewire pipewire-alsa pipewire-pulse alsa-utils brightnessctl feh maim \
            mpv mpd mpc mpdris2 python-mutagen ncmpcpp playerctl --needed
            
            # Instalador
            sudo systemctl enable --now mpd.service
            sudo pacman -S polybar nitrogen --noconfirm
            
            # Copias
            cp -r config/* ~/.config
            
            # Lock
            yay i3lock-color
            git clone https://github.com/Raymo111/i3lock-color.git
            cd i3lock-color
            ./build.sh
            ./install-i3lock-color.sh
            cd ..
            rm -rfv i3lock-color
            git clone https://github.com/meskarune/i3lock-fancy.git
            cd i3lock-fancy
            sudo make install
            cd ..
            rm -rfv i3lock-fancy

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
        if [ $app = "2" ]
        then
            cd $pwd
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
            cd /usr/share/fonts
            sudo curl -o iosevka.zip https://fontlot.com/downfile?post_id=105610&post_slug=iosevka-font-family&pf_nonce=8b11cb3408
            unzip iosevka.zip
            cd $pwd
            sudo rm -rfv *.ttf EOT OTF TTF WOFF WOFF2 *.zip
        fi
        if [ $app = "T" ]
        then
            #1
            cd $pwd
            sudo pacman -S gnome
            paru -S awesome-git
            paru -Sy picom-git wezterm rofi acpi acpid acpi_call upower lxappearance-gtk3 \
            jq inotify-tools polkit-gnome xdotool xclip gpick ffmpeg blueman redshift \
            pipewire pipewire-alsa pipewire-pulse alsa-utils brightnessctl feh maim \
            mpv mpd mpc mpdris2 python-mutagen ncmpcpp playerctl --needed
            
            # Instalador
            sudo systemctl enable --now mpd.service
            sudo pacman -S polybar nitrogen --noconfirm
            
            # Copias
            cp -r config/* ~/.config
            
            # Lock
            yay i3lock-color
            git clone https://github.com/Raymo111/i3lock-color.git
            cd i3lock-color
            ./build.sh
            ./install-i3lock-color.sh
            cd ..
            rm -rfv i3lock-color
            git clone https://github.com/meskarune/i3lock-fancy.git
            cd i3lock-fancy
            sudo make install
            cd ..
            rm -rfv i3lock-fancy

            #Rofi
            mkdir -p ~/.config/rofi/themes/
            git clone https://github.com/lr-tech/rofi-themes-collection.git
            cd rofi-themes-collection
            mkdir ~/.config/rofi
            mkdir ~/.config/rofi/themes/
            cp themes/* ~/.config/rofi/themes/
            cd ..
            rm -rfv rofi-themes-collection
            #2
            cd $pwd
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
            cd /usr/share/fonts
            sudo curl -o iosevka.zip https://fontlot.com/downfile?post_id=105610&post_slug=iosevka-font-family&pf_nonce=8b11cb3408
            unzip iosevka.zip
            cd $pwd
            sudo rm -rfv *.ttf EOT OTF TTF WOFF WOFF2 *.zip
        fi
        if [ $app = "X" ]
        then
            selec=0
        fi
    done
    if [ $selec = "x" ]
    then
        selec=-1
    fi
done
