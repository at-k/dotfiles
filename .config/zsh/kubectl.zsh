#!/usr/bin/env zsh
# aliases and functions for kubectl
#

alias k='kubectl'
alias kc='kubectx'
alias kn='kubectl ns'

alias kg='kubectl get'
alias kd='kubectl describe'

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

alias kgpc="(){kubectl get po | fzf | awk '{print \$1}' | xargs -I{} kubectl get pod {} -o jsonpath='{.spec.containers[*].name}'}"
alias krbac="(){kubectl get -A rolebindings -o json | jq -r '.items[] | select(.subjects[0].kind==\"Group\") | [.roleRef.name, .subjects[].name] | @csv'}"

alias kexi="kubectl exec -it"

function kinsjson() {
    local rsc_type=$(echo "po\ndeploy\nds" | fzf)
    if [ -z ${rsc_type} ]; then
        return
    fi
    local tgt=$(kubectl get ${rsc_type} | fzf | awk '{print $1}')
    if [ -z ${tgt} ]; then
        return
    fi

    tmux splitw -h && tmux send-key "kubectl get ${rsc_type} ${tgt} -o json | fx" C-m
    kubectl get ${rsc_type} ${tgt} -o json | jid
}

alias kaaws="(){cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: aws-cli
  name: aws-cli
spec:
  containers:
  - command:
    - sleep
    - infinity
    image: amazon/aws-cli
    name: aws-cli
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
EOF
}"
