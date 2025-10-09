##############################################################
#                     🚀 AUTO INSTALLER UBUNTU               #
##############################################################

Ce projet a été testé sur Ubuntu 24.04.xx
Je ne garantis pas la compatibilité avec les versions antérieures ou ultérieures.


==============================================================
                    🧰  PRÉPARATIFS
==============================================================

Téléchargez l’image ISO officielle :
➡ https://ubuntu.com/download/desktop


==============================================================
                        🐧  LINUX
==============================================================

1️⃣  Installer mkisofs :
    sudo apt install mkisofs -y

2️⃣  Écrire l’image ISO sur une clé USB
    (avec "Disques", "dd", ou un outil équivalent)

3️⃣  Extraire le .zip du projet

4️⃣  Donner les permissions d’exécution :
    chmod +x autoinstallUbuntu.sh

5️⃣  Lancer l’installation automatique :
    sudo ./autoinstallUbuntu.sh /media/$USER/UBUNTU


_________________________________________________________
|                                                       |
|  🔧 mkisofs doit être installé avant l’exécution       |
|  🧩 Remplacez /media/$USER/UBUNTU par le bon chemin    |
|  💾 Assurez-vous que la clé est bien montée            |
|_______________________________________________________|


==============================================================
                        🪟  WINDOWS
==============================================================

1️⃣  Télécharger Rufus :
     https://rufus.ie/

2️⃣  Écrire l’image ISO sur une clé USB avec Rufus

3️⃣  Extraire le projet ZIP

4️⃣  Ouvrir PowerShell en mode administrateur

5️⃣  Lancer la commande :
     ./autoinstallUbuntu.ps1 -UsbDrive E:


_________________________________________
|                                       |
|  ⚠️ Remplacez "E:" par la lettre      |
|  correspondant à votre clé USB.       |
|_______________________________________|


==============================================================
          ⚙️  PERSONNALISATION DE L’INSTALLATION
==============================================================

Les scripts créent automatiquement un fichier :
    user-data

👉 C’est ce fichier qu’il faut modifier pour personnaliser
   l’installation (utilisateurs, paquets, paramètres, etc.)

⚠️ ATTENTION :
Une seule erreur dans user-data peut faire échouer
l’installation complète.
Vérifiez toujours la validité du fichier avant exécution.


==============================================================
                    🧭  GRUB.CFG
==============================================================

Si vous avez un doute sur la prise en compte du fichier grub.cfg :

1. Lorsque le menu GRUB s’affiche, pressez la touche **E**
2. Le contenu du fichier GRUB sera affiché
3. Vérifiez que votre boucle personnalisée est bien présente


==============================================================
                   📚  DOCUMENTATION
==============================================================

Documentation officielle Ubuntu :
    https://ubuntu.com/download/desktop

Référence Canonical Autoinstall :
    https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html

(J’ai consulté d’autres sources, mais je n’ai plus les liens.)






                                                                                          _PETITt2_
