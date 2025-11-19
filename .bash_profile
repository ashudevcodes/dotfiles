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
alias bt="rfkill toggle bluetooth"
alias androidStudio=~/.share/android-studio/bin/studio
alias adb=~/Android/Sdk/platform-tools/adb

# Set JAVA_HOME
export JAVA_HOME=/home/nemo/.share/android-studio/jbr
export PATH=$JAVA_HOME/bin:$PATH

