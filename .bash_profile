# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
alias docker=podman
alias docker-compose=podman-compose
alias ddg="lynx -vikeys https://lite.duckduckgo.com/lite"
alias pdftotext="pdftotext -layout"
alias v="vim"
alias wifi="rfkill toggle wifi"
