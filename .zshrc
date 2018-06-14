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

	#zplug "zsh-users/zsh-completions", lazy:true   # completion for other command, e.g. git
	zplug "zsh-users/zsh-completions"  # completion for other command, e.g. git
	zplug "zsh-users/zsh-syntax-highlighting", defer:3 # enable color cli

	#zplug "peco/peco", as:command, from:gh-r, use:"*amd64*" # interactive filter

	zplug "mafredri/zsh-async", from:github
	if [ "$OSTYPE" != "cygwin" ]; then
		zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
	fi

	zplug "greymd/tmux-xpanes"

	#zplug load --verbose
	zplug load
fi

if [ -x "`which vboxmanage 2> /dev/null `" ]; then
	compdef vboxmanage=VBoxManage  # completion for vboxmanage
fi

if [ -x "`which sshrc 2> /dev/null `" ]; then
	compdef sshrc=ssh  # completion for sshrc
fi

fpath=($HOME/.config/zcompl(N-/) $fpath)

# -- Prompt ... now using the one served by plugin
if [ "$OSTYPE" = "cygwin" ]; then
	autoload -Uz promptinit; promptinit
	prompt adam1 # `prompt -p` shows other style
fi

# --- Color
if [ "$OSTYPE" != "cygwin" -a -f ~/.zsh/dircolors-solarized/dircolors.ansi-dark ]; then
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

# Less colors, available only in 256 color terminal(e.g. TERM=xterm-256color)
#      see also http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
if [ "$OSTYPE" != "cygwin" ]; then
	export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)					# begin blinking
	export LESS_TERMCAP_md=$(tput bold; tput setaf 74)  				# begin bold
	export LESS_TERMCAP_me=$(tput sgr0)									# end mode
	export LESS_TERMCAP_so=$(tput bold; tput setaf 7; tput setab 60)	# begin standout-mode - info box
	export LESS_TERMCAP_se=$(tput rmso; tput sgr0)						# end standout-mode
	export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 146)		# begin underline
	export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)						# end underline
	export LESS_TERMCAP_mr=$(tput rev)
	export LESS_TERMCAP_mh=$(tput dim)
	export LESS_TERMCAP_ZN=$(tput ssubm)
	export LESS_TERMCAP_ZV=$(tput rsubm)
	export LESS_TERMCAP_ZO=$(tput ssupm)
	export LESS_TERMCAP_ZW=$(tput rsupm)
	export GROFF_NO_SGR=1         # For Konsole and Gnome-terminal
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

if [ -x "`which peco 2> /dev/null `" ]; then
	function peco-select-history() {
		BUFFER="$(history -nr 1 | awk '!a[$0]++' | peco --query "$LBUFFER" | sed 's/\\n/;/g')"
		CURSOR=$#BUFFER             # カーソルを文末に移動
		zle -R -c                   # refresh
	}
	zle -N peco-select-history
	bindkey '^R' peco-select-history
fi

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
case ${OSTYPE} in
	cygwin|linux*) alias ls='ls --show-control-chars --color=auto -F';;
	darwin*) alias ls='ls -G';;
esac

alias la='ls -la'
alias ll='ls -l'
alias cp='cp -i'
alias mv='mv -i'
alias bc="bc -l"
case ${OSTYPE} in
	linux*)
		alias pbcopy='xsel --clipboard --input'
		alias pbpaste='xsel --clipboard --output';;
esac

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

alias gs='git status -uno'
alias gsa='git status'
alias gl='git log'

case ${OSTYPE} in
	cygwin|linux*)  alias ue='(){ cd $(seq -s"../" $((1 + ${1:-1})) | tr -d "[:digit:]")}';;
	darwin*)
		alias ue='(){ cd $(jot -s"../" $((1 + ${1:-1})) | tr -d "[:digit:]")}'
		alias ctags="`brew --prefix`/bin/ctags"
		;;
esac

# delimiter definition to split words
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

alias bk='cd $OLDPWD'
s() { pwd > ~/.save_dir ; }
i() { cd "$(cat ~/.save_dir)" ; }

