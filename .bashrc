# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-*color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
# GNU tools from MacPorts, to install run:
#   sudo port install coreutils +with_default_names
if [ -x /opt/local/libexec/gnubin/dircolors ]; then
    alias dircolors=/opt/local/libexec/gnubin/dircolors
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -FGlAhp'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

export PATH=/usr/local/bin:$PATH

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

alias ipynb='jupyter notebook'
alias rmpyc='find . -name \*.pyc -delete'

command_exists () {
    type "$1" &> /dev/null ;
}

if ! command_exists nproc; then
    alias nproc='sysctl -n hw.ncpu'
fi

drun(){
    IMAGE=$1
    if [ -z "$3" ]
    then
	MAXCPU=`nproc`
	let MAXCPU=MAXCPU-1
        CPUSET=0-$MAXCPU
    else
	CPUSET=$3
    fi
    if hash nvidia-docker 2>/dev/null; then
        RUNTIME_OPT=--runtime=nvidia
    fi
    CMD=$2
    docker pull $1
    NAME=`id -un`_${CMD}_`cat /dev/urandom | tr -cd 'a-f0-9' | head -c 8`
    FULLCMD="docker run -it --rm $RUNTIME_OPT --net=host --security-opt seccomp=unconfined -v /nfs:/nfs -v=`pwd`:`pwd` -w=`pwd` --cpuset-cpus $CPUSET --name $NAME $IMAGE $CMD"
    echo $FULLCMD
    $FULLCMD
}

export WORKON_HOME=~/.venvs
mkdir -p $WORKON_HOME
source /usr/local/bin/virtualenvwrapper.sh

function get_aws_vault_profile() {
    [ -z $AWS_VAULT ] && return
    echo -n "aws:$AWS_VAULT "
}

PS1='$(get_aws_vault_profile)'"$PS1"
export PS1

alias goaws='aws-vault exec --no-session --assume-role-ttl=12h terraformer@rkr-compute && workon aws'

function workflows() {
    STATUS=$1
    argo list | awk '/data-workflow/' | awk -v pat=$STATUS '$0 ~ pat {print $1}' | xargs -L1 argo get
}
