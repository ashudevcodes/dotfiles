#!/bin/bash

echo "Which setup did you want ?"
echo "
1. Hyprland
2. Niri
3. AwesomwWM
"

echo "Input a number.."


backupConfig(){
  echo "Backup existing Configration :)"
  local folder_count=0
  mkdir -p "$HOME/.config/backups-configs"

  for folder in "$@"; do
	printf "\rBacking up: %-30s" "$folder"
	sleep 0.1
	if [ -e "$HOME/.config/$folder" ]; then
	  mv "$HOME/.config/$folder" "$HOME/.config/backups-configs/$folder.bak"
	  ((folder_count++))
	fi
  done

  printf "\r%-40s\n" " "
  echo "
  $folder_count Folders Backed up! from $HOME/.config
  Into $HOME/.config/backups-configs :)
  "

}

is_codespace() {
  [ "$CODESPACES" = "true" ] || [ -n "$CODESPACE_NAME" ]
}

backupBashrc(){
  mkdir -p "$HOME/.bashrc.d"

  echo "Backup: bashrc Configration.."

  mv "$HOME/.bashrc" "$HOME/.bashrc.bak"
  mv "$HOME/.bash_profile" "$HOME/.bash_profile.bak"
  cp "$current_dir_path/.bashrc" "$HOME"
  cp "$current_dir_path/.bash_profile" "$HOME"

  echo "bashrc Configration load :)"
}

main(){
  if is_codespace; then
	sudo apt update
	sudo apt install -y eza tmux fzf cowsay foot-terminfo kitty-terminfo python3-neovim stow

	curl -sS https://starship.rs/install.sh | sh -s -- --yes
	# for Cowsay
	echo 'export PATH=$PATH:/usr/games' >> ~/.bashrc

  fi

  if [ $(cat /etc/hostname) == "archlinux" ]; then
	sudo pacman -S eza neovim tmux fzf cowsay starship stow
  fi

  current_dir_path="$(pwd)"

  if [ -e "dotfiles" ]; then
	pushd "$current_dir_path/dotfiles"
  fi

  mapfile -t ashudevcodes_config_folders < <(git -C . ls-tree -d --name-only HEAD:home/.config)
  mapfile -t ashudevcodes_local_bin < <(git -C . ls-tree --name-only HEAD:home/.local/bin/)
  mapfile -t ashudevcodes_bash_script < <(git -C . ls-tree --name-only HEAD:home/.bashrc.d)


  backupConfig "${ashudevcodes_config_folders[@]}"
  backupBashrc


  stow -v home


  echo "Restart or Logout to apply"

  if is_codespace; then
	# Because Vim 9.1 not support vim `XDG_CONFIG_HOME` configration (github codespace use ubuntu v24.04 LTS) which not support latest vim package yet
	cp -r ~/.config/vim ~/.vim
  fi

}

main
