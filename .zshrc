# -- Compile zshrc
if [ ! -f ~/.zshrc.zwc -o ~/.zshrc -nt ~/.zshrc.zwc ]; then
	echo "zshrc is updated. generating zshrc.zwc..."
	zcompile ~/.zshrc
fi

# -- Environment Variables
export LANG=ja_JP.UTF-8
export MANPAGER="less -is"
export PAGER='less -is'
export EDITOR='vim'
export AWS_PAGER=''

typeset -U path PATH
export PATH="$HOME/.bin:$PATH"

export LV="-c -Sh1;36 -Su1;4;32 -Ss7;37;1;33"
export LESS='-i -M -R'

case ${TERM} in
	xterm*)
		export TERM=xterm-256color;;
esac

# -- zplug
#export ZPLUG_HOME=/usr/local/opt/zplug
#if [ -d $ZPLUG_HOME ]; then
#    source $ZPLUG_HOME/init.zsh
#
#	zplug "zsh-users/zsh-completions"  # completion for other command, e.g. git
#    zplug "zsh-users/zsh-autosuggestions"
#	zplug "zsh-users/zsh-syntax-highlighting", defer:3 # enable color cli
#
#	zplug "mafredri/zsh-async", from:github
#	# zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
#    # zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, from:github, as:theme
#
#	zplug "greymd/tmux-xpanes"
#
#	#zplug load --verbose
#	zplug load
#fi

# -- zplugin
source $HOME/.zplugin/bin/zplugin.zsh
autoload -Uz _zplugin

if [[ ! -f ${HOME}/.zplugin/bin/zplugin.zsh.zwc ]]; then
    zplugin self-update
fi

(( ${+_comps} )) && _comps[zplugin]=_zplugin

zplugin light romkatv/zsh-defer

zplugin light greymd/tmux-xpanes

zplugin ice wait'0c' lucid atload'_zsh_autosuggest_start'
zplugin light zsh-users/zsh-autosuggestions

# zplugin ice wait'1' lucid atinit"ZPLGM[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay"
zplugin ice wait'1' lucid
zplugin light zdharma/fast-syntax-highlighting

zplugin ice wait'1' lucid
zplugin light zsh-users/zsh-completions

zplugin ice wait lucid
zplugin light mafredri/zsh-async

# zplugin ice pick'spaceship.zsh' wait'!0'
# zplugin light 'denysdovhan/spaceship-zsh-theme'

ZPLGM[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay

# -- setting for pure
# local number_of_jobs="%(1j.%F{208} / %f%F{226}%B%j%b%f.)"
# local number_of_jobs="%(1j.[%j] .)%"

# PURE_PROMPT_SYMBOL='>'
# PROMPT="${number_of_jobs} $PROMPT"
# PURE_GIT_UNTRACKED_DIRTY=0

# -- setting for spaceship-prompt
# SPACESHIP_PROMPT_ORDER=(user host dir git kubecontext node exec_time line_sep jobs vi_mode exit_code char)
# SPACESHIP_KUBECONTEXT_SHOW=false

# -- starship prompt
eval "$(starship init zsh)"

# -- completion
fpath=($HOME/.config/zcompl(N-/) $fpath)
autoload -U +X bashcompinit && bashcompinit

if [ -x "`which vboxmanage 2> /dev/null `" ]; then
	compdef vboxmanage=VBoxManage  # completion for vboxmanage
fi

if [ -x "`which sshrc 2> /dev/null `" ]; then
	compdef sshrc=ssh  # completion for sshrc
fi

if [ -x "`which terraform 2> /dev/null `" ]; then
    alias tplan="terraform plan | landscape"
    alias tf='terraform'
    complete -C terraform terraform
    compdef tf=terraform
fi

if [ -x "`which aws_completer 2> /dev/null `" ]; then
    complete -C '/usr/local/bin/aws_completer' aws
fi

# --- Load OS specific setting
case ${OSTYPE} in
	cygwin)
		source ~/.config/zsh/zshrc.linux;;
	linux*)
		source ~/.config/zsh/zshrc.linux;;
	darwin*)
		source ~/.config/zsh/zshrc.mac;;
	*)
		echo "unknown OS type";;
esac

# --- Mouse setting w/ tmux
if [ -f ~/.bin/mouse.zsh ]; then
    source ~/.bin/mouse.zsh
    zle-toggle-mouse
fi

# --- Color
if [ -f ~/.zsh/dircolors-solarized/dircolors.ansi-dark ]; then
	if type dircolors > /dev/null 2>&1; then
		eval $(dircolors ~/.zsh/dircolors-solarized/dircolors.ansi-dark)
	elif type gdircolors > /dev/null 2>&1; then
		eval $(gdircolors ~/.zsh/dircolors-solarized/dircolors.ansi-dark )
	fi
