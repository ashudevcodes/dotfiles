eval "$(fzf --bash)"

fzf_open() {
    local file
    file=$(find ~/Codes ~/.config/ \( -name .git -o -name node_modules ~/.config/BraveSoftware \) -prune -o -type f -print | \
           fzf --query="${1:-}" \
               --select-1 \
               --exit-0 \
               --preview='bat --color=always --style=numbers,changes --line-range :50 {} 2>/dev/null || head -100 {}')
    local dir=${file%/*}
    [ -n "$file" ] && cd "$dir" && ${EDITOR:-nvim} "$file"
}

find_dir() {
    local dir
    dir=$(find ~/Codes ~/.config/ -type d \( -name .git -o -name node_modules \) -prune -o -type d -print | \
          fzf --query="${1:-}" \
              --select-1 \
              --exit-0 \
              --preview='if command -v tree >/dev/null; then tree -C -L 2 -a {} | head -30; else ls -lA --color=always {} | head -20; fi')
    [ -n "$dir" ] && cd "$dir" && ${EDITOR:-nvim} "$dir"
}
