#! /bin/bash
 
# ==================================================================================================
# REMISE AUX CONDITIONS INITIALES D'INSTALLATION POUR TESTER LE SCRIPTS BASH.SH
# ==================================================================================================

# Prépare avant le lancement du script d'installation bash.sh
# [X] 1) Supprime les liens symboliques si précédemment créés par un bash.sh
# [X] 2) Récupère dans le dossiers backup les anciens fichiers et les copies dans le HOME
# [X] 3) Supprime les anciens dossiers créer ayant pour noms celui du dossier backup du jour

# =[ VARIABLES  ]===================================================================================
BackFold="$HOME/.backupfiles"             # Dossier contenant les Backup Folders
OriginFolder=$(ls -d ${BackFold}/*/ | grep -E "*bash.{11}/$" | sort | head -n 1)
#OriginFolder="${BackFold}/<non_dossier>/ # Décommenter si déclaration manuelle(commenter ci-dessus)
Bash_DotFiles=("bash_profile" "bashrc" "bash_logout" "aliases" "profile")
Prefix=$(date +%F)
# Déclaration conditionnelle de la variable du dossier dans lequel chercher les BDF
[[ -d ${BASH_DIR} ]] && Folder="${BASH_DIR}" || Folder=${0//${0##*/}/}

# =[ FUNCTIONS ]==========================================================================
# -[ ERASE_LINKS ]----------------------------------------------------------------------------------
# Vérifie si des liens symboliques menant vers des BDF ont précédemment étés créés et le supprime.
Erase_Links() {
    for file in "${Bash_DotFiles[@]}"; do
        [[ -L ~/.${file} ]] && rm -v ~/.${file}
    done
    return 0
}

# -[ RESTORE_INIT ]---------------------------------------------------------------------------------
# Restaure les BDF initiaux dans le home pour simuler un état initiale(avant personnalisation)
Restore_Init() {
    # Boucle copiant les fichiers initiaux dans le home
    for file in $(ls ${OriginFolder});do
        cp -v ${OriginFolder}${file} ${HOME}/.${file}
    done
    return 0
}

# -[ CLEAN_DAILY_SAVED ]----------------------------------------------------------------------------
# Supprime le dossier de sauvegarde d'ajourdhui s'il est créé
Clean_Daily_Saved() {
    # Efface la sauvegarde du jour si elle existe
    DailySaveFolder="${BackFold}/bash_${Prefix}"
    [[ -d ${DailySaveFolder} ]] && rm -rfv ${DailySaveFolder}
    return 0
}

# =[ MAIN () ]======================================================================================
Erase_Links && Restore_Init && Clean_Daily_Saved