else
	if type dircolors > /dev/null 2>&1; then
		eval $(dircolors -b)  # setup LS_COLORS
	fi
fi

# -- Key Bind
#bindkey -e  # -e for Emacs style or -v for vim style
bindkey -v  # -e for Emacs style or -v for vim style
bindkey -M viins '\er' history-incremental-pattern-search-forward
bindkey -M viins '^?'  backward-delete-char
bindkey -M viins '^A'  beginning-of-line
bindkey -M viins '^B'  backward-char
bindkey -M viins '^D'  delete-char-or-list
bindkey -M viins '^E'  end-of-line
bindkey -M viins '^F'  forward-char
bindkey -M viins '^G'  send-break
bindkey -M viins '^H'  backward-delete-char
bindkey -M viins '^K'  kill-line
bindkey -M viins '^N'  down-line-or-history
bindkey -M viins '^P'  up-line-or-history
bindkey -M viins '^R'  history-incremental-pattern-search-backward
bindkey -M viins '^U'  backward-kill-line
bindkey -M viins '^W'  backward-kill-word
bindkey -M viins '^Y'  yank

# setting for vim mode to show normal or insert for spaceship
#function zle-line-init zle-keymap-select {
#    # VIM_NORMAL="%K{208}%F{black}⮀%k%f%K{208}%F{white} % NORMAL %k%f%K{black}%F{208}⮀%k%f"
#    # VIM_INSERT="%K{075}%F{black}⮀%k%f%K{075}%F{white} % INSERT %k%f%K{black}%F{075}⮀%k%f"
#    # RPS1="${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT}"
#    # RPS2=$RPS1
#    zle reset-prompt
#}
#zle -N zle-line-init
#zle -N zle-keymap-select
#
##SPACESHIP_VI_MODE_INSERT="%K{075}%F{black}⮀%k%f%K{075}%F{white} % INSERT %k%f%K{black}%F{075}⮀%k%f"
#SPACESHIP_VI_MODE_INSERT="%K{118}%F{white}% [I]%k%f"
#SPACESHIP_VI_MODE_NORMAL="%K{075}%F{white}% [N]%k%f"

# -- History
HISTSIZE=100000
SAVEHIST=1000000
HISTFILE=~/.zsh_history

setopt histignorealldups    # ignore duplicated command
setopt sharehistory         # share history with different terminal
setopt appendhistory        # share and append history from different zsh instance
setopt no_flow_control      # disable flow control to use C-s key stroke for fwd-i-search
setopt hist_reduce_blanks
setopt inc_append_history
setopt hist_verify

# historical backward/forward search. e.g. try `C-p` after typing `ls`
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# -- Glob (pattern matching for file name. wild card is a kind of glob)
setopt extendedglob # enable extended file pattern mattching
setopt nomatch      # stop to make `not-found` warning on judging a character as file name

# -- Change directory
setopt auto_pushd
setopt pushd_ignore_dups
setopt auto_cd

# -- Completion
#autoload -Uz compinit; compinit # zplug call it earlier

setopt complete_in_word     # run completion at cursor position
setopt correct              # command correct before each completion attempt
setopt list_packed          # compacked complete list display
setopt noautoremoveslash    # no remove postfix slash of command line
setopt nolistbeep           # no beep sound when complete list displayed
setopt complete_aliases     # aliased ls needs if file/dir completions work

zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:descriptions' format '%BCompleting%b %U%d%u'

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*:manuals' separate-sections true

if [ -n "$LS_COLORS" ]; then
	zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
fi
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# -- Alias
#alias ls='lscolor'
alias ls='ls -G'
alias la='ls -la'
alias ll='ls -l'
alias cp='cp -i'
alias mv='mv -i'
alias bc="bc -l"

alias reloadsh='source ~/.zshrc'
alias reloadlsh='source ~/.zshrc.local'
alias clearcmp='rm ~/.zcompdump 2> /dev/null; rm ~/.zplug/zcompdump 2> /dev/null; exec $SHELL -l'

alias hex2dec="printf '%d\n'"
alias dec2hex="printf '%x\n'"
alias dec2bin='(){ echo "obase=2; ibase=10; ${1}" | bc }'
alias tox='(){ echo "obase=${2}; ibase=${1}; ${3}" | bc }'

alias gcc='gcc -Wall'
alias g++='g++ -Wall'

alias -g G='| grep'
alias -g S='| sed'
alias -g H='| head'
alias -g T='| tail'

