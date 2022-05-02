#!/bin/bash
#
# dot files linker
#

#set -xue

#repos=https://github.com/at-k/dotfiles

# env check
#if ! type git > /dev/null 2>&1; then
#	echo "error: git commad not found"
#	exit 1
#fi

#git clone ${repos}
#cd dotfiles

function mkdir_and_ln_recursively()
{
	local dir_stack=$1
	for f in "$dir_stack"/* "$dir_stack"/.??*; do
		if [[ -e "$f" ]]; then
			if [[ -d "$f" ]]; then
				mkdir_and_ln_recursively "$f"
			else
				mkdir -p ~/"$dir_stack"
				ln -snf "$(pwd)"/"${f}" ~/"${f}"
			fi
		fi
	done
}

for f in .??*
do
	[[ "$f" == ".git" ]] && continue
	[[ "$f" == ".DS_Store" ]] && continue

	if [[ -d "$f" ]]; then
		mkdir_and_ln_recursively "$f"
	else
		ln -snf "$(pwd)"/"$f" ~/"$f"
	fi
done

#read
