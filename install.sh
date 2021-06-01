#!/bin/bash
if echo $PATH | grep "$HOME/.local/bin" > /dev/null; then
	if [ -z "$XDG_CONFIG_HOME" ]; then
		XDG_CONFIG_HOME="$HOME/.config"
	fi

	cp boom $HOME/.local/bin
	chmod +x $HOME/.local/bin/boom
	nimble install
	if ls "$XDG_CONFIG_HOME/boom" &>/dev/null; then
		exit
	else
		cp config $XDG_CONFIG_HOME/boom
	fi
else
	echo "$HOME/.local/bin is not in your path! Cannot install."
	exit 1
fi
