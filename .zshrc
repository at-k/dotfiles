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

typeset -U path PATH
export PATH="$HOME/.bin:$PATH"

export LV="-c -Sh1;36 -Su1;4;32 -Ss7;37;1;33"
export LESS='-i -M -R'

case ${TERM} in
	xterm*)
		export TERM=xterm-256color;;
esac

# -- Plugin
if [ -d ~/.zplug ]; then
	source ~/.zplug/init.zsh

	zplug "zsh-users/zsh-completions"  # completion for other command, e.g. git
	zplug "zsh-users/zsh-syntax-highlighting", defer:3 # enable color cli

	zplug "mafredri/zsh-async", from:github
	zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

	zplug "greymd/tmux-xpanes"

	#zplug load --verbose
	zplug load
fi

# -- setting for pure
PURE_PROMPT_SYMBOL='>'
PROMPT='%(1j.[%j] .)%(?.%F{magenta}.%F{red})${PURE_PROMPT_SYMBOL:-❯}%f '
PURE_GIT_UNTRACKED_DIRTY=0

if [ -x "`which vboxmanage 2> /dev/null `" ]; then
	compdef vboxmanage=VBoxManage  # completion for vboxmanage
fi

if [ -x "`which sshrc 2> /dev/null `" ]; then
	compdef sshrc=ssh  # completion for sshrc
fi

fpath=($HOME/.config/zcompl(N-/) $fpath)

case ${OSTYPE} in
	cygwin)
		source ~/.zshrc.linux;;
	linux*)
		source ~/.zshrc.linux;;
	darwin*)
		source ~/.zshrc.mac;;
	*)
		echo "unknown OS type";;
esac

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
bindkey -e  # -e for Emacs style or -v for vim style

# -- History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt histignorealldups    # ignore duplicated command
setopt sharehistory         # share history with different terminal
setopt appendhistory        # share and append history from different zsh instance
setopt no_flow_control      # disable flow control to use C-s key stroke for fwd-i-search

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
alias ls='lscolor'
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

alias gs='git status -uno'
alias gsa='git status'
alias gl='git log'
alias gupstream='git remote get-url upstream | sed -e "s;.*github;https://github;" | sed "s;github.com:;github.com/;"'
alias gfetch-master='git fetch upstream && git checkout master && git merge upstream/master'

alias diff='diff -Bw'
alias vimdiff='vimdiff -c "set diffopt+=iwhite"'

alias zbench='time ( zsh -i -c exit)'

# delimiter definition to split words
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

alias bk='cd $OLDPWD'
s() { pwd > ~/.save_dir ; }
i() { cd "$(cat ~/.save_dir)" ; }

# hook `ls` on `cd` ... it might interrupt shell script. be careful.
function chpwd() {
	if [ 50 -gt `ls -1 | wc -l` ]; then
		case ${OSTYPE} in
			cygwin|linux*) ls --show-control-chars --color=auto -F ;;
			darwin*) ls -G ;;
		esac
	fi
}

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

function peco-select-history() {
	BUFFER="$(history -nr 1 | awk '!a[$0]++' | peco --query "$LBUFFER" | sed 's/\\n/;/g')"
	CURSOR=$#BUFFER             # カーソルを文末に移動
	zle -R -c                   # refresh
}
zle -N peco-select-history
bindkey '^R' peco-select-history

function cmd_exists() {
	test -x "`which $1 2> /dev/null`"
}

# xenv
if [ -d ~/.anyenv ]; then
	export PATH="$HOME/.anyenv/bin:$PATH" && eval "$(anyenv init - --no-rehash)"
	PY2_VERSION="2.7.14"
	PY3_VERSION="3.6.3"

	if [ -x "`which pyenv 2> /dev/null `" ]; then
		pyenv global $PY3_VERSION $PY2_VERSION
		export PATH="$HOME/.anyenv/envs/pyenv/versions/$PY3_VERSION/bin:$PATH"
		export PATH="$HOME/.anyenv/envs/pyenv/versions/$PY2_VERSION/bin:$PATH"
	fi

	if [ -d ~/go/bin ]; then
		export PATH="$HOME/go/bin:$PATH"
	fi
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
	RPROMPT="$AWS_PROMPT $KUBE_PROMPT"
}

function envk () {
	if [ -x "`which stern 2> /dev/null `" ]; then
		source <(stern --completion=zsh)
	fi
	if [ -x "`which kubectl 2> /dev/null `" ]; then
		source <(kubectl completion zsh)
	fi
	if [ -x "`which helm 2> /dev/null `" ]; then
		source <(helm completion zsh)
	fi
	if [ -x "`which minikube 2> /dev/null `" ]; then
		source <(minikube completion zsh)
	fi

	export KPROMPT_AVAILABLE=1
	alias k='kubectl'
	alias kns='(){ k config set-context $(kubectl config current-context) --namespace=$1}'
	compdef k=kubectl
}

function __set_kube_prompt () {
	local context=$(kubectl config current-context 2> /dev/null)
	local namespace=$(kubectl config view | grep namespace: | cut -d: -f2 | tr -d ' ' 2> /dev/null)

	KUBE_PROMPT="%F{green}${context}:%f%F{red}${namespace}%f"
	#PROMPT="%F{magenta}${context}:${namespace} "$PROMPT
}

function __set_aws_prompt () {
	local mode=$(awslogin -p)
	AWS_PROMPT="%F{magenta}${mode}"
}

# local limited
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

# keep this code end
if [ "$ZSH_PROFILE_MODE" ]; then
	if (which zprof > /dev/null 2>&1) ;then
	  zprof
	fi
fi
