# 🚀 AUTO INSTALLER UBUNTU

> _Projet testé sur **Ubuntu 24.04.xx**._  
> ⚠️ La compatibilité avec d'autres versions n'est pas garantie.

---

## 🧰 PRÉPARATIFS

Téléchargez l’image ISO officielle :  
👉 [https://ubuntu.com/download/desktop](https://ubuntu.com/download/desktop)

---

## 🐧 Installation sous Linux

```

```

```bash
# 1️⃣ Installer mkisofs
sudo apt install mkisofs -y

# 2️⃣ Écrire l’image ISO sur une clé USB
# (via "Disques", "dd" ou un autre outil)

# 3️⃣ Extraire le .zip du projet

# 4️⃣ Donner les droits d’exécution
chmod +x autoinstallUbuntu.sh

# 5️⃣ Lancer l’installation
sudo ./autoinstallUbuntu.sh /media/$USER/UBUNTU
```

💡 **Conseils :**
- Assurez-vous que `mkisofs` est installé  
- Vérifiez le bon chemin de la clé (`/media/$USER/UBUNTU`)  
- La clé doit être montée avant d’exécuter le script

---

## 🪟 Installation sous Windows

```

```

```powershell
# 1️⃣ Télécharger Rufus :
#    https://rufus.ie/

# 2️⃣ Écrire l’image ISO sur la clé USB avec Rufus

# 3️⃣ Extraire le .zip du projet

# 4️⃣ Ouvrir PowerShell en mode administrateur

# 5️⃣ Lancer :
./autoinstallUbuntu.ps1 -UsbDrive E:
```

⚠️ Remplacez `E:` par la lettre correspondant à votre clé USB.

---

## ⚙️ Personnaliser l’installation

Les scripts créent un fichier :
```
user-data
```

Modifiez-le pour ajuster :
- les utilisateurs  
- les packages à installer  
- les paramètres système  

⚠️ **Attention** : une seule erreur dans `user-data` suffit à rendre le fichier invalide.  
Vérifiez toujours sa syntaxe avant d’exécuter le script.

---

## 🧭 Vérifier le `grub.cfg`

Si vous avez un doute sur la prise en compte du fichier :

1. Lorsque le menu **GRUB** s’affiche, pressez la touche **E**
2. Le contenu du fichier sera affiché
3. Vérifiez que la bonne configuration est bien présente

---

## 📚 Documentation utile

- [Ubuntu Desktop Download](https://ubuntu.com/download/desktop)  
- [Canonical Autoinstall Reference](https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html)

> _D’autres sources ont été consultées lors du développement,  
> mais leurs liens ne sont plus disponibles._

```
                                                                                                    ╔═════════════════════════════╗
                                                                                                    ║   🧡            _PETITt2_   ║
                                                                                                    ╚═════════════════════════════╝
```
