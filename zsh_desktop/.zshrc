#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# ZSH ONLY!!!
# Make ls use natural sort
alias ls="${aliases[ls]:-ls} -v"

# disable AUTO_CD
unsetopt AUTO_CD

# Customize to your needs...
DOTFILES_DIR="$HOME/.dotfiles"

# autoenv
if [ -f '/usr/share/autoenv/activate.sh' ]; then
    AUTOENV_AUTH_FILE=~/.autoenv_authorized
    AUTOENV_ENV_FILENAME='env'
    #AUTOENV_LOWER_FIRST=''
    source '/usr/share/autoenv/activate.sh'
fi

# direnv

if which direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# aliases
alias ping8='ping -c3 8.8.8.8'
alias pingg='ping -c3 www.google.com'
alias mmv='noglob zmv -W'

alias gtar='tar pcvzf'
alias btar='tar pcvjf'
alias untar='tar xvf'
alias ungtar='tar xvzf'
alias unbtar='tar xvjf'
alias cputemp="watch -n 1 -d sensors"

# Journalctl aliases
alias jctl=journalctl
alias jspy='jctl -f'

# Systemctl aliases
alias reload='sudo systemctl reload'
alias restart='sudo systemctl restart'
alias start='sudo systemctl start'
alias sctl='sudo systemctl'
alias status='systemctl -l status'
alias stop='sudo systemctl stop'

# docker
alias dc='docker-compose'
alias dm='docker-machine'
alias dockviz='docker run --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz images -t'

dcx() {
    cmd=$2
    cmd=${2:-/bin/bash}
    docker-compose exec $1 $cmd
}

dcl() {
    docker-compose logs -ft $1
}

dtest() {
    if [ ! -z $1 ]
    then
        docker run --rm -it $1 /bin/bash
    else
        echo 'Please provide an image!'
    fi
}

dexec() {
    if [ ! -z $1 ]
    then
        docker exec -it $1 /bin/bash
    else
        echo 'Please provide a running container!'
    fi
}

# docker-get-container-id
# Give the container name and get the container's id.
# If no name is specified, return the most recent container.
dgc() {
    if [ ! -z  $1 ]
    then
        docker ps | grep $1 | awk '{print $1}'
    else
        docker ps -q | head -n1
    fi
}


dvolume() {
    if [ ! -z $1 ]
    then
        docker run --rm -v $1:/volume -it pmav99/u14:latest
    else
        echo 'Please provide a volume!'
    fi
}

u14() {
    if [ ! -z $1 ]
    then
        echo $@
        docker run --rm $@ -it pmav99/u14:latest
    else
        docker run --rm -it pmav99/u14:latest
    fi
}

u16() {
    if [ ! -z $1 ]
    then
        echo $@
        docker run --rm $@ -it pmav99/u16:latest
    else
        docker run --rm -it pmav99/u16:latest
    fi
}

hadolint() {
    if [ ! -z $1 ]
    then
        docker run --rm -i lukasmartinelli/hadolint < $1
    else
        docker run --rm -i lukasmartinelli/hadolint < Dockerfile
    fi
}

makemine(){
    sudo chown "${USER}":"${USER}" $@
}

