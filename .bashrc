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

# Changing "ls" to "exa" (Add By ashish)
alias ls='exa --icons --color=always --group-directories-first'
alias ll='exa -alF --icons --color=always --group-directories-first'
alias la='exa -a --icons --color=always --group-directories-first'
alias l='exa -F --icons --color=always --group-directories-first'
alias l.='exa -a | egrep "^\."'

# Make Vim defaut Editor (Add By ashish)
export EDITOR=vim

# For Installing Starship default (Add by ashish)
eval "$(starship init bash)"
eval "$(starship completions bash)"

# Add for asthetic (ashish)
cowsay -f tux "Hello Nemo :)"

# Add for no duplicate entries in history (ashish)
export HISTCONTROL=ignoredups:erasedups 

unset rc

alias luamake="/home/ashish/Downloads/lua-language-server/3rd/luamake/luamake"
