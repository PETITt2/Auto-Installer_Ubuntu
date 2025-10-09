╔════════════════════════════════════╗
║        🚀 AUTO INSTALLER UBUNTU     ║
╚════════════════════════════════════╝

Projet testé sur : Ubuntu 24.04.xx  
⚠️ Compatibilité non garantie avec d'autres versions.

──────────────────────────────────────────────
              🧰  PRÉPARATIFS
──────────────────────────────────────────────

Téléchargez l’image ISO :
→ https://ubuntu.com/download/desktop

──────────────────────────────────────────────
                 🐧  LINUX
──────────────────────────────────────────────

1. Installer mkisofs :
   sudo apt install mkisofs -y

2. Écrire l’image ISO sur une clé USB  
   (via “Disques”, “dd”, etc.)

3. Extraire le projet ZIP

4. Donner les droits d’exécution :
   chmod +x autoinstallUbuntu.sh

5. Lancer le script :
   sudo ./autoinstallUbuntu.sh /media/$USER/UBUNTU

💡 Astuces :
- mkisofs doit être installé
- Vérifiez le bon chemin de la clé
- Assurez-vous qu’elle soit bien montée

──────────────────────────────────────────────
                 🪟  WINDOWS
──────────────────────────────────────────────

1. Télécharger Rufus :
   https://rufus.ie/

2. Écrire l’image ISO sur une clé USB

3. Extraire le projet ZIP

4. Ouvrir PowerShell en mode admin

5. Lancer :
   ./autoinstallUbuntu.ps1 -UsbDrive E:

⚠️ Remplacez “E:” par la lettre de votre clé USB.

──────────────────────────────────────────────
       ⚙️  PERSONNALISATION DE L’INSTALLATION
──────────────────────────────────────────────

Les scripts créent un fichier :
→ user-data

Modifiez-le pour ajuster vos paramètres :
- utilisateurs
- packages
- configuration système

⚠️ Une seule erreur rendra le fichier invalide.  
Vérifiez-le avant exécution !

──────────────────────────────────────────────
                🧭  GRUB.CFG
──────────────────────────────────────────────

Si vous doutez qu’il soit pris en compte :
1. Au menu GRUB, pressez “E”
2. Vérifiez le contenu affiché
3. Confirmez que la bonne entrée est présente

──────────────────────────────────────────────
               📚  DOCUMENTATION
──────────────────────────────────────────────

Ubuntu Desktop :
→ https://ubuntu.com/download/desktop

Autoinstall Reference :
→ https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html

──────────────────────────────────────────────
                 👤  AUTEUR
──────────────────────────────────────────────

Projet : Auto Installer Ubuntu  
Auteur : PETITt2  
But : Simplifier et automatiser l’installation  
       d’Ubuntu depuis clé USB (Linux & Windows)

──────────────────────────────────────────────
✨  BONNE INSTALLATION & BON TEST ! ✨
──────────────────────────────────────────────
