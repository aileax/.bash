# ==================================================================================================
# BASH_PROFILE
# ==================================================================================================
# /usr/share/doc/bash/examples/startup-files for examples.

# the default umask is set in /etc/profile; for setting the umask for ssh logins, install and
# configure the libpam-umask package.
#umask 022

# =[ VAR-ENV ]======================================================================================
BASH_DIR="~/.dotfiles/bash"           # VarENV: dossier contenant les Bash_DotFiles

# =[ SOURCE ]=======================================================================================
# Sources les fichiers bashrc et bash_aliases s'ils existent
[[ -d $HOME/.dotfiles ]] && . $BASH_DIR/bashrc
[[ -d $HOME/.dotfiles ]] && . $BASH_DIR/aliases

# =[ PATH ]=========================================================================================
# Ajoute au PATH différents repo possible de bin perso s'ils existent
[[ -d $BASH_DIR/bin ]] && export PATH="$BASH_DIR/bin:$PATH"
[[ -d $HOME/.local/bin ]] && export PATH="$HOME/.local/bin:$PATH"
[[ -d $HOME/usr/bin ]] && export PATH="$HOME/usr/bin:$PATH"
[[ -d $HOME/bin ]] && export PATH="$HOME/bin:$PATH"

