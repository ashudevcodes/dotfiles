# .bashrc

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# From ARCH If not running interactively, don't do anything
[[ $- != *i* ]] && return
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
[ -n "$XTERM_VERSION" ] && transset-df 0.9 --id "$WINDOWID" >/dev/null
set bell-style non
# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi

bind -x '"\ef":find_dir'

unset rc

# opencode
export PATH=/home/nemo/.opencode/bin:$PATH
