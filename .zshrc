# -- Environment Variables
export LANG=ja_JP.UTF-8
export PAGER='less -is'
export EDITOR='vi'

if [ $SHELL != "/bin/zsh" ]; then
    export SHELL=/bin/zsh
fi

# -- Path
export PATH="/home/at/bin/Komodo-IDE/bin:$PATH"

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
##	;;
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

# auto cd
setopt auto_cd
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

#autoload -U colors
#colors
#case "${TERM}" in
#kterm*|xterm*)
#    export LSCOLORS=exfxcxdxbxegedabagacad
#    export LS_COLORS='di=34;01:ln=35:so=32:pi=33:ex=31;01:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#    zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
#    ;;
#cons25)
#   unset LANG
#   export LSCOLORS=ExFxCxdxBxegedabagacad
#   export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#   zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
#   ;;
#esac

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
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

# -- Alias
alias ls='ls --show-control-chars --color=auto -F'
alias la='ls -la'
alias ll='ls -l'
alias ue='cd ../'
alias cp='cp -i'
alias mv='mv -i'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

alias reloadsh='source ~/.zshrc'

alias hex2dec="printf '%d\n'"
alias dec2hex="printf '%x\n'"

alias bc="bc -l"

alias gcc='gcc -Wall'
alias g++='g++ -Wall'

alias -g G='| grep'
alias -g H='| head'
alias -g T='| tail'

alias grep='grep --color=auto -n'
alias sudo='sudo -E'

alias scr='screen -r'
alias scr_cpdir='screen -X register . "$(pwd)"'
alias scr_paste='screen -X paste .'

#alias python='ipython'

# for rythmbox
export GST_TAG_ENCODING=CP932

# for tmux
show-current-dir-as-window-name() {
    tmux set-window-option window-status-format " #I ${PWD:t} " > /dev/null
}

show-current-dir-as-window-name
add-zsh-hook chpwd show-current-dir-as-window-name

# for screen <ref -> http://ogawa.s18.xrea.com/tdiary/20080331.html
case "${TERM}" in screen)
    preexec() {
            echo -ne "\ek#${1%% *}\e\\"
        }
    precmd() {
         echo -ne "\ek$(basename $(pwd))\e\\"
       }
esac
echo -ne "\ek$(basename $(pwd))\e\\"

# for byobu
export VTE_CJK_WIDTH=1


# for python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PATH="$PYENV_ROOT/versions/anaconda3-4.2.0/bin/:$PATH"

# for proxy
# alias with_proxy='export http_proxy="http://10033136:$( read -s "pw?proxy password: "; echo 1>&2 ;echo $pw; unset pw )@133.144.14.243:8080/" '
# alias with_proxy_s='export http_proxy="http://10033136:$( read -s "pw?proxy password: " ; echo 1>&2 ;echo $pw; )@133.144.14.243:8080/" '


