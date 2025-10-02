#!/bin/bash
# build-ubuntu-auto.sh
# Génère une ISO Ubuntu Desktop automatisée avec preseed
# Compatible BIOS + UEFI ou UEFI-only
# Usage : ./build-ubuntu-auto.sh /chemin/vers/ubuntu-original.iso [preseed.cfg]

set -euo pipefail

ISO_ORIG="$1"
PRESEED="${2:-}"

if [[ -z "$ISO_ORIG" || ! -f "$ISO_ORIG" ]]; then
    echo "Usage: $0 /chemin/vers/ubuntu-original.iso [preseed.cfg]"
    exit 1
fi

WORKDIR=$(mktemp -d)
ISO_DIR="$WORKDIR/iso"
MNT_DIR="$WORKDIR/mnt"
OUTPUT="$PWD/ubuntu-auto.iso"

mkdir -p "$ISO_DIR" "$MNT_DIR"

echo "[1/7] Montage de l'ISO originale..."
sudo mount -o loop "$ISO_ORIG" "$MNT_DIR"

echo "[2/7] Copie du contenu de l'ISO..."
rsync -a "$MNT_DIR/" "$ISO_DIR/"
sudo umount "$MNT_DIR"

echo "[3/7] Création ou copie du fichier preseed..."
mkdir -p "$ISO_DIR/preseed"

if [[ -z "$PRESEED" ]]; then
    echo "Création d'un preseed minimal par défaut..."
    cat > "$ISO_DIR/preseed/custom.cfg" <<EOL
d-i debian-installer/locale string fr_FR.UTF-8
d-i console-setup/ask_detect boolean false
d-i keyboard-configuration/layoutcode string fr
d-i time/zone string Europe/Paris
d-i partman-auto/method string regular
d-i partman-auto/choose_recipe select atomic
d-i partman-auto/confirm boolean true
d-i partman/confirm_nooverwrite boolean true
d-i passwd/user-fullname string Utilisateur
d-i passwd/username string user
d-i passwd/user-password password user123
d-i passwd/user-password-again password user123
tasksel tasksel/first multiselect standard, ubuntu-desktop
d-i pkgsel/include string openssh-server vim htop curl git
d-i preseed/late_command string \
    in-target systemctl disable cups.service; \
    in-target systemctl disable avahi-daemon.service; \
    in-target echo "Installation auto terminée." > /home/user/INSTALL_OK.txt
EOL
    echo "Preseed par défaut créé."
else
    if [[ ! -f "$PRESEED" ]]; then
        echo "Erreur : fichier preseed non trouvé"
        exit 1
    fi
    cp "$PRESEED" "$ISO_DIR/preseed/custom.cfg"
    echo "Preseed personnalisé copié."
fi

echo "[4/7] Modification du GRUB..."
GRUB="$ISO_DIR/boot/grub/grub.cfg"
if [[ -f "$GRUB" ]]; then
    sed -i '/linux\s\+\/casper\/vmlinuz/ s/---/file=\/cdrom\/preseed\/custom.cfg auto=true priority=critical ---/' "$GRUB"
    echo "GRUB modifié."
else
    echo "GRUB non trouvé, vérifiez l'ISO"
fi

echo "[5/7] Modification isolinux (BIOS si présent)..."
ISOLINUX="$ISO_DIR/isolinux/txt.cfg"
if [[ -f "$ISOLINUX" ]]; then
    sed -i '/^append/ s/initrd=\/casper\/initrd/& file=\/cdrom\/preseed\/custom.cfg auto=true priority=critical/' "$ISOLINUX"
    echo "isolinux modifié."
fi

# Détection type de boot
UEFI_BOOT=false
BIOS_BOOT=false
[[ -f "$ISO_DIR/EFI/boot/bootx64.efi" ]] && UEFI_BOOT=true
[[ -f "$ISO_DIR/isolinux/isolinux.bin" ]] && BIOS_BOOT=true

echo "[6/7] Création de l'ISO bootable..."

if $BIOS_BOOT && $UEFI_BOOT; then
    echo "ISO BIOS + UEFI détectée"
    xorriso -as mkisofs -r -V "Ubuntu-Auto" \
      -o "$OUTPUT" \
      -J -l -iso-level 3 -D \
      -b isolinux/isolinux.bin \
      -c isolinux/boot.cat \
      -no-emul-boot -boot-load-size 4 -boot-info-table \
      -eltorito-alt-boot \
      -e EFI/boot/bootx64.efi \
      -no-emul-boot \
      "$ISO_DIR"
elif $UEFI_BOOT; then
    echo "ISO UEFI only détectée"
    xorriso -as mkisofs -r -V "Ubuntu-Auto" \
      -o "$OUTPUT" \
      -J -l -iso-level 3 \
      -e EFI/boot/bootx64.efi \
      -no-emul-boot \
      "$ISO_DIR"
elif $BIOS_BOOT; then
    echo "ISO BIOS only détectée"
    xorriso -as mkisofs -r -V "Ubuntu-Auto" \
      -o "$OUTPUT" \
      -J -l -iso-level 3 -D \
      -b isolinux/isolinux.bin \
      -c isolinux/boot.cat \
      -no-emul-boot -boot-load-size 4 -boot-info-table \
      "$ISO_DIR"
else
    echo "Erreur : aucun boot détecté ! ISO invalide ?"
    exit 1
fi

echo "ISO automatisée créée : $OUTPUT"

# Nettoyage
rm -rf "$WORKDIR"
echo "Dossier temporaire supprimé."
