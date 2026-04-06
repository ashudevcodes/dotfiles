# Java
export JAVA_HOME="$HOME/.share/android-studio/jbr"
export PATH="$JAVA_HOME/bin:$PATH"

export PATH="$HOME/code/github/goroot/bin:$PATH"
export PATH="$HOME/.local/opt/nvim-linux-x86_64/bin:$PATH"

# Android SDK platform tools
if [ -d "$HOME/Android/Sdk/platform-tools" ]; then
    PATH="$HOME/Android/Sdk/platform-tools:$PATH"
fi

# Editor settings
export EDITOR=nvim
export MANPAGER='nvim +Man!'

# History settings
export HISTCONTROL=ignoredups:erasedups
