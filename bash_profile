# ==================================================================================================
# BASH_PROFILE
# ==================================================================================================
# /usr/share/doc/bash/examples/startup-files for examples.

# the default umask is set in /etc/profile; for setting the umask for ssh logins, install and
# configure the libpam-umask package.
#umask 022

# =[ VAR-ENV ]======================================================================================
BASH_DIR="${HOME}/bash" # Chemin par défaut du dossier contenant les BDF.

# =[ SOURCE ]=======================================================================================
# Sources les fichiers bashrc et bash_aliases en les :
# Localisant dans le home par défaut si la varENV BASH_DIR est vide
# à la localisation de $BASH_DIR si cette dernière est définie et correspond à un dossier
[[ -d ${BASH_DIR} ]] && . ${BASH_DIR}/bashrc 
[[ -d ${BASH_DIR} ]] && . ${BASH_DIR}/aliases 

# =[ PATH ]=========================================================================================
# Ajoute au PATH différents repo possible de bin perso s'ils existent
[[ -d $BASH_DIR/bin ]] && export PATH="$BASH_DIR/bin:$PATH"
[[ -d $HOME/.local/bin ]] && export PATH="$HOME/.local/bin:$PATH"
[[ -d $HOME/usr/bin ]] && export PATH="$HOME/usr/bin:$PATH"
[[ -d $HOME/bin ]] && export PATH="$HOME/bin:$PATH"

