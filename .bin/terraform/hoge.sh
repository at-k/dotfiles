#!/bin/zsh
#
#
hoge="a b c"

for f in $(echo $hoge); do
  echo $f hoge
done
