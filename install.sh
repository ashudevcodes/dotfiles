sudo pacman -S fzf
sudo pacman -S starship
sudo pacman -S cowsay 

# New utils for ls 
sudo pacman -S eza 

# Node JS and NPM
sudo pacman -S nodejs
sudo pacman -S npm
# GoLang
sudo pacman -S go

# For installing yay in arch 
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

# Firefox successor Zen browser
yay -S zen-browser-bin

# For Git thing
sudo pacman -S lazygit

# use acpi to see battery health and status
sudo pacman -S acpi

# bluetooth Manager
sudo pacman -S bluez
sudo pacman -S bluez-utils
# After installing start the bluetooth deamon
sudo systemctl start bluetooth.service
sudo systemctl enable bluetooth.service

# Wifi Manager
sudo pacman -S  networkmanager
# After installing start the network deamon
sudo systemctl start NetworkManager.service
sudo systemctl enable NetworkManager.service

# Nerd font
sudo pacman -S ttf-input-nerd
sudo pacman -S ttf-jetbrains-mono-nerd

# For debugginng awesomewm
sudo pacman -S xorg-server-xephyr
