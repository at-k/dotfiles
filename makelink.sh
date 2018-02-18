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

for f in .??*
do
	[[ "$f" == ".git" ]] && continue
	[[ "$f" == ".DS_Store" ]] && continue

	ln -snf $(pwd)/"$f" ~/"$f"
done

