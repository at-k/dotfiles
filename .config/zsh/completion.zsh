#!/usr/bin/env zsh
# lazy loading
# ref: https://frederic-hemberger.de/notes/shell/speed-up-initial-zsh-startup-with-lazy-loading/

if [ $commands[kubectl] ]; then
    kubectl() {
        unfunction "$0"
        source <(kubectl completion zsh)
        compdef k=kubectl
        compdef kc=kubectx
        compdef kn=kubens
        $0 "$@"
    }
fi

if [ $commands[stern] ]; then
    stern() {
        unfunction "$0"
        source <(stern --completion=zsh)
        $0 "$@"
    }
fi

if [ $commands[helm] ]; then
    helm() {
        unfunction "$0"
        source <(helm completion zsh)
        $0 "$@"
    }
fi

if [ $commands[minikube] ]; then
    minikube() {
        unfunction "$0"
        source <(minikube completion zsh)
        $0 "$@"
    }
fi

if [ $commands[eksctl] ]; then
    eksctl() {
        unfunction "$0"
        source <(eksctl completion zsh)
        $0 "$@"
    }
fi

if [ $commands[terraform] ]; then
    terraform() {
        unfunction "$0"
        complete -o nospace -C /usr/local/Cellar/tfenv/2.0.0/versions/1.0.0/terraform terraform
        # complete -C terraform terraform
        compdef tf=terraform
        $0 "$@"
    }
fi

