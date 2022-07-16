#!/bin/bash

# Entering sudo mode
sudo su - <<EOF
sudo dnf upgrade -y  2>> errors.txt
sudo dnf install -y git zsh zsh-syntax-highlighting zsh-autosuggestions tilix duf pidgin cairo-dock htop conky exa ncdu bat onedrive python3-pip samba 2>> errors.txt
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
mkdir ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.omp.*
rm ~/.poshthemes/themes.zip

# notepadqq installation
sudo dnf install -y qtwebengine5-dev libqt5websockets5-dev libqt5svg5-dev qttools5-dev-tools libuchardet-dev pkg-config qtwebengine5 libqt5websockets5 libqt5svg5 coreutils libuchardet qt5-qtbase-devel qt5-qttools-devel qt5-qtwebengine-devel qt5-qtwebsockets-devel qt5-qtsvg-devel uchardet qt5-qtwebchannel-devel pkgconfig libchardet-devel uchardet-devel libchardet 2>> errors.txt
git clone --recursive https://github.com/notepadqq/notepadqq.git
cd notepadqq
./configure --prefix /usr 2>> errors.txt
make 2>> errors.txt
sudo make install 2>> errors.txt

# Pidgin plugin
sudo dnf install -y json-glib-devel libpurple-devel glib2-devel libpurple-devel protobuf-c-devel protobuf-c-compiler
git clone https://github.com/EionRobb/purple-googlechat/ && cd purple-googlechat
make && sudo make install

# Conky config file
sudo cp /etc/conky/conky.conf /etc/conky/conky.conf.bak
sudo wget 'https://github.com/abyss6166/fedorainstall/raw/main/conky.conf'

# Enable and start ssh and samba services
sudo systemctl enable sshd
sudo systemctl start sshd
sudo systemctl enable smb
sudo systemctl start smb

su $user
#EOF

# Download fonts
mkdir ~/.local/share/fonts && cd $_
wget 'https://github.com/abyss6166/fedorainstall/raw/main/Inconsolata for Powerline.otf'
wget 'https://github.com/abyss6166/fedorainstall/raw/main/MesloLGS NF Bold.ttf'
wget 'https://github.com/abyss6166/fedorainstall/raw/main/MesloLGS NF Bold Italic.ttf'
wget 'https://github.com/abyss6166/fedorainstall/raw/main/MesloLGS NF Italic.ttf'
wget 'https://github.com/abyss6166/fedorainstall/raw/main/MesloLGS NF Regular.ttf'

# Download zsh config and aliasrc files
cd $home
wget 'https://github.com/abyss6166/fedorainstall/raw/main/.zshrc'
wget 'https://github.com/abyss6166/fedorainstall/raw/main/aliasrc'
source .zshrc
source aliasrc

# Rainlendar install
wget 'https://www.rainlendar.net/download/2.18.0/Rainlendar-Pro-2.18.0-amd64.tar.bz2'
unzip Rainlendar-Pro-2.18.0-amd64.tar.bz2
cd rainlendar2
nohup ./rainlendar2 &

# OneDriveGUI installm
git clone https://github.com/bpozdena/OneDriveGUI.git
cd OneDriveGUI
python -m pip install -r requirements.txt

# Download gtk css file
cd ~/.config/gtk-3.0
wget 'https://github.com/abyss6166/fedorainstall/raw/main/gtk.css'


# Entering sudo mode for Samba setup
sudo su - <<EOF
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

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

sudo semanage fcontext --add --type "samba_share_t" "/home/$user/Downloads(/.*)?"
sudo restorecon -R ~/Downloads

sudo systemctl restart smb
sudo smbpasswd -a $USER
su $user
EOF