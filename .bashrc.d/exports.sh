# Java
export JAVA_HOME="$HOME/.share/android-studio/jbr"
export PATH="$JAVA_HOME/bin:$PATH"

# Android SDK platform tools
if [ -d "$HOME/Android/Sdk/platform-tools" ]; then
    PATH="$HOME/Android/Sdk/platform-tools:$PATH"
fi

# Editor settings
export EDITOR=nvim
export MANPAGER='nvim +Man!'

# History settings
export HISTCONTROL=ignoredups:erasedups
