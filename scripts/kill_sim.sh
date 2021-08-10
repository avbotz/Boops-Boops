#!/bin/bash

# Send ctrl C to all tmux panes
for _pane in $(tmux list-panes -F '#P'); do
	tmux send-keys -t ${_pane} "^C"
done

# Forcibly kill simulation processes
killall -9 gzserver