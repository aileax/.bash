#! /bin/bash

# ==================================================================================================
# INSTALLATION DES FICHIERS DE CONFIGURATION DE BASH => CUSTOM-BASH
# ==================================================================================================
# Fonctionnement
    # 1) Vérifie que bash est le shell par défaut, sinon stop E66
    # 2) Crée un fichier de sauvegarde caché ~./backupfiles/bash dans lequel déplacer les vieus dot.
    # 3) Crée pour les dotfiles se devant d'être localisés dans le $HOME des liens symboliques

# TODO
# [ ] FIX Fill_Full_PATH (l31) car erreur lors de l'utilisation sous sheel=ZSH! voir $(cd $(PWD))

# =[ CHECK_BASH ]===================================================================================
# Vérifie que le SHELL par défaut est bien bash,si non, demande user s'il veut le changer!
# On lance le test avant la déclaration des variables car selon le shell utilisé, elle peuvent
# causer des erreurs!
if [[ $SHELL != *"bash" ]];then
    echo "Installation ne peut se faire car $USER n'utilise pas bash comme shell mais $SHELL!"
    echo "Pour définir bash comme shell par défaut vous devez faire la commande 'chsh -s /bin/bash', puis redémarrer le terminal!"
    exit 22
else
    echo -e "L'installation de la configuration personnalisée du shell bash commence...\n"
fi

# =[ VARIABLES  ]===================================================================================
Prefix=$(date +%F)
# Déclaration conditionnelle de la variable du dossier dans lequel chercher les BDF
File_Full_Path=$(readlink -f $0)              #Récupère le chemin abs du script ds tous les cas!
Folder=${File_Full_Path//\/${0##*/}/}         #Soustrait au path le nom du script = dossier parent

# =[ FUNCTIONS ]====================================================================================

# -[ EXP_BASH_DIR ]---------------------------------------------------------------------------------
# S'assure de la valeur de $BASH_DIR, si correspond à valeur par défaut ne fair rien sinon corrige
exp_bash_dir () {
    bash_dir_profile=$(grep -E "^export BASH_DIR" ${Folder}/bash_profile | cut -d "\"" -f2)
    bash_dir_old=${bash_dir_profile}
    bash_dir_new=${Folder//$HOME/\$\{HOME\}}
    [[ "${bash_dir_old}" == "${bash_dir_new}" ]] && echo "BASH_DIR par défaut!" || (echo "Changement de la valeur de BASH_DIR:";sed -i "s,${bash_dir_old//\$/\\\$},${bash_dir_new//\$/\\\$},g" "$Folder/bash_profile";sed -i "s,${bash_dir_old//\$/\\\$},${bash_dir_new//\$/\\\$},g" "$Folder/bashrc")
    return 0
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
    return 0
}

# -[ SYMBOLINK ]------------------------------------------------------------------------------------
# Crée l'ensemble des liens symboliques pointant vers les bash_dotfiles (depend of git branch)
symbolinks() {
    if grep -qEi "(Microsoft)|WSL" /proc/version &> /dev/null; then
        ln -sv "${Folder}/bash_profile" ~/."bash_profile"
    else
        ln -sv "${Folder}/bash_profile" ~/."profile"
    fi
    ln -sv "${Folder}/bash_logout" ~/."bash_logout"
    ln -sv "${Folder}/bashrc" ~/."bashrc"
    return 0
}

# -[ END_INSTALL ]----------------------------------------------------------------------------------
# Fonction affichant le message de fin d'installation
end_install() {
    echo -e "\n L'installation est maintenant terminée. ;) "
    return 0
}

# =[ MAIN () ]======================================================================================
exp_bash_dir && archivage && symbolinks && end_install
