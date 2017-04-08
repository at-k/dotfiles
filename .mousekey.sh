#!/bin/sh
xmodmap -e 'keycode 102 = Pointer_Button1'
xmodmap -e 'keycode 100 = Pointer_Button3'
xmodmap -e 'keycode 101 = Pointer_Button2'
#xmodmap -e 'keycode 70 = F2'
xset -r 102
xset -r 101
xset -r 100
# turn mousekeys on and expiry (timeout) off
xkbset m
# xkbset exp =m
