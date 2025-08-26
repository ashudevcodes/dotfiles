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

# Make Vim defaut Editor (Add By ashish)
export EDITOR=nvim
set -o vi
alias nv='nvim'
export MANPAGER='nvim +Man!'

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
  --color=spinner:#ff007c"

# Enhanced File and directory browser with tree view and syntax highlighting
fzf_open() {
    local file
    file=$(find ~/code ~/Documents ~/dotfiles \( -name .git -o -name node_modules \) -prune -o -type f -print | \
           fzf --query="${1:-}" \
               --select-1 \
               --exit-0 \
               --preview='bat --color=always --style=numbers,changes --line-range :50 {} 2>/dev/null || head -100 {}')
    local dir=${file%/*}
    [ -n "$file" ] && cd "$dir" && ${EDITOR:-nvim} "$file"
}

find_dir() {
    local dir
    dir=$(find ~/code ~/Documents ~/dotfiles/ -type d \( -name .git -o -name node_modules \) -prune -o -type d -print | \
          fzf --query="${1:-}" \
              --select-1 \
              --exit-0 \
              --preview='if command -v tree >/dev/null; then tree -C -L 2 -a {} | head -30; else ls -lA --color=always {} | head -20; fi')
    [ -n "$dir" ] && cd "$dir" && ${EDITOR:-nvim} "$dir"
}

bind -x '"\ed":find_dir'
bind -x '"\ef":fzf_open'

# For Installing Starship default (Add by ashish)
eval "$(starship init bash)"
eval "$(starship completions bash)"

# Time-based greeting with cowsay (Tux)
HOUR=$(date +%H)

if [ "$HOUR" -ge 5 ] && [ "$HOUR" -lt 12 ]; then
    MESSAGE="Good morning  shu :) Welcome"
elif [ "$HOUR" -ge 12 ] && [ "$HOUR" -lt 18 ]; then
    MESSAGE="Good afternoon  shu :) Welcome"
elif [ "$HOUR" -ge 18 ] && [ "$HOUR" -lt 21 ]; then
    MESSAGE="Good evening  shu :) Welcome"
elif [ "$HOUR" -ge 18 ] && [ "$HOUR" -lt 23 ]; then
    MESSAGE="It's late, go to bed! Good night  shu :)"
else
    MESSAGE="It's very late, go to bed! Good night  shu :)"
fi

cowsay -f tux "$MESSAGE"

# Add for no duplicate entries in history (ashish)
export HISTCONTROL=ignoredups:erasedups 

unset rc
