#!/usr/bin/env zsh
# aliases and functions for terraform
#

export TF_CLI_ARGS_plan="--parallelism=8"

alias tplan="terraform plan | landscape"
alias tf='terraform'

alias tfp='terraform plan'
alias tfi='terraform init'

alias tg='terragrunt'
