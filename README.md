================================================================================
                       UBUNTU DESKTOP AUTOMATED INSTALLER
================================================================================
Ce projet explique comment créer une ISO Ubuntu Desktop personnalisée
qui installe le système automatiquement grâce à un fichier preseed.cfg.

Idéal pour déployer plusieurs machines identiques sans intervention manuelle.

--------------------------------------------------------------------------------
PRÉREQUIS
--------------------------------------------------------------------------------
- Une machine avec Ubuntu ou Linux pour générer l’ISO
- Paquets nécessaires :
    sudo apt update
    sudo apt install xorriso rsync wget nano

- Un fichier preseed.cfg prêt à l’emploi (exemple fourni ci-dessous)

--------------------------------------------------------------------------------
ÉTAPES DÉTAILLÉES
--------------------------------------------------------------------------------

1) Télécharger l’ISO Ubuntu Desktop
-----------------------------------
Exemple pour Ubuntu 22.04 :
wget https://releases.ubuntu.com/22.04/ubuntu-22.04.3-desktop-amd64.iso

2) Préparer le dossier de travail
---------------------------------
mkdir ~/ubuntu-auto
cd ~/ubuntu-auto
mkdir mnt iso

Monter l’ISO originale :
sudo mount -o loop ~/Téléchargements/ubuntu-22.04.3-desktop-amd64.iso mnt

Copier son contenu :
rsync -a mnt/ iso/
sudo umount mnt

3) Ajouter le fichier preseed.cfg
---------------------------------
cp ~/chemin/vers/preseed.cfg iso/preseed/custom.cfg

Exemple de preseed.cfg complet :

################################################################################
# LANGUE ET CLAVIER
d-i debian-installer/locale string fr_FR.UTF-8
d-i console-setup/ask_detect boolean false
d-i keyboard-configuration/layoutcode string fr

# FUSEAU HORAIRE
d-i time/zone string Europe/Paris

# PARTITIONNEMENT AUTOMATIQUE
d-i partman-auto/method string regular
d-i partman-auto/choose_recipe select atomic
d-i partman-auto/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

# UTILISATEUR PRINCIPAL
d-i passwd/user-fullname string Utilisateur
d-i passwd/username string user
d-i passwd/user-password password user123
d-i passwd/user-password-again password user123

# PAQUETS DE BASE ET LOGICIELS
tasksel tasksel/first multiselect standard, ubuntu-desktop
d-i pkgsel/include string openssh-server vim htop curl git

# POST-INSTALLATION : désactivation services + installation logiciels
d-i preseed/late_command string \
    in-target systemctl disable cups.service; \
    in-target systemctl disable avahi-daemon.service; \
    in-target apt-get -y install vlc gparted; \
    in-target echo "Installation auto terminée." > /home/user/INSTALL_OK.txt
################################################################################

4) Modifier GRUB pour charger le preseed
----------------------------------------
nano iso/boot/grub/grub.cfg

Rechercher les lignes contenant "linux /casper/vmlinuz" et ajouter :

file=/cdrom/preseed/custom.cfg auto=true priority=critical

Exemple final :

linux   /casper/vmlinuz file=/cdrom/preseed/custom.cfg auto=true priority=critical boot=casper maybe-ubiquity quiet splash ---
initrd  /casper/initrd

Vérifier et appliquer aux différentes entrées de menu (Try/Install/Recovery).

5) Modifier isolinux (BIOS legacy) - facultatif
------------------------------------------------
Si le fichier iso/isolinux/txt.cfg existe, ajoute la ligne suivante dans "append" :

append file=/cdrom/preseed/custom.cfg auto=true priority=critical initrd=/casper/initrd quiet splash ---

6) Recréer les checksums (facultatif)
--------------------------------------
cd iso
find . -type f ! -name md5sum.txt -print0 | xargs -0 md5sum > md5sum.txt
cd ..

7) Générer l’ISO bootable
--------------------------
cd iso
xorriso -as mkisofs -r -V "Ubuntu-Auto" \
  -o ../ubuntu-auto.iso \
  -J -l -cache-inodes -iso-level 3 -D \
  -b isolinux/isolinux.bin \
  -c isolinux/boot.cat \
  -no-emul-boot -boot-load-size 4 -boot-info-table \
  -eltorito-alt-boot \
  -e boot/grub/efi.img \
  -no-emul-boot \
  .

Résultat : ubuntu-auto.iso prêt à être testé.

8) Tester en machine virtuelle
------------------------------
qemu-system-x86_64 -m 2048 -enable-kvm -cdrom ../ubuntu-auto.iso

9) Mettre sur clé USB (attention, efface la clé)
------------------------------------------------
sudo dd if=ubuntu-auto.iso of=/dev/sdX bs=4M status=progress oflag=sync
Remplace /dev/sdX par ta clé USB (vérifier avec lsblk)

--------------------------------------------------------------------------------
CONSEILS
--------------------------------------------------------------------------------
- Testez toujours dans une VM avant de flasher une clé USB
- Vous pouvez créer plusieurs fichiers preseed.cfg pour différents types de postes
- Utilisez preseed/late_command pour lancer des scripts Bash complets
  (exemple : installation de logiciels supplémentaires, configuration réseau, etc.)
- Assurez-vous de modifier toutes les entrées de menu dans GRUB pour inclure votre preseed

--------------------------------------------------------------------------------
RÉSULTAT
--------------------------------------------------------------------------------
- Une clé USB d’installation Ubuntu Desktop entièrement automatique
- Déploiement rapide sur plusieurs PC sans intervention
- Fichier INSTALL_OK.txt créé à la fin pour vérifier la réussite de l’installation

--------------------------------------------------------------------------------
STRUCTURE DU PROJET
--------------------------------------------------------------------------------
ubuntu-auto/
├── mnt/                # ISO montée temporairement
├── iso/                # Contenu modifiable de l'ISO
│   ├── preseed/custom.cfg
│   ├── boot/grub/grub.cfg
│   ├── isolinux/txt.cfg (optionnel)
│   └── ...
└── ubuntu-auto.iso     # ISO finale bootable

================================================================================
                                FIN DU README
================================================================================
