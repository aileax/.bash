#! /bin/bash

# ==================================================================================================
# INSTALLATION DES FICHIERS DE CONFIGURATION DE BASH => CUSTOM-BASH
# ==================================================================================================
# Script d'installation des bash_dotfiles
# [ ] 1) Vérifie que bash est le shell par défaut, sinon stop E66
# [X] 2) Crée un fichier de sauvegarde caché ~./backupfiles/bash dans lequel déplacer les vieus dot.
# [X] 3) Crée pour les dotfiles se devant d'être localisés dans le $HOME des liens symboliques

# =[ VARIABLES  ]===================================================================================
Current_User_SHELL=$(echo "$SHELL")
List_SHELLS=$(cat /etc/shells)
Bash_DotFiles=("bash_profile" "bash_logout")

# =[ FUNCTIONS ]==========================================================================

# -[ CHECK_BASH ]-------------------------------------------------------------------------
# Vérifie que le SHELL par défaut est bien bash,si non, demande user s'il veut le changer!
check_bash_install() {
    if [[ $Current_User_SHELL != *"bash" ]] ; then
        echo -e "Bash n'est pas le shell par défaut!"
        echo -e "L'installation ne se lance que s'il est le shell par defaut!"
        echo -e "Pour cela faire chsh -s /bin/bash"
        exit 66
    fi
    return 0
}

# -[ COPYCAT ]--------------------------------------------------------------------------------------
# Crée un dossier de sauvegarde contenant les anciens bash_dotfiles (mv commande)
archivage() {
    mkdir -p ~/.backupfiles/bash/
    for files in $(ls -a ~/ | grep bash);do
        mv ~/${files} ~/.backupfiles/bash/${files/'.'/} # crée une copie non caché (remplace '.' '')
    done
    if [[ -f ~/.profile ]]; then
        mv ~/.profile ~/.backupfiles/bash/profile
    fi
}

# -[ SYMBOLINK ]------------------------------------------------------------------------------------
# Crée l'ensemble des liens symboliques pointant vers les bash_dotfiles (depend of git branch)
symbolinks() {
    for files in "${Bash_DotFiles[@]}"; do
        ln -s ~/.dotfiles/bash/"${files}" ~/."${files}"
    done
}

# =[ MAIN () ]======================================================================================
check_bash_install && archivage && symbolinks

