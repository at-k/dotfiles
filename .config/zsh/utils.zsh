#!/usr/bin/env zsh

function dstep(){
    ~/freee-work/clusterops/bin/ssh2step -u akawamura -k ~/.ssh/freee_key
}

function step() {
    cluster_name=$(aws eks list-clusters | jq -r '.clusters[]' | sort | peco --prompt="select target cluster")

    token=""
    alllist=""

    while true; do
        json=$(aws ssm describe-instance-information --max-items 50 --filters "Key=tag:alpha.eksctl.io/cluster-name,Values=$cluster_name" --starting-token "$token")
        token=$(echo $json | jq -r '.NextToken')

        list=$(echo $json | jq -r '.InstanceInformationList[] | [.InstanceId, .IPAddress, .PingStatus, .LastPingDateTime, .ComputerName] | @csv' | sed 's/"//g')
        alllist="${alllist}\n${list}"

        if [ -z "$token" -o "$token" = "null" ]; then
            break
        fi
    done

    inst=$(echo $alllist | grep ssm-agent-r2 | column -t -s, | peco)
    id=$(echo $inst | awk '{print $1}')

    ONELOGIN_USERNAME=akawamura@c-fo.com ssh $id
}

function decomp() {
	case $1 in
		*.tar.gz|*.tgz) tar xzvf $1;;
		*.tar.xz) tar Jxvf $1;;
		*.zip) unzip $1;;
		*.lzh) lha e $1;;
		*.tar.bz2|*.tbz) tar xjvf $1;;
		*.tar.Z) tar zxvf $1;;
		*.gz) gzip -d $1;;
		*.bz2) bzip2 -dc $1;;
		*.Z) uncompress $1;;
		*.tar) tar xvf $1;;
		*.arj) unarj $1;;
	esac
}
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=decomp

function comp() {
	if [ $# = 0 ]; then
		echo "no input"
	else
		local aname
		aname=$1.tgz
		tar cfvz $aname $@
	fi
}

function zload {
    if [[ "${#}" -le 0 ]]; then
        echo "Usage: $0 PATH..."
        echo 'Load specified files as an autoloading function'
        return 1
    fi

    local file function_path function_name
    for file in "$@"; do
        if [[ -z "$file" ]]; then
            continue
        fi

        function_path="${file:h}"
        function_name="${file:t}"

        if (( $+functions[$function_name] )) ; then
            # "function_name" is defined
            unfunction "$function_name"
        fi
        FPATH="$function_path" autoload -Uz +X "$function_name"

        if [[ "$function_name" == _* ]]; then
            # "function_name" is a completion script

            # fpath requires absolute path
            # convert relative path to absolute path with :a modifier
            fpath=("${function_path:a}" $fpath) compinit
        fi
    done
}

# jq key completion
function jq() {
    if [ -f $1 ]; then
        FILE=$1; shift
        # Move FILE at the end as expected by native jq
        command jq "$@" "$FILE"
    else
        command jq "$@"
    fi
}

function _jq() {
    COMPREPLY=()
    local curr prev
    curr=$2
    prev=$3
    #set -x
    case $COMP_CWORD in
        1)
            COMPREPLY=( $(compgen -f -- $curr) )
            ;;
        2)
            keys=$(command jq -c 'paths | map(.|tostring)|join(".")' $prev  | tr -d '"' | sed 's=^=\.=')

            COMPREPLY=( $(compgen -W "$keys" -- $curr ) )
            ;;
    esac
}
complete -F _jq jq


