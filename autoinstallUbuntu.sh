#!/bin/bash

# Vérifie si un argument est fourni
if [ -z "$1" ]; then
    echo "Usage: $0 /chemin/vers/cle_usb"
    exit 1
fi

USB_PATH="$1"

# Vérifie si le chemin existe
if [ ! -d "$USB_PATH" ]; then
    echo "Erreur : le chemin $USB_PATH n'existe pas."
    exit 1
fi

# Création du dossier autoinstall
AUTO_DIR="$USB_PATH/autoinstall"
mkdir -p "$AUTO_DIR"

# Création du fichier meta-data
cat > "$AUTO_DIR/meta-data" <<EOF
instance-id: iid-local01
local-hostname: ubuntu-autoinstall
EOF

# Création du fichier user-data (exemple minimal)
cat > "$AUTO_DIR/user-data" <<EOF
#cloud-config
autoinstall:
  version: 1

  identity:
    hostname: ubuntu-auto
    username: test
    # Mot de passe chiffré recommandé (ici vide → connexion SSH possible seulement avec clé)
    password: ""

  locale: en_US
  keyboard:
    layout: us

  timezone: UTC

  storage:
    layout:
      name: lvm

  # Étapes de configuration après l’installation principale
  late-commands:
    # Exemple : créer un fichier pour indiquer la fin d’installation
    - curtin in-target --target=/target -- bash -c 'echo "Installation terminée avec succès" > /root/INSTALL_DONE.txt'

EOF

# Création ou remplacement du grub.cfg
GRUB_FILE="$USB_PATH/boot/grub/grub.cfg"
mkdir -p "$(dirname "$GRUB_FILE")"

cat > "$GRUB_FILE" <<'EOF'
set timeout=30

loadfont unicode

set menu_color_normal=white/black
set menu_color_highlight=black/light-gray

menuentry "Try or Install Ubuntu" {
	set gfxpayload=keep
	linux	/casper/vmlinuz  --- quiet splash autoinstall ds=nocloud\;s=/cdrom/autoinstall/ ---

	initrd	/casper/initrd
}
menuentry "Ubuntu (safe graphics)" {
	set gfxpayload=keep
	linux	/casper/vmlinuz nomodeset  --- quiet splash
	initrd	/casper/initrd
}
grub_platform
if [ "$grub_platform" = "efi" ]; then
menuentry 'Boot from next volume' {
	exit 1
}
menuentry 'UEFI Firmware Settings' {
	fwsetup
}
else
menuentry 'Test memory' {
	linux16 /boot/memtest86+x64.bin
}
fi
EOF

echo "✅ Fichiers créés dans : $AUTO_DIR"
echo "✅ grub.cfg mis à jour : $GRUB_FILE"
