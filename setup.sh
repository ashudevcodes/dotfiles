#!/bin/bash

# Detect package manager and install missing tools
if command -v apt &> /dev/null; then
    echo "Using apt package manager..."
    sudo apt update
    sudo apt install -y fzf cowsay tmux
elif command -v pacman &> /dev/null; then
    echo "Using pacman package manager..."
    sudo pacman -S --noconfirm fzf cowsay starship tmux
elif command -v dnf &> /dev/null; then
    echo "Using dnf package manager..."
    sudo dnf install -y fzf cowsay starship tmux
elif command -v brew &> /dev/null; then
    echo "Using homebrew package manager..."
    brew install fzf cowsay starship tmux
else
    echo "No supported package manager found"
    exit 1
fi

echo "Installation complete!"
