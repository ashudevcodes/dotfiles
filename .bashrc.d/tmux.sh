if [ -z "$(pgrep tmux)" ] && [ "$XDG_SESSION_TYPE" = "tty" ]; then
  /bin/tmux
fi

