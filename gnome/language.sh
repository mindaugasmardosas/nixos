gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'lt')]"
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

