# enable for profiling
# zmodload zsh/zprof && zprof

# {{ -- p10k cocnfiguraiton, added automatically
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# }}

# {{ -- compile zshrc
if [ ! -f ~/.zshrc.zwc -o ~/.zshrc -nt ~/.zshrc.zwc ]; then
	zcompile ~/.zshrc
fi
# }}

# {{ -- env vars
export LANG=ja_JP.UTF-8
export MANPAGER="less -is"
export PAGER='less -is'
export EDITOR='nvim'
export AWS_PAGER=''
export LV="-c -Sh1;36 -Su1;4;32 -Ss7;37;1;33"
export LESS='-i -M -R'

case ${OSTYPE} in
	darwin*)
		eval $(/opt/homebrew/bin/brew shellenv);;
esac

typeset -U path PATH; export PATH="$HOME/.bin:$HOME/.mybin:$PATH:$HOME/.mybin/terraform:$HOME/.mybin/github:$HOME/.mybin/aws"
case ${TERM} in
	xterm*)
		export TERM=xterm-256color;;
esac
# }}

# {{ -- zinit config
# memo: sh -c "$(curl -fsSL https://git.io/zinit-install)"
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
# }}

# {{ -- plugin
zinit ice depth=1; zinit light romkatv/powerlevel10k

zinit light romkatv/zsh-defer

zinit light greymd/tmux-xpanes

zinit light asdf-vm/asdf

DIRCOLORS_SOLARIZED_ZSH_THEME="ansi-light"
zinit ice wait lucid
zinit light pinelibg/dircolors-solarized-zsh

zinit ice wait'0c' lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

zinit ice wait'1' lucid
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice wait lucid atload"zicompinit; zicdreplay" blockf for zsh-users/zsh-completions

zinit ice wait lucid
zinit light mafredri/zsh-async

zsh-defer -t 1 -c 'autoload -Uz compinit && compinit && zinit cdreplay -q'
zsh-defer -t 1 -c 'autoload -U +X bashcompinit && bashcompinit' # for aws-cli
# }}

# {{ -- completion
fpath=($HOME/.config/zcompl(N-/) $fpath)
# autoload -U +X bashcompinit && bashcompinit

# }}

# {{ -- OS specific setting
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
# }}

## {{ -- Mouse setting w/ tmux
#if [ -f ~/.bin/mouse.zsh ]; then
#    source ~/.bin/mouse.zsh
#    zle-toggle-mouse
#fi
## }}

# {{ -- key bind
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
# }}

# {{ -- history setting
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
# }}

# {{ -- glob
setopt extendedglob # enable extended file pattern mattching
setopt nomatch      # stop to make `not-found` warning on judging a character as file name
setopt no_nomatch
# }}

# {{ -- cd behavior
setopt auto_pushd
setopt pushd_ignore_dups
setopt auto_cd
# }}

# {{ -- completion config
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
# }}

# {{ -- command edit
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
# }}

# {{ -- alias
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

alias docker-sweep='(){ docker rmi $(docker images -q) && docker rm -v $(docker ps -qa)}'

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
alias gcdr='cd $(git root)'

alias vim='nvim'
alias v='nvim'

alias diff='diff -Bw'
# alias vimdiff='vimdiff -c "set diffopt+=iwhite"'
alias vimdiff='nvim -d '

alias zbench='time ( zsh -i -c exit)'

alias ecr-login='aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 057575985710.dkr.ecr.ap-northeast-1.amazonaws.com'
alias tf-search='gh repo list C-FO -l hcl --limit 1000 | fzf | cut -f1 | xargs -I{} gh repo view {}'


alias myip='curl httpbin.org/ip'

# }}

# {{ -- misc
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="/usr/local/Cellar/gnu-getopt/1.1.6/bin":$PATH

# delimiter definition to split words
# export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " _-./;@"
zstyle ':zle:*' word-style unspecified

[[ $commands[direnv] ]] && eval "$(direnv hook zsh)"
# }}

# {{ -- load file
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

[[ -f ~/.fzf.zsh ]] && zsh-defer source ~/.fzf.zsh

# alias for specific commands
[[ -f ~/.config/zsh/kubectl.zsh ]] && source ~/.config/zsh/kubectl.zsh
[[ -f ~/.config/zsh/aws.zsh ]] && source ~/.config/zsh/aws.zsh
[[ -f ~/.config/zsh/terraform.zsh ]] && source ~/.config/zsh/terraform.zsh

[[ -f ~/.config/zsh/completion.zsh ]] && zsh-defer -t 1 source ~/.config/zsh/completion.zsh

# [[ -f ~/.config/zsh/anyenv.zsh ]] && zsh-defer -t 1 source ~/.config/zsh/anyenv.zsh # too slow

[[ -f ~/.config/zsh/utils.zsh ]] && zsh-defer -t 1 source ~/.config/zsh/utils.zsh

[[ -f ~/.iterm2_shell_integration.zsh ]] && source ~/.iterm2_shell_integration.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# }}

# {{ zinit
# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust
# }}

# keep this code end
if (which zprof > /dev/null 2>&1) ;then
  zprof
fi
