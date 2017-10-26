# -- Environment Variables
export LANG=ja_JP.UTF-8
export MANPAGER="less -is"
export PAGER='less -is'
export EDITOR='vi'

export LV="-c -Sh1;36 -Su1;4;32 -Ss7;37;1;33"
export LESS='-i -M -R'

case ${TERM} in
	xterm*)
		export TERM=xterm-256color;;
esac

# -- Plugin
if [ -d ~/.zplug ]; then
	source ~/.zplug/init.zsh

	zplug "zsh-users/zsh-completions"				   # completion for other command, e.g. git
	zplug "zsh-users/zsh-syntax-highlighting", defer:3 # enable color cli

	zplug load --verbose
fi

# -- Prompt
autoload -Uz promptinit; promptinit
prompt adam1 # `prompt -p` shows other style

# --- Color
eval "$(dircolors -b)"  # setup LS_COLORS
# Less colors, available only in 256 color terminal(e.g. TERM=xterm-256color)
#      see also http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
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
function chpwd() { ls --show-control-chars --color=auto -F}  # hook `ls` on `cd` ... it might interrupt shell script. be careful.

# -- Completion
autoload -Uz compinit; compinit

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

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} #
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin


# -- Alias
alias ls='ls --show-control-chars --color=auto -F'
alias la='ls -la'
alias ll='ls -l'
alias cp='cp -i'
alias mv='mv -i'
alias bc="bc -l"
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

alias reloadsh='source ~/.zshrc'

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
alias gl='git log'

alias ue='(){ cd $(seq -s"../" $((1 + ${1:-1})) | tr -d "[:digit:]")}'
alias bk='cd $OLDPWD'
s() { pwd > ~/.save_dir ; }
i() { cd "$(cat ~/.save_dir)" ; }

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

# for python
if [ -d ~/.pyenv ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"

	if [ -d $PYENV_ROOT/versions/anaconda3-4.2.0/bin/ ]; then
		export PATH="$PYENV_ROOT/versions/anaconda3-4.2.0/bin/:$PATH"
	fi
fi

# for ruby
if [ -d ~/.rbenv ]; then
	eval "$(rbenv init - zsh)"
fi

# for golang
if [ -d ~/.go ]; then
	export GOPATH=$HOME/.go
	export PATH=$PATH:$GOPATH/bin
fi

# for proxy
# alias with_proxy='export http_proxy="http://10033136:$( read -s "pw?proxy password: "; echo 1>&2 ;echo $pw; unset pw )@133.144.14.243:8080/" '
# alias with_proxy_s='export http_proxy="http://10033136:$( read -s "pw?proxy password: " ; echo 1>&2 ;echo $pw; )@133.144.14.243:8080/" '

# for specific OS
if [ "$OSTYPE" = "cygwin" ]; then
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
elif [ "$OSTYPE" = "linux-gnu" ]; then
	alias op='gnome-open'
fi

# local limited
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

