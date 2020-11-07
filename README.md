# BASH
- Contient les fichiers de configuration de bash (bash_dotfiles) :
    - bash_profile : chargé à chaque session interactive loguée (bash source bash_login).
    - bashrc : chargé à chaque session interactive non-loguée.
    - bash_logout : chargé à chaque fermeture de session bash loguée.
- Contient un script d'installation des bash_dotfiles:
    - bash.sh : script permettant l'installation et mise à jour de mes bash_dotfiles
- Contient une Biblio-Perso ($BASH_DIR/bin/) de fonction shell:
    - `coucou` : fct créer pour tester les fcts....dit coucou ss paramètre et perroquet sinon

## Fonctionnement et Chargement des BDF (Bash-Dot-Files)
Les fichiers lus dépendent du type de shell:
- *Non-interactive* : shell non associé à un terminal (cas lors d'éxécution de script)
- *Interactive* : shell qui lis et écris dans un terminal d'utilisateur (Interpréteur de commande)
    - Loging : cas de Co. locale ou SSH ou `$ bash --login`
    ORDRE : /etc/profile >> ~/.bash_profile >> ~/.bash_login >> ~/.profile ( -f .bash_profil => .profil pas sourcé)
    - Non_loging: `$ bash`
    ORDRE : ~/.bashrc >> ~/.bash_login >> ~/.profile

## `~/.bash_profile` (Interactive loging shell) 
Dans `.profile on source bash_profile ssi le fichier existe`, ainsi il est
sourcé à chaque démarrage/ou/quand connection avec login :`$ bash --login`
On doit y placer les commandes ne devant s'exécutées qu'une seule fois!

### Ex1 : sourcer bashrc au début de chaque session
```bash
if [ -f ~/.bashrc ]; then . ~/.bashrc;fi
```

### Ex2 : Modification de variable environnementale
Il faut placer cette modification dans .bash_profile car sinon, dans .bashrc on aurait:
```bash
echo 'export PATH="$PATH:~/Fonctions/bin/"' >> ~/.bashrc
```

## `~/.bashrc` : (interactive non-loging shell)
Y placé les commandes devant s'éxécutées à chaque fois qu'on démarre le shell comme :
Sourcée au démarrage d'une session interactive sans login du shell: `$ bash`

### Ex1 : les  Aliases
On peut y placer les aliases, raccourcis de commande, en ajoutant simplement les lignes:
`alias ll="ls -la"` /* permet ensuite de ne taper que ll au lieu de ls -la*/
Cependant on préférera (sauf peut être pour la PPTI) les regroupés dans un fichier `aliases`
Ce fichier devrat alors etre sourcé à chaque démarrage (bash_login ou bashrc)

#### Cas particulier, alias alert utilisant notify-send sous WSL2...
Si on veux utiliser cet alias (mis par défaut) on se rend compte qu'il faut installer 415
paquets (dont ceux pour serveur X11) et le tout sans grande chance de fonctionner!
Une alternative serait d'utiliser les outils analogue sous windows comme [BurntToast](https://github.com/Windos/BurntToast)
(Voir l'astuce de [Blog CodeLearn](https://codelearn.me/2019/01/13/wsl-windows-toast.html)

### Ex2 : les Fonctions
Pour des 'raccourcis' plus élaborés, les aliases ne fonctionnent pas!!
Par exemple si on veut passer des arguments il faut utiliser des *fonctions*!
Prenons par exemple la fct créant et entrant dans un dossier, deux syntaxes possibles:
```bash
mkcd () {
    mkdir -p -- "$1" && cd -P -- "&1"
}
```
Ou plus succincte mais moins lisible:
```bash
function_name () { mkdir -p -- "$1" ;; cd -P -- "&1"}
```

Tout comme pour les aliases, on préférera déclarer ces fonctions ailleurs (plus claire).
Pour qu'elles soient fonctionnelles, il faudrat alors ajouter le repertoire les contenants
au PATH (bash_login).

### Custom Prompts

### History Customisation

## `~/.bash_logout` : (login shell)
Y placé les commandes que l'on souhaite exécuter lors de la déconnexion de la session.

### Ex1 : tuer le ssh-agent!
```bash
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `/usr/bin/ssh-agent -k`
fi
```

# Sources
- [Bash startup files](https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html#Bash-Startup-Files)
- [bashrc vs bash_profile](https://linuxize.com/post/bashrc-vs-bash-profile/)
- [Create bash aliases](https://linuxize.com/post/how-to-create-bash-aliases/)
- [Create bash functions](https://linuxize.com/post/bash-functions/)
