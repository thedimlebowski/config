#!/bin/bash
SESSION=$USER
tmux -2 new-session -d -s $SESSION
tmux new-window -t $SESSION:0
tmux split-window -v
tmux resize-pane -D 20
tmux split-window -h
tmux select-pane -t 2
tmux send-keys "htop" C-m
tmux select-pane -t 1
tmux send-keys "watch -n0.5 nvidia-smi" C-m
tmux select-pane -t 0
tmux attach -t $SESSION
