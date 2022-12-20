#!/usr/bin/env zsh
# aliases and functions for kubectl
#

alias k='kubectl'
alias kc='kubectx'
alias kn='kubens'

function kpod () {
  if [ $# -ge 1 -a "$1" = "-A" ]; then
    kubectl get po $@ | peco | awk '{print $2}' | tr -d '\n' | pbcopy
  else
    kubectl get po $@ | peco | awk '{print $1}' | tr -d '\n' | pbcopy
  fi
}

function knode () {
  kubectl get no $@ | peco | awk '{print $1}' | tr -d '\n' | pbcopy
}