function chpwd() { # hook `ls` on `cd` ... it might interrupt shell script. be careful.
	if [ 50 -gt `ls -1 | wc -l` ]; then
		case ${OSTYPE} in
			cygwin|linux*) ls --show-control-chars --color=auto -F;;
			darwin*) ls -G;;
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

alias zbench='time ( zsh -i -c exit)'

function cmd_exists() {
	test -x "`which $1 2> /dev/null`"
}

# for rythmbox
export GST_TAG_ENCODING=CP932

## for tmux
## if [ -x "`which tmux 2> /dev/null`" ]; then
#if type tmux > /dev/null 2>&1; then
#    show-current-dir-as-window-name() {
#        tmux set-window-option window-status-format " #I ${PWD:t} " > /dev/null
#    }
#
#	if $(tmux has-session); then
#		show-current-dir-as-window-name
#		add-zsh-hook chpwd show-current-dir-as-window-name
#	fi
#fi

# for screen (http://ogawa.s18.xrea.com/tdiary/20080331.html)
case "${TERM}" in screen)
	preexec() {
		echo -ne "\ek#${1%% *}\e\\"
	}
	precmd() {
		echo -ne "\ek$(basename $(pwd))\e\\"
	}
esac

# for byobu
if [ -d ~/.byobu ]; then
    export VTE_CJK_WIDTH=1
fi

# xenv
if [ -d ~/.anyenv ]; then
	export PATH="$HOME/.anyenv/bin:$PATH" && eval "$(anyenv init -)"
	PY2_VERSION="2.7.14"
	PY3_VERSION="3.6.3"

	if [ -x "`which pyenv 2> /dev/null `" ]; then
		pyenv global $PY3_VERSION $PY2_VERSION
		export PATH="$HOME/.anyenv/envs/pyenv/versions/$PY3_VERSION/bin:$PATH"
		export PATH="$HOME/.anyenv/envs/pyenv/versions/$PY2_VERSION/bin:$PATH"
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

# completion config for aws-cli, probably this must be put after python settings
case ${OSTYPE} in
	darwin*)
		if [ -f /usr/local/share/zsh/site-functions/_aws ]; then
			source /usr/local/share/zsh/site-functions/_aws
		fi
		;;
	linux*)
		if [ -x "`which aws_zsh_completer.sh 2> /dev/null `" ]; then
			local aws_comp=$(type aws_zsh_completer.sh|cut -d' ' -f 3)
			source ${aws_comp}
		fi
		;;
esac

if [ -x "`which kubectl 2> /dev/null `" ]; then
	source <(kubectl completion zsh)
fi
if [ -x "`which helm 2> /dev/null `" ]; then
	source <(helm completion zsh)
fi

# for proxy
# alias with_proxy='export http_proxy="http://10033136:$( read -s "pw?proxy password: "; echo 1>&2 ;echo $pw; unset pw )@133.144.14.243:8080/" '
# alias with_proxy_s='export http_proxy="http://10033136:$( read -s "pw?proxy password: " ; echo 1>&2 ;echo $pw; )@133.144.14.243:8080/" '

# for specific OS
case ${OSTYPE} in
	cygwin)
		alias op='cygstart'

		function cygupdate() {
			local setup=$(find / -maxdepth 1 -name "setup*.exe" | sed 's/\///')
			if [ -z ${setup} ]; then
				echo "error: current setup file not found"
			else
				mkdir -p /setup_backup
				mv /${setup} /setup_backup
				wget http://www.cygwin.com/${setup} -q
				if [ ! -f ${setup} ]; then
					echo "error: fail to download setup file from official"
				else
					chmod +x ${setup}
					mv ${setup} /
					echo "complete update"
				fi
			fi
		}
		;;
	linux*) alias op='gnome-open' ;;
	darwi*) alias op='open' ;;
esac

# local limited
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

if [ "$ZSH_PROFILE_MODE" ]; then
	if (which zprof > /dev/null 2>&1) ;then
	  zprof
	fi
fi
