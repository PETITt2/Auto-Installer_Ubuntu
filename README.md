[AUTO INSTALLER UBUNTU]

_ce repository a ete fais sur une version ubuntu 24.04.xx (je ne sais pas si il fonctionne avec les version anterieur ou ulterieur)_

====================  PREPARATIFS ====================

telecharger l'iso ubuntu : https://ubuntu.com/download/desktop

(Linux)____________________________________________________
|                                                           |
|  Télécharger mkisofs                                      |
|                                                           |
|  Ecrire sur une clé usb l'ISO                             |
|                                                           |
|  Extraire le .zip                                         |
|                                                           |
|  chmod +x autoinstallUbuntu.sh                            |
|                                                           |
|  sudo ./autoinstallUbuntu.sh /media$USER/UBUNTU           |
|___________________________________________________________|


(Windows)_________________________________
|                                         |
|  Télécharger Rufus                      |
|                                         |
|  Ecrire sur une clé usb l'ISO           |
|                                         |
|  Dans powershell en mode admin          |
|                                         |
|  ./autoinstallUbuntu.ps1 -UsbDrive E:   |
|_________________________________________|




Pour personnaliser des choses dans l'installation il faut modifier le fichier (user-data) crée dans les deux scripts.

Attention en modifiant user-data il suffit que le fichier contienne une seule erreur pour qui soit ignoré

Concernant le grub.cfg si vous avez un doute que celui-ci sois pris en compte pressez "e" lorsque le menu grub est affiché alors la boucle du fichier grub sera selectionné et on peut ensuite verifier son contenu.







pour des la documentation plus approfondie :

https://ubuntu.com/download/desktop
https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html

ce sont juste les deux sites classiques je me suis servie de bien d'autres sites mais je n'ai plus les liens...




                                                                                                                                                                                                                        _PETITt2
