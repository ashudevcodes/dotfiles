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
