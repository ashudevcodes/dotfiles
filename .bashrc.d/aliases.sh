# Docker/Podman aliases
alias docker=podman
alias docker-compose=podman-compose

# Utility aliases
alias ddg="lynx -vikeys https://lite.duckduckgo.com/lite"
alias ly="lynx -vikeys"
alias pdftotext="pdftotext -layout"
alias v="vim"
alias wifi="rfkill toggle wifi"
alias bt="rfkill toggle bluetooth"
alias night="redshift -O 3500k"
alias day="redshift -x"
alias q='exit'
alias lq='leetcodeSession'
alias t='tmux'

# Android Studio
alias androidStudio="$HOME/.share/android-studio/bin/studio"

# Git
alias lg='lazygit'

# Eza (ls replacement)
alias ls='eza --sort=size --icons --color=always --group-directories-first'
alias ll='eza -lh --sort=size --total-size -a --icons --color=always --group-directories-first'
alias la='eza --sort=size -a --icons --color=always --group-directories-first'
alias l='eza  --sort=size -F --icons --color=always --group-directories-first'
alias l.='eza --sort=size -a | egrep "^\."'

# Config aliases
alias nconf='nvim ~/.config/nvim'

# Neovim
alias n='nvim'
