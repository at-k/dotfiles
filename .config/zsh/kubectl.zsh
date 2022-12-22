#!/usr/bin/env zsh
# aliases and functions for kubectl
#

alias k='kubectl'
alias kc='kubectx'
alias kn='kubens'

alias kuconfig='aws eks update-kubeconfig --name $(basename $(pwd))'

alias kapi='kubectl api-resources'
alias kci='kubectl cluster-info'
alias kgev='kubectl get events --sort-by=.metadata.creationTimestamp'

alias kdn='kubectl describe no'
alias kdp='kubectl describe po'
alias kdnf="kubectl get no | fzf | awk '{print \$1}' | xargs -I{} kubectl describe no {}"
alias kdpf='kubectl describe po $(kubectl get pods -o name | fzf)'

alias kgn='kubectl get no'
alias kgp='kubectl get po'
alias kgnl="(){kubectl get no --show-labels | awk '{print \$1,\$6}' | fzf | cut -d' ' -f2- | tr , '\n'}"
alias kgpl="(){kubectl get po --show-labels | awk '{print \$1,\$6}' | fzf | cut -d' ' -f2- | tr , '\n'}"
alias kgn-s='(){kubectl get no --selector=$1}'
alias kgp-s='(){kubectl get po --selector=$1}'
alias kgn-l='(){kubectl get no -L=$1}'
alias kgp-l='(){kubectl get po -L=$1}'


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
