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

  local -n ashudevcodes_config_dir_names="$1"
  local git_file_dir_path="$2"

  for folder in "${ashudevcodes_config_dir_names[@]}"; do
	printf "\rCopying: %-30s" "$folder"
	sleep 0.1
	cp "$git_file_dir_path/$folder" "$HOME/$git_file_dir_path/$folder"
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
  if [ -e "$HOME/.bashrc.d" ]; then
	mkdir -p "$HOME/.bashrc.d"
  fi

  loadFiles ashudevcodes_bash_script "$current_dir_path/.bashrc.d"
  echo "Backup: bashrc Configration.."

  mv "$HOME/.bashrc" "$HOME/.bashrc.bak"
  mv "$HOME/.bash_profile" "$HOME/.bash_profile.bak"
  cp "$current_dir_path/.bashrc" "$HOME/"
  cp "$current_dir_path/.bash_profile" "$HOME/"

  echo "bashrc Configration load :)"
}

main(){
  if is_codespace; then
	branch="hypr"
	sudo apt update
	sudo apt install eza nvim tmux
  else
	read -p "Option (1, 2, or 3): " choice
	case $choice in
	  1)
		branch="hypr"
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
  fi

  #git clone -b $branch https://github.com/ashudevcodes/dotfile

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
  loadFiles ashudevcodes_config_folders "$current_dir_path/.config"
  loadFiles ashudevcodes_local_bin "$current_dir_path/.local/bin"
  backupBashrc

  sudo pacman -S eza nvim tmux
  echo "Restart or Logout to apply"

}

main
