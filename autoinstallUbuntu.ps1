param(
    [Parameter(Mandatory=$true)]
    [string]$UsbDrive
)

# Normalise le chemin (ajoute \ si nécessaire)
if (-not ($UsbDrive.EndsWith('\'))) {
    $UsbDrive += '\'
}

# Vérifie si le lecteur existe
if (-not (Test-Path $UsbDrive)) {
    Write-Host "Erreur : le lecteur $UsbDrive n'existe pas." -ForegroundColor Red
    exit 1
}

$AutoDir = Join-Path $UsbDrive "autoinstall"
New-Item -ItemType Directory -Force -Path $AutoDir | Out-Null

# Fichier meta-data
@"
instance-id: iid-local01
local-hostname: ubuntu-autoinstall
"@ | Out-File -Encoding utf8 "$AutoDir\meta-data"

# Fichier user-data
@"
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

"@ | Out-File -Encoding utf8 "$AutoDir\user-data"

# grub.cfg
$GrubPath = Join-Path $UsbDrive "boot\grub\grub.cfg"
New-Item -ItemType Directory -Force -Path (Split-Path $GrubPath) | Out-Null

@"
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
"@ | Out-File -Encoding utf8 $GrubPath

Write-Host "✅ Fichiers créés dans : $AutoDir" -ForegroundColor Green
Write-Host "✅ grub.cfg mis à jour : $GrubPath" -ForegroundColor Green
