#!/bin/sh
tmux new-session -d -s sites

tmux new-window -t sites:0 -n 'irc' '/bin/sh'
tmux new-window -t sites:1 -n 'w1' 'ssh dev'

tmux select-window -t sites:1
tmux -2 attach-session -t sites
