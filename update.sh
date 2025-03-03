#! /bin/sh
nix-channel --update
nixos-rebuild switch
#vulnix --system
# nixos-rebuild switch --upgrade
#
dconf write /org/gnome/nautilus/preferences/always-use-location-entry true
nix-collect-garbage --delete-older-than 7d

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

gsettings set org.gnome.desktop.interface show-battery-percentage true


