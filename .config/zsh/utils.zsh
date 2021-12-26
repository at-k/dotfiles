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


