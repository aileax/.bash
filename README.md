# Installation
Cloner le repo puis installer:
```bash
$ git clone git@github.com:alterGNU/bash.git && sh bash/test.sh
```
# BASH repo
- Contient des scripts :
    - `bash.sh` : script d'installation des **BDF** _Bash DotFiles_
    - `restore_bash_config.sh` : script permettant de remettre à l'état initiale (avant installation) l'ensemble des **BDT**
- Contient les fichiers de configuration de bash (Bash DotFiles ~ BDF) :
    - `bash_profile` : chargé à chaque session interactive loguée (bash source bash_login).
    - `bashrc` : chargé à chaque session interactive non-loguée.
    - `bash_logout` : chargé à chaque fermeture de session bash loguée.
- Contient une collection de fonction shell (dossier `bash/bin/*`):
    - `coucou` : fct créer pour tester les fcts....dit coucou ss paramètre et perroquet sinon
    - `nbr_agent-ssh` : Retourne le nombre d'agent ssh actif (methode parcourant procfs)
    - `check_git` : vérifie qu'un dossier est bien dans l'arborescence d'un dépôt git local

### RAPPELS : Fonctionnement et Ordre de chargement des BDF
Les fichiers lus dépendent du type de shell:
- **Non-interactive** : shell non associé à un terminal (cas lors d'éxécution de script)
- **Interactive** : shell qui lis et écris dans un terminal d'utilisateur (Interpréteur de commande)
    - Loging : cas de Co. locale ou SSH ou `$ bash --login`
    ORDRE : /etc/profile >> ~/.bash_profile >> ~/.bash_login >> ~/.profile ( -f .bash_profil => .profil pas sourcé)
    - Non\_loging: `$ bash`
    ORDRE : ~/.bashrc >> ~/.bash_login >> ~/.profile

## Fonctionnement des SCRIPTS
### `bash.sh`
Ce script correspond au script d'installation:
- 1 : **Vérifie** que le shell utilisé est bien **bash**, sinon quit _Error66_
- 2 : **Archive** dans le dossier ~/.backupfiles/ (le crée si besoin) l'ensemble des BDF actuels.
- 3 : **Crée** deux liens symboliques (indispensable) dans le $HOME : `~/.bash_profil` & `~/.bash_logout`

Afin de limiter au maximum la surcharge de $HOME par des dotfiles inutiles, on se limite aux deux liens ci-dessous.
Ceci est possible car `bash_login` source les fichiers `bashrc` et `aliases` _(inutile donc qu'ils soient présent dans
le $HOME)_

### `restore_bash.sh`
Ce script permet "d'annuler" les modifications apportées par `bash.sh`:
- 1 : **Supprime** les liens symboliques pointant vers des BDF s'ils existent
- 2 : **Restaure** dans le home l'ancienne version des BDF souhaitèes (présiser dans la variable `${OriginFolder}`)
- 3 : **Supprime** le dossier de sauvegarde ayant été créé aujourdhui... (utile pour phase de test successifs)

## Bash\_DotFiles
### `~/.bash_profile` (Interactive loging shell) _liensymbo_
Généralement, `.profile` source `bash_profile` s'il existe.
sourcé à chaque démarrage/ou/quand connection avec login :`$ bash --login`
On doit y placer les commandes ne devant s'exécutées qu'une seule fois:

- **VarENV** :
    - BASH\_DIR : localisation des BDF personnalisés
    - HISTFILE : localisation du fichier historique `.bash_history`
- **Source** : `bashrc` et `aliases`
- **Add2Path** : `bash/bin`

### `${BASH_DIR}/bashrc` : (interactive non-loging shell)
Y placé les commandes devant s'éxécutées à chaque fois qu'on démarre le shell comme :
Sourcée au démarrage d'une session interactive sans login du shell: `$ bash`

#### Custom Prompts
- `git_color`&`git_branch`: Permettent d'afficher dans le prompt l'état du dépot git local (vert:OK,rouge:PAS_ZOkÉ)

### `${BASH_DIR}/aliases`
Contient l'ensemble des alias (certains définis conditionnellement:)
#### Cas particulier, alias alert utilisant notify-send sous WSL2...
Si on veux utiliser cet alias (mis par défaut) on se rend compte qu'il faut installer 415
paquets (dont ceux pour serveur X11) et le tout sans grande chance de fonctionner!
Une alternative serait d'utiliser les outils analogue sous windows comme [BurntToast](https://github.com/Windos/BurntToast)
(Voir l'astuce de [Blog CodeLearn](https://codelearn.me/2019/01/13/wsl-windows-toast.html)

### `~/.bash_logout` : (login shell) _liensymbo_
Y placer les commandes que l'on souhaite exécuter lors de la déconnexion de la session.

### Ex1 : tuer le ssh-agent!
```bash
[[ check_ssh ]] && eval $(ssh-agent -k)
```

## `${BASH_DIR}/bin`:Fonctions/Commandes SHELL
### `$ coucou`
Fonction créée pour apprendre les règles de base d'écriture et d'éxécution de commande shell.(utilisation argument)

- Si aucun argument, retourne la phrase "coucou"
    ```bash
    $ coucou 
    Bonjour alter.GNU
    ```

- Si argument passé à la commande, fait le perroquet(retourne les arguments passé à la commande)
    ```bash
    $ coucou "Y a quelqu'un qui ma dit que..."
    "Y a quelqu'un qui ma dit que..."
    ```

- La commande accepter deux options `-q/--quit` ou `-h/--help`
    ```bash
    $ coucou -q "Y a quelqu'un qui ma dit que..."
    ssshhut!
    $ coucou -h
    ...
    AFFICHE L'USAGE
    ...
    ```
### `$ nbr_agent-ssh` 
**Retourne le nombre d'agent ssh actif (methode parcourant procfs).**
Cette fonction, peut donc être utiliser comme une fonctionnelle/un test!

Elle parcours le **procfs** à la recherche de processus s'appelant `(ssh-agent)`, si elle en trouve elle incrémente une
variable...puis la retourne.

Ainsi s'il n'y a pas d'SSH-AGENT en cours, elle retourne 0, sinon elle retourne le nombre de processus portant ce nom!

À l'instar des autre fonctions elle accepte en options:
- `-v/--verbose`: la rendant bavarde
-  `-h/--help`: affiche l'usage

### `$ check_git` 
**Vérifie qu'un dossier est bien dans l'arborescence d'un dépôt git local**:
- **Sans argument**, retourne 0 si on se trouve dans un dossier git, 8 sinon
- **Avec argument**, retoune 0 si l'argument est un dossier git, 28 sinon.

_Tout autre message d'erreurs (!= 8 ou 28) correspond à ue mauvaise utilisation_

Elle admet aussi deux options :
- `-v/--verbose`: la rendant bavarde
-  `-h/--help`: affiche l'usage

# Sources
- [Bash startup files](https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html#Bash-Startup-Files)
- [bashrc vs bash_profile](https://linuxize.com/post/bashrc-vs-bash-profile/)
- [Create bash aliases](https://linuxize.com/post/how-to-create-bash-aliases/)
- [Create bash functions](https://linuxize.com/post/bash-functions/)
