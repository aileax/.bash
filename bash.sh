#! /bin/bash

# ==================================================================================================
# INSTALLATION DES FICHIERS DE CONFIGURATION DE BASH => CUSTOM-BASH
# ==================================================================================================
# Script d'installation des bash_dotfiles
# [X] 1) Vérifie que bash est le shell par défaut, sinon stop E66
# [X] 2) Crée un fichier de sauvegarde caché ~./backupfiles/bash dans lequel déplacer les vieus dot.
# [X] 3) Crée pour les dotfiles se devant d'être localisés dans le $HOME des liens symboliques

# =[ VARIABLES  ]===================================================================================
Current_User_SHELL=$(echo "$SHELL")
List_SHELLS=$(cat /etc/shells)
Bash_DotFiles=("bash_profile" "bash_logout" ) #Liste des BDF pour lesquels créer des liens ds $HOME
Prefix=$(date +%F)
# Déclaration conditionnelle de la variable du dossier dans lequel chercher les BDF
File_Full_Path=$(readlink -f $0)              #Récupère le chemin abs du script ds tous les cas!
Folder=${File_Full_Path//\/${0##*/}/}         #Soustrait au path le nom du script = dossier parent

# =[ FUNCTIONS ]==========================================================================
# -[ CHECK_BASH ]-------------------------------------------------------------------------
# Vérifie que le SHELL par défaut est bien bash,si non, demande user s'il veut le changer!
check_bash_install() {
    if [[ $Current_User_SHELL != *"bash" ]] ; then
        echo -e "Bash n'est pas le shell par défaut!"
        echo -e "L'installation ne se lance que s'il est le shell par defaut!"
        echo -e "Pour cela faire chsh -s /bin/bash"
        exit 66
    else
        echo "L'installation de la configuration personnalisée du shell bash commence..."
    fi
    return 0
}

# -[ COPYCAT ]--------------------------------------------------------------------------------------
# Crée un dossier de sauvegarde contenant les anciens bash_dotfiles (mv commande)
archivage() {
    # Crée le dossier de sauvegarde : ~/.backupfiles/bash_YYYY-MM-DD
    mkdir -p ~/.backupfiles/bash_${Prefix}/
    # Boucle à la recherche des bash_dotfiles déjà présent dans le home au moment de l'installation
    for files in $(ls -a $HOME | grep bash);do
        # crée une copie non caché (remplace '.' '') si fichier existe et n'est pas un lien symbo.
        [[ -f ~/${files} ]] && [[ ! -L ~/${files} ]] && mv -v ~/${files} ~/.backupfiles/bash_${Prefix}/${files/'.'/}
    done
    # S'il existe un .profile (qui n'est pas un lien) le déplacé dans le dossier d'archivage.
    [[ -f ~/.profile ]] && [[ ! -L ~/.profile ]] && mv -v ~/.profile ~/.backupfiles/bash_${Prefix}/profile
}

# -[ SYMBOLINK ]------------------------------------------------------------------------------------
# Crée l'ensemble des liens symboliques pointant vers les bash_dotfiles (depend of git branch)
symbolinks() {
    for files in "${Bash_DotFiles[@]}"; do
        ln -s "${Folder//./}/${files}" ~/."${files}"
    done
}

# =[ MAIN () ]======================================================================================
check_bash_install && archivage && symbolinks