alias grep='grep --color=auto'
# alias sudo='sudo -E'

alias scr='screen -r'
alias scr_cpdir='screen -X register . "$(pwd)"'
alias scr_paste='screen -X paste .'

alias iro='for i in {0..255} ; do; printf "\x1b[38;5;${i}m%03d " ${i}; done'
alias iro-e='for i in {0..255} ; do; echo -e "\e[${i}m ${i}"; done'

alias g='git'
compdef g=git

alias diff='diff -Bw'
alias vimdiff='vimdiff -c "set diffopt+=iwhite"'

alias zbench='time ( zsh -i -c exit)'

alias ecr-login='aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 057575985710.dkr.ecr.ap-northeast-1.amazonaws.com'

function alogin() {
    awslogin $@
    source ~/.zshrc.local
}

# delimiter definition to split words
# export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " _-./;@"
zstyle ':zle:*' word-style unspecified

alias bk='cd $OLDPWD'
s() { pwd > ~/.save_dir ; }
i() { cd "$(cat ~/.save_dir)" ; }

# hook `ls` on `cd` ... it might interrupt shell script. be careful.
#function chpwd() {
#	if [ 50 -gt `ls -1 | wc -l` ]; then
#		case ${OSTYPE} in
#			cygwin|linux*) ls --show-control-chars --color=auto -F ;;
#			darwin*) ls -G ;;
#		esac
#	fi
#}

function decomp() {
	case $1 in
		*.tar.gz|*.tgz) tar xzvf $1;;
		*.tar.xz) tar Jxvf $1;;
		*.zip) unzip $1;;
		*.lzh) lha e $1;;
		*.tar.bz2|*.tbz) tar xjvf $1;;
		*.tar.Z) tar zxvf $1;;
		*.gz) gzip -d $1;;
		*.bz2) bzip2 -dc $1;;
		*.Z) uncompress $1;;
		*.tar) tar xvf $1;;
		*.arj) unarj $1;;
	esac
}
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=decomp

