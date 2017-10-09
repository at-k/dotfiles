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

# -- Prompt
autoload -Uz promptinit
promptinit
prompt adam1

#case ${UID} in
#0)
#	RPROMPT="%B%{[00m%}%/#%{[m%}%b "
#	RPROMPT2="%B%{[00m%}%_#%{[m%}%b "
#	SPROMPT="%B%{[00m%}%r is correct? [n,y,a,e]:%{[m%}%b "
#	[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
#		PROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
#	;;
#*)
#	PROMPT="@%m%{[1;34m%}%#%{[m%} "
#	RPROMPT="%{[1;35m%}%/%{[m%} "
#	RPROMPT2="%/%{[1;34m%}%%%{[m%} "
#	SPROMPT="%{[00m%}%r is correct? [n,y,a,e]:%{[m%} "
##	[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
##		RPROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
#	;;
#esac

# -- Key Bind

# use emacs(-e) or vim(-v) keybindings even if our EDITOR is set to vi
bindkey -e
#bindkey -v

# -- History

# keep 1000 lines of history within the shell and save it
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# ignore duplicated command
setopt histignorealldups

# share history with different terminal
setopt sharehistory

# share and append history from different zsh instance
setopt appendhistory

# historical backward/forward search with linehead string binded to ^P/^N
# to understand it, try "C-P" after inputting `ls` command. very useful!
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# disable flow control to use C-s key stroke for fwd-i-search
setopt no_flow_control

# -- Glob (pattern matching for file name. wild card is a kind of glob)

# enable extended file pattern mattching
setopt extendedglob

# stop to make warning when it judge some character as file name and doesn't find any file
setopt nomatch

# -- Change directory
setopt auto_pushd
setopt pushd_ignore_dups

zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:descriptions' format '%BCompleting%b %U%d%u'

# auto cd (change directory without cd command)
setopt auto_cd

# hook ls on cd
function chpwd() { ls --show-control-chars --color=auto -F}

# -- Completion

# Use modern completion system
autoload -Uz compinit && compinit
setopt COMPLETE_IN_WORD

# command correct edition before each completion attempt
setopt correct

# compacked complete list display
setopt list_packed

# no remove postfix slash of command line
setopt noautoremoveslash

# no beep sound when complete list displayed
setopt nolistbeep

# aliased ls needs if file/dir completions work
setopt complete_aliases

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' menu select=1
# zstyle ':completion:*' menu select=2


# --- Color
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Less Colors for Man Pages <ref http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
# this configuration is available only in 256color environment (e.g. TERM=xterm-256color)
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
alias -g H='| head'
alias -g T='| tail'

alias grep='grep --color=auto'
# alias sudo='sudo -E'

alias scr='screen -r'
alias scr_cpdir='screen -X register . "$(pwd)"'
alias scr_paste='screen -X paste .'

# alias ue='cd ../'
alias ue='(){ cd $(seq -s"../" $((1 + ${1:-1})) | tr -d "[:digit:]")}'

# alias iro='for i in {0..255} ; do; printf "\x1b[38;5;${i}m${i} "; done'
alias iro='for i in {0..255} ; do; printf "\x1b[38;5;${i}m%03d " ${i}; done'

#alias python='ipython'

# for rythmbox
export GST_TAG_ENCODING=CP932

# for tmux
# if [ -x "`which tmux 2> /dev/null`" ]; then
if type tmux > /dev/null 2>&1; then
    show-current-dir-as-window-name() {
        tmux set-window-option window-status-format " #I ${PWD:t} " > /dev/null
    }

	if $(tmux has-session); then
		show-current-dir-as-window-name
		add-zsh-hook chpwd show-current-dir-as-window-name
	fi
fi

# for screen <ref -> http://ogawa.s18.xrea.com/tdiary/20080331.html
case "${TERM}" in screen)
	preexec() {
		echo -ne "\ek#${1%% *}\e\\"
	}
	precmd() {
		echo -ne "\ek$(basename $(pwd))\e\\"
	}
esac

# for byobu
export VTE_CJK_WIDTH=1

# for python
if [ -f ~/.pyenv/bin/pyenv ]; then
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

# for proxy
# alias with_proxy='export http_proxy="http://10033136:$( read -s "pw?proxy password: "; echo 1>&2 ;echo $pw; unset pw )@133.144.14.243:8080/" '
# alias with_proxy_s='export http_proxy="http://10033136:$( read -s "pw?proxy password: " ; echo 1>&2 ;echo $pw; )@133.144.14.243:8080/" '

# for specific OS
if [ "$OSTYPE" = "cygwin" ]; then
	alias op='explorer'
	alias doc=''
	alias ecl=''
	alias pow=''
elif [ "$OSTYPE" = "linux-gnu" ]; then
	alias op='gnome-open'
fi

# local limited
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

