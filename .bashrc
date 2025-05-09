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

# Changing "ls" to "eza" (Add By ashish)

alias ls='eza --sort=size --icons --color=always --group-directories-first'
alias ll='eza -lh --sort=size -a --icons --color=always --group-directories-first'
alias la='eza --sort=size -a --icons --color=always --group-directories-first'
alias l='eza  --sort=size -F --icons --color=always --group-directories-first'
alias l.='eza --sort=size -a | egrep "^\."'

# alias for Configs

alias nconf='nvim ~/.config/nvim'
alias hyprconf='nvim ~/.config/hypr'

# Make Vim defaut Editor (Add By ashish)
export EDITOR=nvim
set -o vi

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none \
  --color=bg+:#283457 \
  --color=bg:#16161e \
  --color=border:#27a1b9 \
  --color=fg:#c0caf5 \
  --color=gutter:#16161e \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#27a1b9 \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"
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

# shortcut to open tumux through alt + t key
bind -x '"\et":tmux_auto_attach'

# this function was call when key trigger alt+t
tmux_auto_attach() {
    if [[ -z "$TMUX" ]]; then
        if tmux ls &>/dev/null; then
            tmux attach || tmux new-session
        else
            tmux new-session
        fi
    fi
}

# export Flutter PATH

export PATH="$HOME/.local/bin/flutter_linux_3.29.3-stable/flutter/bin:$PATH"
