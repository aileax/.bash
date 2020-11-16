# ==================================================================================================
# BASH_LOGOUT
# ==================================================================================================
 
# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy
if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

# -[ KILL-SSH ]-------------------------------------------------------------------------------------
# Permet à la déconnexion de tuer le ssh-agent s'il est en cours d'exécution
nbr_agent-ssh || eval $(ssh-agent -k) #eval 2 really unset Envar!
