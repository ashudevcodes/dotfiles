# Starship prompt initialization
eval "$(starship init zsh)"

# Aliases
alias ls="exa --icons"

# Lazy load NVM
export NVM_DIR="$HOME/.nvm"
load_nvm() {
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

nvm() {
  unset -f nvm
  load_nvm
  nvm "$@"
}

node() {
  unset -f node
  load_nvm
  node "$@"
}

npm() {
  unset -f npm
  load_nvm
  npm "$@"
}

npx() {
  unset -f npx
  load_nvm
  npx "$@"
}


eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


# bun completions
[ -s "/home/ashish/.bun/_bun" ] && source "/home/ashish/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="${PATH}:/mnt/c/Program\ Files\ \(x86\)/Mozilla\ Firefox"

source <(fzf --zsh)
