#!/usr/bin/env bash

tempfile=$(mktemp ~/.xmonad/xmonad.hs.save.XXXX)
mv ~/.xmonad/xmonad.hs $tempfile
ln -s ~/Ocean/jjdosa/mysystem/home/services/xmonad/xmonad.hs ~/.xmonad/xmonad.hs
xmonad --recompile
xmonad --restart
mv $tempfile ~/.xmonad/xmonad.hs
