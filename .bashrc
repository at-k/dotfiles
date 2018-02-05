#!/bin/bash

export CLICOLOR=1
export LANG="en_US.UTF-8"
export EDITOR="vim"
export export LS_COLORS='di=01;35'

if [ $USER = "kawamura-atsushi" -o $USER = "akawamura" ]; then
	#export PS1="\[\033[35m\]\t\]\[\033[m\] @\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
	export PS1="\[\033[35m\]\t\]\[\033[m\] \[\033[32m\]\h ${AWS_STAGE_NAME}-${AWS_ROLE_NAME}\n\[\033[33;1m\]\w\[\033[m\] \$ "
else
	export PS1="\[\033[35m\]\t\[\033[m\]-\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
fi

### Append to the history file
shopt -s histappend

### Check the window size after each command ($LINES, $COLUMNS)
shopt -s checkwinsize

### Better-looking less for binary files
[ -x /usr/bin/lesspipe    ] && eval "$(SHELL=/bin/sh lesspipe)"

### Bash completion
[ -f /etc/bash_completion ] && . /etc/bash_completion

### Disable CTRL-S and CTRL-Q
[[ $- =~ i ]] && stty -ixoff -ixon


## alias
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

case ${OSTYPE} in
	linux*) alias ls="ls --color=auto" ;;
	darwin*) alias ls='ls -G' ;;
esac
alias ll="ls -alh"
alias ll="ls -alh"

alias grep='grep --color=auto'

