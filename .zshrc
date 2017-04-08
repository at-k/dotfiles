# Path
export PATH="/home/at/bin/Komodo-IDE/bin:$PATH"

# Prompt
autoload -Uz promptinit
promptinit
prompt adam1

# Use emacs(-e) or vim(-v) keybindings even if our EDITOR is set to vi
bindkey -e
#bindkey -v

# History option
setopt histignorealldups sharehistory

# PushD
setopt auto_pushd
setopt pushd_ignore_dups

zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:descriptions' format '%BCompleting%b %U%d%u'


# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit && compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' menu select=1
# zstyle ':completion:*' menu select=2
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

# alias
alias ls='ls --show-control-chars --color=auto -F'
alias la='ls -la'
alias ll='ls -l'
alias ue='cd ../'
alias cp='cp -i'
alias mv='mv -i'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

alias hex2dec="printf '%d\n'"
alias dec2hex="printf '%x\n'"

alias bc="bc -l"

alias -g G='| grep'
alias -g H='| head'
alias -g T='| tail'

# auto cd
setopt auto_cd
function chpwd() { ls }

#alias python='ipython'

# for rythmbox
export GST_TAG_ENCODING=CP932

# for tmux
show-current-dir-as-window-name() {
    tmux set-window-option window-status-format " #I ${PWD:t} " > /dev/null
}

show-current-dir-as-window-name
add-zsh-hook chpwd show-current-dir-as-window-name

# for python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PATH="$PYENV_ROOT/versions/anaconda3-4.2.0/bin/:$PATH"
