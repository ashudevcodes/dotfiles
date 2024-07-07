# Starship prompt initialization
eval "$(starship init zsh)"

# Aliases
alias ls="exa --icons"

export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


# bun completions
[ -s "/home/ashish/.bun/_bun" ] && source "/home/ashish/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="${PATH}:/mnt/c/Program\ Files\ \(x86\)/Mozilla\ Firefox"

source <(fzf --zsh)
