# if [ -z "$(pgrep tmux)" ] && [ "$XDG_SESSION_TYPE" = "tty" ]; then
#
if [ -z "$(pgrep tmux)" ]; then
  exec tmux
elif [ -z "$TMUX" ] && [ "$(pgrep -c xterm)" -le 1 ]; then 
  exec tmux attach
fi
