# 1 - Installation
Cette configuration personnelle de bash déclare et utilise une variable d'ENVIRONNEMENT nommée `BASH_DIR` correspondant
à la localisation de ce dossier git : `.bash/`

## 1.1 - Installation standart :
Par défaut, ce dossier contenant les dotfiles de bash se nomme `.bash/` et se situe dans le $HOME

Ainsi $BASH\_DIR=`$HOME/.bash`, et pour installer, de manière standart, les modifications de bash qu'il contient :

* 0 - Se placer dans le $HOME
* 1 - Cloner le repo dans le $HOME en tant que dotfile
* 2 - Lancer le script d'installaton
* 3 - Sourcer `bash_profile` pour rendre les changements effectifs dans le shell courant:

```bash
cd && git clone https://github.com/alterGNU/.bash.git && ./.bash/install.sh && source .bash/bash_profile
```

## 1.2 - Installation personnalisée : 
Il est aussi possible de changer l'emplacement et le nom du dossier cloné, ainsi $BASH\_DIR=`<localisation>/<nom-dossier>*`

Example avec :
- localisation=**~/.config** 
- nom-dossier=**bash**

```bash
git clone https://github.com/alterGNU/.bash.git ~/.config/bash && ~/.config/bash/install.sh && . ~/.config/bash/bash_profile
```
_Remarque : Cela est possible car à l'installation `install.sh` modifie si besoin la valeur $BASH_DIR dans
`bash_profile` ainsi que dans `bashrc` et ce en fonction du nom et de l'emplacement choisi par l'utilisateur.Ainsi cette
modification impliquera surement qu'un commit soit éfféctué car le dossier fraichement cloné est modifié :)_

# 2 - Désinstallation
Pour réstaurer la configuration initiale de bash (datant d'avant l'utilisation du script `install.sh` un script de
"désinstallation" nommé `restore_bash.sh` est présent.

Ainsi pour revenir à la configuration de bash précédente lancer ce script, ou tapez dans un terminal la commande :

```bash
restore_bash
```
_Alias lançant le script `restore\_bash.sh` suivi de cmd de sourçants les BDT initiaux pour appliquer leurs
configurations dans le shell courant. Cet alias est définit uniquement aprés installation via l'éxécution du script
`install.sh` car il utilise la varENV ${BASH_DIR}_

# 3 - TOC du dossier $BASH_DIR/
Ce dossier regroupant l'ensemble de mes configurations personnelles du shell bash contient :
- les fichiers de configuration de bash (**BDF** ~ _**B**ash **D**ot**F**iles_ ) et autres :
    - `aliases`  : **BDF** contenant la liste des aliases (partie de bashrc separée pour plus de lisibilité)
    - `bash_logout` : **BDF** chargé à chaque fermeture de session bash loguée.
    - `bashrc` : **BDF** chargé à chaque session interactive non-loguée.
    - `bash_profile` : **BDF** chargé à chaque session interactive loguée (bash source bash\_login).
    - `history` : **BDF** contient l'historique des commandes de bash
    - `README.md` : ...
- des scripts :
    - `bash.sh` : script d'installation des **BDF**
    - `restore_bash.sh` : script permettant de remettre à l'état initial (avant installation) l'ensemble des **BDF**
    - `speedswapper` : xmodmap file permettant d'intervertir les touches echape et majuscule(est lancée au demarrage et est appelé par la commande swap)
- une collection de **shell-function** (dossier `${BASH_DIR}/bin/`):
    - `ce` : Compile et Execute codes-source/scripts pour les langages: [C,Python,PythonCheckio,Java,bash]
    - `check_git` : vérifie qu'un dossier est bien dans l'arborescence d'un dépôt git local
    - `checkioWeb`: Vérifie le code passé en arg. sur checkio puis propose l'ouverture dans navigateur s'il est ok
    - `coucou` : créé pour apprendre à déclarer des fcts...inutile...
    - `is_in_arbo` : Vérifie si on se trouve bien dans un dossier git
    - `is_it_wls` : Vérifie si on se trouve sous Windows Sub-Systems for Linux
    - `nbr_agent-ssh` : Retourne le nombre d'agent ssh actif (methode:parcours `procfs`)
    - `ppticopy` : permet de copier des documents se trouvant sur la ppti vers mes appareils personnels
    - `swap` : Swapper des touches CAPSLOCK et ESCAPE