bigfiles() {
    if (( $# < 1 )); then
        echo 'usage: bigfiles DIRECTORY [NO_FILES]'
        return 1
    fi
    search_dir=$1
    if [[ ! -z $2 ]]; then
        no_files=$2
    else
        no_files=10
    fi
    find $search_dir -type f -exec du -ah {} + | sort -hr | head -n $no_files
}

update_awesome_menu() {
    if which xdg_menu &> /dev/null; then
        rm -rf ~/.config/awesome/archmenu.lua
        xdg_menu --format awesome --root-menu /etc/xdg/menus/arch-applications.menu > ~/.config/awesome/archmenu.lua
    else
        echo "Please install xdg-menu (archlinux-xdg-menu)."
    fi
}
# aliases
export R_LIBS="$HOME/.R"

## Python aliases
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Prog/venvs
alias pw="pew workon"
alias jn="jupyter notebook"
alias rmpyc="find ./ -name '*.pyc' -delete"
alias rmtex="find . -type f \( -name '*.aux' -o -name '*.glo' -o -name '*.idx' -o -name '*.log' -o -name '*.toc' -o -name '*.ist' -o -name '*.acn' -o -name '*.acr' -o -name '*.alg' -o -name '*.bbl' -o -name '*.blg' -o -name '*.dvi' -o -name '*.glg' -o -name '*.gls' -o -name '*.ilg' -o -name '*.ind' -o -name '*.lof' -o -name '*.lot' -o -name '*.maf' -o -name '*.mtc' -o -name '*.thm' -o -name '*.nav' -o -name '*.snm' -o -name '*.out' -o -name '*.synctex.gz' -o -name '*.mtc1' -name '*.bcf' -name '*.fls' -name '*.run.xml' \) -delete"

# find aliases
alias f="find ./ -name"
if which ffind &> /dev/null; then
    alias ff='ffind'
fi

# Tree aliases
treex()   { tree ${1:-./} -C -v --dirsfirst -P "*.$1" }
treepy()  { tree ${1:-./} -C -v --dirsfirst -P '*.py|*.ini|*.cfg|*.conf|*.json|*.html|*.jinja' -I '*__pycache__|*.pyc' }
treejs()  { tree ${1:-./} -C -v --dirsfirst -P '*.html|*.css|*.js' }
treedoc() { tree ${1:-./} -C -v --dirsfirst -P '*.tex|*.html|*.rest|*.md|*.rst|*.txt' }
treegit() {
    # A tree command that respects .gitgnore!
    # http://unix.stackexchange.com/a/291283/37579
    git_ignore_file=$( git config --get core.excludesfile )
    if [[ -f "${git_ignore_file}" ]] ; then
        tree -I"$( tr '\n' '\|' < "${git_ignore_file}" )" "${@}"
    else
        tree "${@}"
    fi
}
alias qg='qgit --all'

# Python Template files
alias pyinit="cp $DOTFILES_DIR/templates/pyinit.py $1"
alias pymain="cp $DOTFILES_DIR/templates/pymain.py $1"
alias pyskel="cp $DOTFILES_DIR/templates/pyskel.py $1"
alias pytest="cp $DOTFILES_DIR/templates/pytest.py $1"
alias bashskel="cp $DOTFILES_DIR/templates/bashskel.py $1"

# Bootstrap
alias bootstrap="cp $DOTFILES_DIR/templates/bootstrap.html $1"

# Get weather on CLI!
weather() {
    if [ ! -z $1 ]
    then
        curl -4 http://wttr.in/$1
    else
        curl -4 http://wttr.in/Rethymno
    fi
}


# an extract command
x() {
    local c e i

    (($#)) || return

    for i; do
        c=''
        e=1

        if [[ ! -r $i ]]; then
            echo "$0: file is unreadable: \`$i'" >&2
            continue
        fi

        case $i in
            *.tar) c=(bsdtar xvf);;
            *.tar.bz) c=(bsdtar xvf);;
            *.t@(gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz)))))
                   c=(bsdtar xvf);;
            *.7z)  c=(7z x);;
            *.Z)   c=(uncompress);;
            *.bz2) c=(bunzip2);;
            *.exe) c=(cabextract);;
            *.gz)  c=(gunzip);;
            *.rar) c=(unrar x);;
            *.xz)  c=(unxz);;
            *.zip) c=(unzip);;
            *)     echo "$0: unrecognized file extension: \`$i'" >&2
                   continue;;
        esac

        command "${c[@]}" "$i"
        ((e = e || $?))
    done
    return "$e"
}

# skype hack
export PULSE_LATENCY_MSEC=60

# A quick httpserver. You can define the port (defaults to 8000). E.g.:
# httpserver 8080
httpserver() {
    python2 -m SimpleHTTPServer $1 || python3 -m http.server $1
}

# a pretty print command. Works with xml and json.
pprint() {
    local c i

    (($#)) || return

    for i; do
        c=''

        if [[ ! -r $i ]]; then
            echo "$0: file is unreadable: \`$i'" >&2
            continue
        fi

        case $i in
            *.xml)  c=(xmllint --format);;
            *.json) c=(python -m json.tool);;
            *)      echo "$0: unrecognized file extension: \`$i'" >&2
                    continue;;
        esac

        command "${c[@]}" "$i"
        ((e = e || $?))
    done
    return "$e"
}


ssh_dcos () {
  if [ -z "$1" ]; then
    echo "No task name was specified"
    return 1
  fi
  task_name=$1
  node_ip=$(dcos task | grep "^${task_name}\s"  | awk '{print $2}')
  if [ -z "$node_ip" ]; then
    echo "No task named <$task_name> was found."
    return 2
  fi
  ssh -A -t centos@marathon.mesos ssh -A -t centos@${node_ip}
}


ssh_dcos () {
  master_hostname='marathon.mesos'
  master_ip=$(getent hosts "${master_hostname}" | cut -d' ' -f1 | head -n 1)
  node_octet="${1}"
  if [ -z "${node_octet}" ]; then
    echo "No ip was specified"
    return 1
  fi
  node_ip=$(sed "s/\.[0-9]*$/.${node_octet}/" <<< "${master_ip}")
  ssh -A -t centos@"${master_hostname}" ssh -A -t centos@"${node_ip}"
}


myip() {
    if which dig &> /dev/null; then
        dig +short myip.opendns.com @resolver1.opendns.com
    else
        curl -s http://whatismyip.akamai.com/
    fi
}

mylocalip() {
    python -c "import socket; print(socket.gethostbyname(socket.gethostname()))"
}

openports() {
    watch -n 1 -d -x sudo netstat -lntpu
}


### Append folders to PATH
# custom scripts
path+=("$DOTFILES_DIR/bin/")

# Texlive
path+=("/usr/local/texlive/2016/bin/x86_64-linux")
export INFOPATH=$INFOPATH:/usr/local/texlive/2016/texmf-dist/doc/info
export MANPATH=$MANPATH:/usr/local/texlive/2016/texmf-dist/doc/man

# ruby gems
#path+=$(ruby -e "puts Gem.user_dir")/bin

# NTFY notifications
if which ntfy  &> /dev/null; then
    eval "$(ntfy shell-integration)"
fi

mkdir -p ~/.wheelhouse
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export PIP_WHEEL_DIR=~/.wheelhouse
export PIP_FIND_LINKS=~/.wheelhouse
export JAVA_OPTS="-Xmx2048M -Xms32M"
export GOPATH=~/Prog/go
export GEM_HOME=$(ruby -e 'print Gem.user_dir')

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
alias vz'=gvim $(fzf)'