function comp() {
	if [ $# = 0 ]; then
		echo "no input"
	else
		local aname
		aname=$1.tgz
		tar cfvz $aname $@
	fi
}

# function peco-select-history() {
# 	BUFFER="$(history -nr 1 | awk '!a[$0]++' | peco --query "$LBUFFER" | sed 's/\\n/;/g')"
# 	CURSOR=$#BUFFER             # カーソルを文末に移動
# 	zle -R -c                   # refresh
# }
# zle -N peco-select-history
# bindkey '^R' peco-select-history

function cmd_exists() {
	test -x "`which $1 2> /dev/null`"
}

# xenv
if [ -d ~/go/bin ]; then
    export PATH="$HOME/go/bin:$PATH"
fi
if [ -d ~/.anyenv ]; then
    export ANYENV_ENABLE=false
    function enva() {
        export PATH="$HOME/.anyenv/bin:$PATH" && eval "$(anyenv init - --no-rehash)"
        export ANYENV_ENABLE=true
        # PY2_VERSION="2.7.14"
        # PY3_VERSION="3.6.3"

        # if [ -d ~/.anyenv/envs/pyenv ]; then
        #     pyenv global $PY3_VERSION $PY2_VERSION
        #     export PATH="$HOME/.anyenv/envs/pyenv/versions/$PY3_VERSION/bin:$PATH"
        #     export PATH="$HOME/.anyenv/envs/pyenv/versions/$PY2_VERSION/bin:$PATH"
        #     eval "$(pyenv virtualenv-init -)"
        #     eval "$(pyenv init -)"
        # fi

        # if [ -d ~/go/bin ]; then
        #     export GOPATH=$HOME/go
        # fi

        # if [ -x "`which terraform 2> /dev/null `" ]; then
        #     tfenv use 0.13.0
        #     complete -C /usr/local/Cellar/tfenv/2.0.0/versions/0.12.20/terraform terraform
        # fi
    }
else
	# for python
	if [ -d ~/.pyenv ]; then
		export PYENV_ROOT="$HOME/.pyenv"
		export PATH="$PYENV_ROOT/bin:$PATH" && eval "$(pyenv init - --no-rehash)"

		if [ -d $PYENV_ROOT/versions/anaconda3-4.2.0/bin/ ]; then
			export PATH="$PYENV_ROOT/versions/anaconda3-4.2.0/bin/:$PATH"
		fi
	fi

	# for ruby
	if [ -d ~/.rbenv ]; then
		eval "$(rbenv init - --no-rehash)"
	fi

	# for node.js
	if [ -d ~/.ndenv ]; then
		export PATH="$HOME/.ndenv/bin:$PATH" && eval "$(ndenv init -)"
	fi

	# for golang
	if [ -d ~/.go ]; then
		export GOPATH=$HOME/.go
		export PATH=$PATH:$GOPATH/bin
	fi
fi
if [ -x "`which direnv 2> /dev/null `" ]; then
	eval "$(direnv hook zsh)"
fi

# rprompt setting
add-zsh-hook precmd __set_context_prompt
setopt transientrprompt
function __set_context_prompt() {
	if [ "$KPROMPT_AVAILABLE" = 1 ]; then
		__set_kube_prompt
	fi
	__set_aws_prompt
    __set_xenv_prompt
	RPROMPT="$XENV_PROMPT $AWS_PROMPT $KUBE_PROMPT"
}

function envk () {
    #SPACESHIP_KUBECONTEXT_SHOW=true
	if [ -x "`which stern 2> /dev/null `" ]; then
		source <(stern --completion=zsh)
	fi
	if [ -x "`which kubectl 2> /dev/null `" ]; then
		source <(kubectl completion zsh)
	fi
	if [ -x "`which helm 2> /dev/null `" ]; then
		source <(helm completion zsh)
	fi
	# if [ -x "`which minikube 2> /dev/null `" ]; then
	# 	source <(minikube completion zsh)
	# fi
	if [ -x "`which eksctl 2> /dev/null `" ]; then
        eksctl completion zsh > ~/.config/zcompl/_eksctl
    fi

    if [ -f ~/.config/zsh/kubectlrc ]; then
        source ~/.config/zsh/kubectlrc
    fi

	export KPROMPT_AVAILABLE=1
    # for helm-secret (issue:https://github.com/futuresimple/helm-secrets/issues/71)
    export PATH="/usr/local/Cellar/gnu-getopt/1.1.6/bin":$PATH
	alias k='kubectl'
    alias kc='kubectx'
    alias kn='kubens'
	compdef k=kubectl
	compdef kc=kubectx
	compdef kn=kubens
}

# zsh-defer -t 2 envk

function envk-off () {
    SPACESHIP_KUBECONTEXT_SHOW=false
}

function __set_kube_prompt () {
	# local context=$(kubectl config current-context 2> /dev/null)
    # local namespace=$(kubectl config view | yq -r '.contexts[] | select( .name | test("'$context'")) | .context.namespace')

	# KUBE_PROMPT="%F{green}${context}:%f%F{red}${namespace}%f"
    KUBE_PROMPT="%F{green}k8s"
	#PROMPT="%F{magenta}${context}:${namespace} "$PROMPT
}

function __set_aws_prompt () {
	local mode=$(awslogin -p)
	AWS_PROMPT="%F{magenta}${mode}"
}

function __set_xenv_prompt() {
    if [ $ANYENV_ENABLE = true ]; then
        XENV_PROMPT="%F{yellow}any"
    fi
}

function zload {
    if [[ "${#}" -le 0 ]]; then
        echo "Usage: $0 PATH..."
        echo 'Load specified files as an autoloading function'
        return 1
    fi

    local file function_path function_name
    for file in "$@"; do
        if [[ -z "$file" ]]; then
            continue
        fi

        function_path="${file:h}"
        function_name="${file:t}"

        if (( $+functions[$function_name] )) ; then
            # "function_name" is defined
            unfunction "$function_name"
        fi
        FPATH="$function_path" autoload -Uz +X "$function_name"

        if [[ "$function_name" == _* ]]; then
            # "function_name" is a completion script

            # fpath requires absolute path
            # convert relative path to absolute path with :a modifier
            fpath=("${function_path:a}" $fpath) compinit
        fi
    done
}

# jq  key completion
function jq() {
    if [ -f $1 ]; then
        FILE=$1; shift
        # Move FILE at the end as expected by native jq
        command jq "$@" "$FILE"
    else
        command jq "$@"
    fi
}

function _jq() {
    COMPREPLY=()
    local curr prev
    curr=$2
    prev=$3
    #set -x
    case $COMP_CWORD in
        1)
            COMPREPLY=( $(compgen -f -- $curr) )
            ;;
        2)
            keys=$(command jq -c 'paths | map(.|tostring)|join(".")' $prev  | tr -d '"' | sed 's=^=\.=')

            COMPREPLY=( $(compgen -W "$keys" -- $curr ) )
            ;;
    esac
}
complete -F _jq jq

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# local limited
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# keep this code end
if [ "$ZSH_PROFILE_MODE" ]; then
	if (which zprof > /dev/null 2>&1) ;then
	  zprof
	fi
fi

