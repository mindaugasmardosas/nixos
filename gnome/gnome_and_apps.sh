

ME=`whoami`
if [ ${ME} != "mm" ]; then
	echo "need to run as user mm"
	exit 1;
fi


gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'lt')]"
# nelabai veikia sekantis - geriausia tiesiog per gui nustatyti
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Alt>space']"
gsettings set org.gnome.desktop.interface show-battery-percentage true
dconf write /org/gnome/nautilus/preferences/always-use-location-entry true

# Kdrive
cat <<EOF > ~/.local/share/applications/kDrive.desktop
[Desktop Entry]
Name=kDrive
Comment=Run kDrive
Exec=appimage-run /home/mm/bin/kDrive
Icon=/home/mm/Pictures/icons/kDrive.png
Type=Application
Categories=Utility;Application;
EOF

# kDrive update
LATEST_KDRIVE=`ls -ltr /home/mm/bin/kDrive-* | grep kDrive | tail -n 1 | awk '{print $NF}'`
unlink /home/mm/bin/kDrive
ln -s /home/mm/bin/$LATEST_KDRIVE /home/mm/bin/kDrive

if [ ! -L $HOME/kDrive ]; then
	ln -s /mnt/data/vm/infomaniak $HOME/kDrive
fi
