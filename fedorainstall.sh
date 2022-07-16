#!/bin/bash

# declare user and home variables
user=$USER
home=$HOME

# Entering sudo mode
echo "Upgrading"
sudo su - <<EOF
dnf upgrade -y  2>> errors.txt

# base packages
echo "Installing base packages"
dnf install -y git zsh zsh-syntax-highlighting zsh-autosuggestions tilix duf pidgin cairo-dock htop conky exa ncdu bat onedrive python3-pip samba 2>> errors.txt

# notepadqq dependencies
echo "Installing notepadqq dependencies"
dnf install -y qt5-qtbase-devel qt5-qttools-devel qt5-qtwebengine-devel qt5-qtwebsockets-devel qt5-qtsvg-devel uchardet uchardet-devel qt5-qtwebchannel-devel pkgconfig 2>> errors.txt

# pidgin dependencies
echo "Installing pidgin dependencies"
dnf install -y json-glib-devel libpurple-devel glib2-devel libpurple-devel protobuf-c-devel protobuf-c-compiler

# oh-my-posh
echo "Downloading oh-my-posh"
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
chmod +x /usr/local/bin/oh-my-posh

# Conky config file
echo "Configuring conky"
cp /etc/conky/conky.conf /etc/conky/conky.conf.bak
rm /etc/conky/conky.conf
wget 'https://github.com/abyss6166/fedorainstall/raw/main/conky.conf' -P /etc/conky/

# Enable and start ssh and samba services
echo "Enabling sshd and smb"
systemctl enable sshd
systemctl start sshd
systemctl enable smb
systemctl start smb

# Switch back to user
echo "Switching back to $user"
su $user
EOF

# install oh-my-posh themes
echo "Installing oh-my-posh themes"
mkdir ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.omp.*
rm ~/.poshthemes/themes.zip

# Pidgin plugin
echo "Downloading Google chat plugin"
git clone https://github.com/EionRobb/purple-googlechat/ && cd purple-googlechat
echo "Google Chat Make"
make
echo "Google Chat Make install"
sudo make install

# notepadqq installation
cd $home
echo "Downloading notepadqq"
git clone --recursive https://github.com/notepadqq/notepadqq.git
cd notepadqq
echo "Configuring notepadqq install"
./configure --prefix /usr 2>> errors.txt
echo "notepadqq make"
make 2>> errors.txt
echo "notepadqq make install"
sudo make install 2>> errors.txt

# Download fonts
cd $home
mkdir ~/.local/share/fonts
wget 'https://github.com/abyss6166/fedorainstall/raw/main/Inconsolata for Powerline.otf' -P ~/.local/share/fonts
wget 'https://github.com/abyss6166/fedorainstall/raw/main/MesloLGS NF Bold.ttf' -P ~/.local/share/fonts
wget 'https://github.com/abyss6166/fedorainstall/raw/main/MesloLGS NF Bold Italic.ttf' -P ~/.local/share/fonts
wget 'https://github.com/abyss6166/fedorainstall/raw/main/MesloLGS NF Italic.ttf' -P ~/.local/share/fonts
wget 'https://github.com/abyss6166/fedorainstall/raw/main/MesloLGS NF Regular.ttf' -P ~/.local/share/fonts
fc-cache

# Rainlendar install
wget 'https://www.rainlendar.net/download/2.18.0/Rainlendar-Pro-2.18.0-amd64.tar.bz2'
unzip Rainlendar-Pro-2.18.0-amd64.tar.bz2
#cd rainlendar2
nohup ~/rainlendar2/rainlendar2 &

# OneDriveGUI install
git clone https://github.com/bpozdena/OneDriveGUI.git
cd OneDriveGUI
python -m pip install -r requirements.txt

# Download gtk css file
wget 'https://github.com/abyss6166/fedorainstall/raw/main/gtk.css' -P ~/.config/gtk-3.0

# Download icons and theme
cd $home
wget 'https://github.com/abyss6166/fedorainstall/raw/main/Material-Black-Cherry-3.36_1.9.3.zip'
wget 'https://github.com/abyss6166/fedorainstall/raw/main/delft-iconpack.tar.xz'
unzip Material-Black-Cherry-3.36_1.9.3.zip -d ~/.themes
unzip delft-iconpack.tar.xz -d ~/.icons

# Entering sudo mode for Samba setup
sudo su - <<EOF
cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

cat <<EOM >> /etc/samba/smb.conf

[Downloads]
        comment = Laptop Downloads Share
        path = /home/${user}/Downloads
        writeable = yes
        browsable = yes
        public = yes
        create mask = 0664
        force create mode = 0664
        directory mask = 0775
        force directory mode = 0775
        write list = user
EOM

semanage fcontext --add --type "samba_share_t" "/home/$user/Downloads(/.*)?"
restorecon -R ~/Downloads

systemctl restart smb
smbpasswd -a $USER
su $user
EOF

# set up ZSH
zsh

# Download zsh config and aliasrc files
cd $home
wget 'https://github.com/abyss6166/fedorainstall/raw/main/.zshrc'
wget 'https://github.com/abyss6166/fedorainstall/raw/main/aliasrc'
source .zshrc
source aliasrc
