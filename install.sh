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
        return 22
    else
        echo -e "L'installation de la configuration personnalisée du shell bash commence...\n"
    fi
    return 0
}

# -[ EXP_BASH_DIR ]---------------------------------------------------------------------------------
# S'assure de la valeur de $BASH_DIR, si correspond à valeur par défaut ne fair rien sinon corrige
exp_bash_dir () {
    bash_dir_profile=$(grep -E "^export BASH_DIR" ${Folder}/bash_profile | cut -d "\"" -f2)
    bash_dir_old=${bash_dir_profile}
    bash_dir_new=${Folder//$HOME/\$\{HOME\}}
    [[ "${bash_dir_old}" == "${bash_dir_new}" ]] && echo "BASH_DIR par défaut!" || (echo "Changement de la valeur de BASH_DIR:";sed -i "s,${bash_dir_old//\$/\\\$},${bash_dir_new//\$/\\\$},g" "$Folder/bash_profile")
}

# -[ ARCHIVAGE ]------------------------------------------------------------------------------------
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
    ln -sv "${Folder}/bash_profile" ~/."bash_profile"
    ln -sv "${Folder}/bash_logout" ~/."bash_logout"
}

# -[ END_INSTALL ]----------------------------------------------------------------------------------
# Fonction affichant le message de fin d'installation
end_install() {
    echo -e "\n L'installation est maintenant terminée. ;) "
    return 0
}

# =[ MAIN () ]======================================================================================
# quitte le script si bash n'est pas le shell utilisé
[[ check_bash_install ]] || exit 42
exp_bash_dir && archivage && symbolinks && end_install
