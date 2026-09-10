!/usr/bin/env bash

# Define the log file and clear it out at startup
LOG_FILE="$HOME/log/install.log"
mkdir -p "$HOME/log"

> "$LOG_FILE"

# Cache sudo credentials upfront so password prompts don't get hidden inside logs
echo "Please enter your sudo password to begin the installation:"
sudo -v

# Keep-alive: update user's sudo timestamp until the script finishes
while kill -0 "$$" 2>/dev/null ; do
	sudo -v
    sleep 30
done &



echo "============================================================================="
echo " Starting Void Linux & Openbox Installer "
echo "============================================================================="

echo "========================================================================================================" >> "$LOG_FILE" 2>&1
echo "[1/15] Syncing repositories & preparing detection tools..." | tee -a "$LOG_FILE"
echo "========================================================================================================" >> "$LOG_FILE" 2>&1

(
    sudo xbps-install -Suy
    sudo xbps-install -Sy virt-what
) >> "$LOG_FILE" 2>&1
sleep 2

# Hypervisor detection
VIRT_TYPE=$(sudo virt-what)

if [ "$VIRT_TYPE" = "vmware" ]; then

		echo "========================================================================================================" >> "$LOG_FILE" 2>&1
		echo "[2/15] VMware detected! Installing VMware Tools..." | tee -a "$LOG_FILE"
		echo "========================================================================================================" >> "$LOG_FILE" 2>&1

    (
        sudo xbps-install -Sy open-vm-tools mesa-vaapi mesa-vmwgfx-dri
        sudo ln -s /etc/sv/vmware-vmblock-fuse /var/service/
        sudo ln -s /etc/sv/vmtoolsd /var/service/
        sudo sv up vmtoolsd
        sudo sv up vmware-vmblock-fuse
        if [ -d "/etc/xdg/autostart" ]; then
            sudo cp /etc/xdg/autostart/vmware-user.desktop /etc/xdg/autostart/ 2>/dev/null
        fi
    ) >> "$LOG_FILE" 2>&1
else
    echo "========================================================================================================" >> "$LOG_FILE" 2>&1
    echo "[2/15] Virtual environment is: '${VIRT_TYPE:-bare-metal}'. Skipping VMware Tools."
    echo "========================================================================================================" >> "$LOG_FILE" 2>&1

fi

sleep 5


echo "========================================================================================================" >> "$LOG_FILE" 2>&1
echo "[3/15] Installing core CLI utilities..." | tee -a "$LOG_FILE"
echo "========================================================================================================" >> "$LOG_FILE" 2>&1
(
	sudo xbps-install -Sy delta htop btop make micro git wget xz zip unzip nano cmake curl gcc net-tools gping ncdu fastfetch mlocate glow
) >> "$LOG_FILE" 2>&1
sleep 2

echo "========================================================================================================" >> "$LOG_FILE" 2>&1
echo "[4.1/15] Installing Xorg server ..." | tee -a "$LOG_FILE"
echo "========================================================================================================" >> "$LOG_FILE" 2>&1
sudo xbps-install -Sy xorg xorg-server xorg-apps xrandr xterm twm xinit xsel xclip xcolor >> "$LOG_FILE" 2>&1


echo "========================================================================================================" >> "$LOG_FILE" 2>&1
echo "[4.2/15] Installing XFCE4 and some plugins ..." | tee -a "$LOG_FILE"
echo "========================================================================================================" >> "$LOG_FILE" 2>&1

(
sudo xbps-install -Sy xfce4 xfce4-whiskermenu-plugin xfce4-sensors-plugin xfce4-panel-appmenu xfce4-pulseaudio-plugin  xfce4-clipman-plugin xfce4-weather-plugin >> "$LOG_FILE" 2>&1

) >> "$LOG_FILE" 2>&1

echo "========================================================================================================" >> "$LOG_FILE" 2>&1
echo "[5/15] Creating X11 environment configuration (.xinitrc)..." | tee -a "$LOG_FILE"
echo "========================================================================================================" >> "$LOG_FILE" 2>&1

(
    echo "xrandr --output Virtual-1 --mode 1920x1080 " >> ~/.xinitrc
    echo "exec xterm & " >> ~/.xinitrc
    echo "# exec openbox-session" >> ~/.xinitrc
    echo "exec startxfce4" >> ~/.xinitrc
) >> "$LOG_FILE" 2>&1


echo "========================================================================================================" >> "$LOG_FILE" 2>&1
echo "[7/15] Installing and initializing D-Bus & system daemons..." | tee -a "$LOG_FILE"
echo "========================================================================================================" >> "$LOG_FILE" 2>&1

(
    sudo xbps-install -Sy dbus elogind dbus-elogind polkit polkit-elogind turnstile
    sudo ln -s /etc/sv/dbus /var/service/
    sudo ln -sf /etc/sv/elogind /var/service/
    sudo ln -sf /etc/sv/polkitd /var/service/
    sudo ln -sf /etc/sv/turnstiled/ /var/service/
    sudo sv up dbus
    sudo sv up turnstiled
    sudo sv up elogind
    sudo dbus-uuidgen --ensure=/etc/machine-id
    sudo ln -sf /etc/machine-id /var/lib/dbus/machine-id
) >> "$LOG_FILE" 2>&1


