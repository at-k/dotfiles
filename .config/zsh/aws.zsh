#!/usr/bin/env zsh
# aliases and functions for aws-cli
#

alias a='aws'

alias aad='aws autoscaling describe-auto-scaling-groups'
alias aad-fn='(){aws autoscaling describe-auto-scaling-groups --filters="Name=tag:Name,Values=$1" | jid}'

alias aeu='(){aws eks update-kubeconfig --name $1}'

alias awsp=set_aws_profile
alias awsnp=create_aws_new_profile
alias awsep='(){ vim ~/.aws/config }'

function set_aws_profile() {
    # Select AWS PROFILE
    local selected_profile=$(aws configure list-profiles |
        grep -v "default" |
        sort |
        fzf --prompt "Select PROFILE. If press Ctrl-C, unset PROFILE. > " \
            --height 50% --layout=reverse --border --preview-window 'right:50%' \
            --preview "grep {} -F -A5 ~/.aws/config")

    # If the profile is not selected, unset the environment variable 'AWS_PROFILE', etc.
    if [ -z "$selected_profile" ]; then
        echo "Unset env 'AWS_PROFILE'!"
        unset AWS_PROFILE
        unset AWS_DEFAULT_PROFILE
        unset AWS_ACCESS_KEY_ID
        unset AWS_SECRET_ACCESS_KEY
        return
    fi

    # If a profile is selected, set the environment variable 'AWS_PROFILE'.
    echo "Set the environment variable 'AWS_PROFILE' to '${selected_profile}'!"
    export AWS_PROFILE="$selected_profile"
    export AWS_DEFAULT_PROFILE="$selected_profile"
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY

    # Check sso-session
    local AWS_SSO_SESSION_NAME="aws-sso"

    check_sso_session=$(aws sts get-caller-identity 2>&1)
    if [[ "$check_sso_session" == *"Token has expired"* ]]; then
        # If the session has expired, log in again.
        echo -e "\n----------------------------\nYour Session has expired! Please login...\n----------------------------\n"
        aws sso login --sso-session "${AWS_SSO_SESSION_NAME}"
        aws sts get-caller-identity
    else
        # Display account information upon successful login, and show an error message upon login failure.
        echo ${check_sso_session}
    fi
}

function create_aws_new_profile() {
    local AWS_SSO_SESSION_NAME="aws-sso"

    aws sso login --sso-session $AWS_SSO_SESSION_NAME

    local ACCESS_TOKEN=$(cat $(ls -1d ~/.aws/sso/cache/* | grep -v botocore) | jq -r "{accessToken} | .[]" | grep -v null | head -1)

    if [ -z "$ACCESS_TOKEN" ]; then
        echo "Failed to get ACCESS_TOKEN!"
        return
    fi

    local selected_account=$(aws sso list-accounts --access-token $ACCESS_TOKEN |
        jq -r ".accountList[] | [.accountId, .accountName] | @csv" |
        sed 's/\"//g' |
        fzf --prompt "Select AWS Account > " \
        --height 50% --layout=reverse --border --preview-window 'right:50%')

    if [ -z "$selected_account" ]; then
        echo "Failed to get account"
        return
    fi

    local selected_account_id=$(echo $selected_account | cut -d ',' -f 1)
    local selected_account_name=$(echo $selected_account | cut -d ',' -f 2)

    local selected_role_name=$(aws sso list-account-roles --access-token $ACCESS_TOKEN --account-id $selected_account_id |
        jq -r ".roleList[] | .roleName" |
        fzf --prompt "Select AWS Role > " \
        --height 50% --layout=reverse --border --preview-window 'right:50%')

    # generate prof_name
    local acc_alias=$(echo $selected_account_name | sed 's/ //g')
    local h=$(echo $selected_account_id | head -c3)
    local t=$(echo $selected_account_id | tail -c2)
    local prof_name=$(echo "${h}*${t}:${acc_alias}:$selected_role_name")

    # check prof_name
    if grep -q "$prof_name" ~/.aws/config; then
        echo "Profile '$prof_name' already exists!"
        return
    fi

    # create prof
    echo "[profile $prof_name]" >> ~/.aws/config
    echo "sso_session = $AWS_SSO_SESSION_NAME" >> ~/.aws/config
    echo "sso_account_id = $selected_account_id" >> ~/.aws/config
    echo "sso_role_name = $selected_role_name" >> ~/.aws/config

    echo "Created profile '$prof_name' at ~/.aws/config"
    grep -F -A3 '$prof_name' ~/.aws/config
}
