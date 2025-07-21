# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
export PATH="$PATH:/home/ashish/.config/src/lua-language-server/bin"
export PATH="$PATH:/home/ashish/.config/src/stylua-linux-x86_64/bin"
export PATH="$PATH:/home/ashish/go/bin"
alias lsend="~/Downloads/localsend/AppRun"
alias docker=podman
alias docker-compose=podman-compose
