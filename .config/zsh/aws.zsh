#!/usr/bin/env zsh
# aliases and functions for aws-cli
#

alias a='aws'

alias aad='aws autoscaling describe-auto-scaling-groups'
alias aad-fn='(){aws autoscaling describe-auto-scaling-groups --filters="Name=tag:Name,Values=$1"}'

alias aeu='(){aws eks update-kubeconfig --name $1}'
