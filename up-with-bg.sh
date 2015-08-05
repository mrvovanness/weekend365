#!/bin/sh
tmux new-session -d -n server 'rails s'
tmux split-window -v 'guard'
tmux split-window -v '~/redis-3.0.3/src/redis-server'
tmux split-window -v 'rake resque:work QUEUE=send_emails'
tmux split-window -v 'rake resque:scheduler DYNAMIC_SCHEDULE=true'
tmux new-window -d -n editor 'stty -ixon; vim'
tmux selectw -t 2
tmux attach-session -d

