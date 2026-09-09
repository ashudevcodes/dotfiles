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

loadFiles(){

  local -n name_of_all_ashudevcodes_config_dir="$1"
  local path_of_ashudevcodes_config_dir="$2"

  for name in "${name_of_all_ashudevcodes_config_dir[@]}"; do
	printf "\rCopying: %-30s" "$name"
	sleep 0.1
	cp -r "$path_of_ashudevcodes_config_dir/$name" "$HOME/$3/$name"
  done

  printf "\r%-45s\n" " "
  echo "
  $git_file_dir_path Load! :)
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
	branch="hyprland"
	sudo apt update
	sudo apt install -y eza neovim tmux fzf cowsay starship
  else
	if [[ $1 == "--offline" ]]; then
		printf "Clone Repo like:\ngit clone -b [branch name] https://github.com/ashudevcodes/dotfiles\ncd dotfiles\n./install.sh --offline"
	  else
		read -p "Option (1, 2, or 3): " choice
		case $choice in
		  1)
			branch="hyprland"
			;;
		  2)
			branch="niri"
			;;
		  3)
			branch="awesome"
			;;
		  *)
			echo "Invalid option."
			;;
		esac

		git clone -b "$branch" https://github.com/ashudevcodes/dotfiles
	fi
  fi

  current_dir_path="$(pwd)/dotfiles"

  if [ -e "dotfiles" ]; then
	pushd "$current_dir_path"
  fi
  mapfile -t ashudevcodes_config_folders < <(git -C . ls-tree -d --name-only HEAD:.config)
  mapfile -t ashudevcodes_local_bin < <(git -C . ls-tree --name-only HEAD:.local/bin/)
  mapfile -t ashudevcodes_bash_script < <(git -C . ls-tree --name-only HEAD:.bashrc.d)
  if [ -e "dotfiles" ]; then
	popd
  fi

  backupConfig "${ashudevcodes_config_folders[@]}"

  loadFiles ashudevcodes_config_folders "$current_dir_path/.config"    ".config"
  loadFiles ashudevcodes_local_bin      "$current_dir_path/.local/bin" ".local/bin"
  loadFiles ashudevcodes_bash_script    "$current_dir_path/.bashrc.d"  ".bashrc.d"

  backupBashrc

  if [ $(cat /etc/hostname) == "archlinux" ]; then
	sudo pacman -S eza neovim tmux fzf cowsay starship
  fi

  echo "Restart or Logout to apply"

}

main
