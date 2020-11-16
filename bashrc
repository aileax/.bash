# ==================================================================================================
# BASHRC
# ==================================================================================================
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples

# ==================================================================================================
# VARIABLES
# ==================================================================================================
 
# -[ COULEURS UTILISÉES ]--------------------------------------------------------------------------
COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[0;33m"
COLOR_GREEN="\033[0;32m"
COLOR_OCHRE="\033[38;5;95m"
COLOR_BLUE="\033[0;34m"
COLOR_WHITE="\033[0;37m"
COLOR_RESET="\033[0m"

# -[ SHELL-NON-LOGUÉ ]-----------------------------------------------------------------------------
# Lorsque l'on se trouve dans un shell non logué, mime le foncitonnement de bash_login et logout
function shell_non_log(){
    # Partie mimant login->bash_profile
    export BASH_DIR="${HOME}/.bash"
    export HISTFILE="${BASH_DIR}/history"
    [[ -d ${BASH_DIR} ]] && . ${BASH_DIR}/aliases 
    [[ -d $BASH_DIR/bin ]] && export PATH="$BASH_DIR/bin:$PATH"
    [[ -d $HOME/.local/bin ]] && export PATH="$HOME/.local/bin:$PATH"
    [[ -d $HOME/usr/bin ]] && export PATH="$HOME/usr/bin:$PATH"
    [[ -d $HOME/bin ]] && export PATH="$HOME/bin:$PATH"
    # Partie mimant logout->bash_logout
    #alias :q="ask_to_kill_agent && exit"   # Décommenter une fois la fct créer  
    #alias exit="ask_to_kill_agent && exit" # Décommenter une fois la fct créer 
}
# Test si on est dans un shell non logué, et si oui mime le fonctionnement de bas_{login;logout}
shopt -q login_shell || shell_non_log

# -[ DÉBIAN_CHROOT ]-------------------------------------------------------------------------------
# Chroot:exécuter une commande ou un shell interactif avec un répertoire racine spécial
# CHangeROOT permet ainsi de changer le repertoire racine vers un nouvel emplacement
# IFSTAT: permettant d'attibuer à la varialbe debian_chroot le nom du chroot actuel
# Si VARENV:debian_chroot est vide et que le fichier /etc/debian_chroot est lisible:
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot) #Récupérer le nom debian_chroot dans le fichier
fi

# ==================================================================================================
# BASH-SETTINGS
# ==================================================================================================
 
# =[ INTERACTIF-SHELL ]=============================================================================
# Si pas shell interactif, ne fait rien
case $- in                  # $- contient les diffèrentes options du shell courant `himBH`
    *i*) ;;                 # s'il contient l'option i:interactive shell, ne rien faire
      *) return;;           # si shell pas interactif, retour
esac
 
# =[ SHELL-OPTIONS ]================================================================================
shopt -s checkwinsize       # Adapte en fonction de la taille de la fenêtre les ligne et colonnes
shopt -s globstar           # permet l'utilisation de ~/proc/**/stat dans le matching

# =[ HISTORIQUE ]===================================================================================
shopt -s histappend         # Ajoute au fichier historique, ne l'efface pas (same as >> )
HISTCONTROL=ignoreboth      # Pas de doublons ou de ligne vide dans l'historique
HISTSIZE=2500               # Taille de l'historique de commande gardé en mémoire
HISTFILESIZE=6000           # Taille du fichier d'historique de commande

# =[ COMPLETION ]===================================================================================
# enable programmable completion features (you don't need to enable this, if it's already enabled in
# /etc/bash.bashrc and /etc/profile
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# ==================================================================================================
# PERSONNALISATIONS
# ==================================================================================================
# =[ COMMANDES ]====================================================================================
# -[ LESS ]-----------------------------------------------------------------------------------------
# Si l'addon lesspipe est exécutable, l'utilisé pour rendre les fichiers non-text plus lisible
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# =[ PROMPT ]=======================================================================================
# -[ PS1 ]------------------------------------------------------------------------------------------
# Vérifie sur la plupart des devices le nombre de couleurs supportées par terminal
nbr_couleur=$(tput colors)
if [[ ${nbr_couleur} -gt 8 ]] ;then
    PS1="\[$COLOR_YELLOW\]${debian_chroot:+($debian_chroot)}\u\[$COLOR_RED\]@\[$COLOR_YELLOW\]\h\[$COLOR_BLEU\]: \[$COLOR_OCHRE\]\w \[$COLOR_RESET\]"
else
    PS1="${debian_chroot:+($debian_chroot)}\u@\h:\w\$"
fi

# -[ GIT-STATUS ]-----------------------------------------------------------------------------------
# Fct coloration en fct du status du git repo.
function git_color {
  local git_status="$(git status 2> /dev/null)"

  if [[ ! $git_status =~ "nothing to commit" ]]; then
    echo -e $COLOR_RED
  else
    echo -e $COLOR_GREEN
  fi
}

# Fct retournant le nom de la branch sur laquelle on se trouve
function git_branch {
    local git_status="$(git status 2> /dev/null)"
    local on_branch="On branch ([^${IFS}]*)"
    local on_commit="HEAD detached at ([^${IFS}]*)"
  
    if [[ $git_status =~ $on_branch ]]; then
        local branch=${BASH_REMATCH[1]}
        echo "($branch)"
    elif [[ $git_status =~ $on_commit ]]; then
        local commit=${BASH_REMATCH[1]}
        echo "($commit)"
    fi
}

# -[ PS1 MAIN() ]-----------------------------------------------------------------------------------
# Ajout du status du dépot git actuel ssi git est installé sinon mais juste le tilde
[[ check_git ]] && PS1+="\[\$(git_color)\]\$(git_branch)\[$COLOR_BLUE\]\$: \[$COLOR_RESET\]" || PS1+="\[$COLOR_BLUE\]\$: \[$COLOR_RESET\]"

