#!/bin/bash
set -e

if [ $# -ne 1 ]; then
  echo "Usage: $0 <ubuntu.iso>"
  exit 1
fi

ISO_ORIG="$1"
WORKDIR=$(mktemp -d)
MNT="$WORKDIR/mnt"
ISODIR="$WORKDIR/iso"
OUTPUT="$(pwd)/ubuntu-auto.iso"

echo "[1/6] Montage de l'ISO originale..."
mkdir -p "$MNT" "$ISODIR"
sudo mount -o loop "$ISO_ORIG" "$MNT"

echo "[2/6] Copie du contenu de l'ISO..."
rsync -a "$MNT/" "$ISODIR/"
sudo umount "$MNT"

echo "[3/6] Création du fichier preseed..."
mkdir -p "$ISODIR/preseed"
cat > "$ISODIR/preseed/custom.cfg" <<'EOF'
### Preseed minimal ###
d-i debconf/frontend string noninteractive
d-i auto-install/enable boolean true
d-i debconf/priority string critical
d-i time/zone string Europe/Paris
d-i keyboard-configuration/xkb-keymap select fr
d-i netcfg/get_hostname string ubuntu-auto
d-i netcfg/choose_interface select auto
d-i mirror/http/hostname string archive.ubuntu.com
d-i mirror/http/directory string /ubuntu
d-i passwd/user-fullname string Auto User
d-i passwd/username string auto
d-i passwd/user-password password auto
d-i passwd/user-password-again password auto
d-i pkgsel/include string ubuntu-desktop openssh-server vim htop curl git
d-i finish-install/reboot_in_progress note
EOF
echo "Preseed créé : $ISODIR/preseed/custom.cfg"

echo "[4/6] Modification du GRUB..."
for GRUBCFG in $(find "$ISODIR/boot/grub" -name grub.cfg); do
  cp "$GRUBCFG" "$GRUBCFG.bak"
  sed -i '/menuentry "Try or Install Ubuntu"/,/initrd/ s@initrd.*@initrd  /casper/initrd\n    linux   /casper/vmlinuz auto=true priority=critical file=/cdrom/preseed/custom.cfg@' "$GRUBCFG"
done
echo "GRUB modifié."

echo "[5/6] Vérification du mode boot..."
if [ -f "$ISODIR/isolinux/isolinux.bin" ]; then
  MODE="BIOS+UEFI"
elif [ -f "$ISODIR/boot/grub/efi.img" ]; then
  MODE="UEFI-img"
else
  MODE="UEFI-bootx64"
fi
echo "Mode détecté : $MODE"

echo "[6/6] Création de l'ISO bootable..."
case $MODE in
  "BIOS+UEFI")
    xorriso -as mkisofs \
      -r -V "Ubuntu-Auto" \
      -o "$OUTPUT" \
      -J -l -cache-inodes -iso-level 3 \
      -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
      -partition_offset 16 \
      -b isolinux/isolinux.bin \
         -c isolinux/boot.cat \
         -no-emul-boot -boot-load-size 4 -boot-info-table \
      -eltorito-alt-boot \
         -e boot/grub/efi.img \
         -no-emul-boot \
      "$ISODIR"
    ;;
  "UEFI-img")
    xorriso -as mkisofs \
      -r -V "Ubuntu-Auto" \
      -o "$OUTPUT" \
      -J -l -cache-inodes -iso-level 3 \
      -eltorito-alt-boot \
         -e boot/grub/efi.img \
         -no-emul-boot \
      "$ISODIR"
    ;;
  "UEFI-bootx64")
    echo "Attention: ISO Desktop moderne, pas de efi.img, construction UEFI-only..."
    xorriso -as mkisofs \
      -r -V "Ubuntu-Auto" \
      -o "$OUTPUT" \
      -J -l -cache-inodes -iso-level 3 \
      --efi-boot-part --efi-boot-image \
      -eltorito-alt-boot \
         -e EFI/boot/bootx64.efi \
         -no-emul-boot \
      "$ISODIR"
    ;;
esac

echo "ISO générée avec succès : $OUTPUT"

rm -rf "$WORKDIR"
