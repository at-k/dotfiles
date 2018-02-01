#!/bin/sh
#
# An example hook script to verify what is about to be committed.
# Called by "git commit" with no arguments.  The hook should
# exit with non-zero status after issuing an appropriate message if
# it wants to stop the commit.
#
# To enable this hook, rename this file to "pre-commit".

if git rev-parse --verify HEAD >/dev/null 2>&1
then
	against=HEAD
else
	# Initial commit: diff against an empty tree object
	against=xxxx
fi

for file in `git diff-index $against | awk '{print $6}'`; do
  git diff --cached $file 2>&1 | egrep '^-\$ANSIBLE_VAULT;' > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "CAUTION!!!: you probably forget file encryption using ansible-vault: $file"
    exit 1
  fi
done