echo "========================================================================================================" >> "$LOG_FILE" 2>&1
echo "[8.1/15] Installing some X11 applications..." | tee -a "$LOG_FILE"
echo "========================================================================================================" >> "$LOG_FILE" 2>&1

(
    sudo xbps-install -Sy falkon kitty flameshot gmrun xbindkeys xdotool xev gpick arandr gpick CopyQ zathura zathura-cb zathura-pdf-mupdf
    mkdir -p ~/screenshots
) >> "$LOG_FILE" 2>&1

echo "========================================================================================================" >> "$LOG_FILE" 2>&1
echo "[8.2/15] Installing Thunar, file manager..." | tee -a "$LOG_FILE"
echo "========================================================================================================" >> "$LOG_FILE" 2>&1

(
    sudo xbps-install -Sy Thunar thunar-archive-plugin thunar-media-tags-plugin tumbler lximage-qt gvfs xarchiver
 ) >> "$LOG_FILE" 2>&1

echo "========================================================================================================" >> "$LOG_FILE" 2>&1
echo "[8.4/15] Installing Geany, text editor..." | tee -a "$LOG_FILE" |
echo "========================================================================================================" >> "$LOG_FILE" 2>&1

(
    sudo xbps-install -Sy geany geany-editorconfig-plugin geany-plugins geany-plugins-extra
) >> "$LOG_FILE" 2>&1

echo "========================================================================================================" >> "$LOG_FILE" 2>&1
echo "[10/15] Configuring system audio permissions..." | tee -a "$LOG_FILE"
echo "========================================================================================================" >> "$LOG_FILE" 2>&1

(
    sudo xbps-install -Sy pipewire alsa-plugins-pulseaudio wireplumber pavucontrol pamixer
    sudo usermod -aG audio,video,input $(whoami)
) >> "$LOG_FILE" 2>&1

echo "========================================================================================================" >> "$LOG_FILE" 2>&1
echo "[11/15] Install XFCE Themes + Icons..." | tee -a "$LOG_FILE"
echo "========================================================================================================" >> "$LOG_FILE" 2>&1
(

./scripts/win11-theme.sh


) >> "$LOG_FILE" 2>&1



echo "========================================================================================================" >> "$LOG_FILE" 2>&1
echo "[12.1/15] Awesome fonts..." | tee -a "$LOG_FILE"
echo "========================================================================================================" >> "$LOG_FILE" 2>&1

(
    sudo xbps-install -Sy font-awesome
    # sudo xbps-install -Sy font-firacode font-iosevka font-awesome
) >> "$LOG_FILE" 2>&1


echo "========================================================================================================" >> "$LOG_FILE" 2>&1
echo "[12.2/15] Installing Jetbrain (Nerd) System and other fonts..." | tee -a "$LOG_FILE"
echo "========================================================================================================" >> "$LOG_FILE" 2>&1

(
# comment out fonts, if you don't need or use them

./scripts/install-font-firacode.sh
./scripts/install-font-firamono.sh
./scripts/install-font-hacknerd.sh
./scripts/install-font-iosevka.sh
./scripts/install-font-iosevkaterm.sh
./scripts/install-font-jetbrainsmono.sh
./scripts/install-font-jetbrainsnerd-mono.sh


) >> "$LOG_FILE" 2>&1
sleep 2


echo "========================================================================================================" >> "$LOG_FILE" 2>&1
echo "[12/15] Installing Kora icons theme..." | tee -a "$LOG_FILE"
echo "========================================================================================================" >> "$LOG_FILE" 2>&1

(
	mkdir -p icons
	cd icons
	git clone https://github.com/bikass/kora.git
	sudo mv kora/kora/ /usr/share/icons/
	sudo mv kora/kora-pgrey/ /usr/share/icons/
	cd ..
	rm -rf icons

) >> "$LOG_FILE" 2>&1



echo "========================================================================================================" >> "$LOG_FILE" 2>&1
echo "[13/15] Customizing interactive shells (Fish & other components)..." | tee -a "$LOG_FILE"
echo "========================================================================================================" >> "$LOG_FILE" 2>&1

(
     # installing Fish shell
    ./scripts/fish/install.sh

    # installing Bibita cursor
    ./scripts/bibita-cursor.sh

) >> "$LOG_FILE" 2>&1



echo "========================================================================================================" >> "$LOG_FILE" 2>&1
echo "[14/15] Deploying customized dotfiles and configuration sets..." | tee -a "$LOG_FILE"
echo "========================================================================================================" >> "$LOG_FILE" 2>&1

(
    cp -Rv ~/void-xfce/dot_home/.* ~/.
) >> "$LOG_FILE" 2>&1
sleep 1
