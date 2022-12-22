#!/usr/bin/env zsh

alias reload-anyenv='eval "$(anyenv init -)"'

export PATH="$HOME/go/bin:$PATH"

if [ -d ~/.anyenv ]; then
    export PATH="$HOME/.anyenv/bin:$PATH"

    cache=${HOME}/.cache/anyenv/anyenv.sh
    CACHE_EXPIRED_SEC=600

    # cache anyenv init file
    if [[ -f ${cache} ]]; then
        eval $(stat -s ${cache} )
        mtime=${st_mtime}
        ctime=$(date +%s)
        laps=$(echo "$ctime - $mtime" | bc)

        if [[ $laps -gt $CACHE_EXPIRED_SEC ]]; then
            mkdir -p $(dirname ${cache})
            anyenv init - --no-rehash > ${cache}
	    fi
    else
        mkdir -p $(dirname ${cache})
        anyenv init - --no-rehash > ${cache}
    fi
    source ${cache}
    # eval "$(anyenv init - --no-rehash)"
else
	# for python
	if [ -d ~/.pyenv ]; then
		export PYENV_ROOT="$HOME/.pyenv"
		export PATH="$PYENV_ROOT/bin:$PATH" && eval "$(pyenv init - --no-rehash)"

		if [ -d $PYENV_ROOT/versions/anaconda3-4.2.0/bin/ ]; then
			export PATH="$PYENV_ROOT/versions/anaconda3-4.2.0/bin/:$PATH"
		fi
	fi

	# for ruby
	if [ -d ~/.rbenv ]; then
		eval "$(rbenv init - --no-rehash)"
	fi

	# for node.js
	if [ -d ~/.ndenv ]; then
		export PATH="$HOME/.ndenv/bin:$PATH" && eval "$(ndenv init -)"
	fi

	# for golang
	if [ -d ~/.go ]; then
		export GOPATH=$HOME/.go
		export PATH=$PATH:$GOPATH/bin
	fi
fi
