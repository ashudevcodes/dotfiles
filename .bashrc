# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

export PATH="$PATH:/home/ashish/.config/src/jdt-language-server/bin"


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

# alias for exit (Add By ashish)
alias q='exit'


# Changing "lg" to "lazygit" (Add By ashish)
alias lg='lazygit'

# Changing "ls" to "lsd" (Add By ashish)
alias ls='lsd'

alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# alias for Configs

alias nconf='nvim ~/.config/nvim'
alias hyprconf='nvim ~/.config/hypr'

# Make Vim defaut Editor (Add By ashish)
export EDITOR=nvim

set -o vi

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

# For Installing Starship default (Add by ashish)
eval "$(starship init bash)"
eval "$(starship completions bash)"

# Add for asthetic (ashish)
cowsay -f tux "Hello Ashu :)"

# Add for no duplicate entries in history (ashish)
export HISTCONTROL=ignoredups:erasedups 

unset rc

alias luamake="/home/ashish/Downloads/lua-language-server/3rd/luamake/luamake"

# Toggle On/Off of laptop Touchpad

alias touchpad="~/.config/scripts/toggle-touchpad.sh"

# Automatically start or attach to a tmux session

if [[ -z "$TMUX" ]]; then  
    if tmux ls &>/dev/null; then
        tmux attach || tmux new-session
    else
        tmux new-session
    fi
fi

