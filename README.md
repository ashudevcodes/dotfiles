# Dotfiles Repository

This repository contains my personal dotfiles for configuring a Linux environment. The dotfiles include configurations for Zsh, Neovim, Neofetch, Tmux, and the Starship prompt. I use GNU Stow to manage the symbolic links for these configuration files.

<kbd><img src="https://github.com/ashudevcodes/dotfiles/assets/105356967/fd8e7dff-6754-461a-b9d1-543b4e48afdf"></kbd>
<hr>
<kbd><img src="https://github.com/ashudevcodes/dotfiles/assets/105356967/dc4d0558-efc3-492e-81a9-c78af0e03146"></kbd>

## Contents

- `.zshrc`: Configuration file for Zsh.
- `config/`: Directory containing application-specific configurations.
  - `nvim/`: Configuration for Neovim.
  - `neofetch/`: Configuration for Neofetch.
  - `tmux/`: Configuration for Tmux.
  - `starship.toml`: Configuration for the Starship prompt.

## Prerequisites

- **GNU Stow**: A symlink farm manager to manage the installation of dotfiles.
- **Zsh**: A powerful shell.
- **Neovim**: A modern fork of Vim.
- **Neofetch**: A command-line system information tool.
- **Tmux**: A terminal multiplexer.
- **Starship**: A minimal, blazing-fast, and customizable prompt for any shell.

## Installation

1. **Clone the repository**:

    ```bash
    git clone https://github.com/ashudevcodes/dotfiles.git
    cd dotfiles
    ```

2. **Install the required tools**:
    - Zsh: `sudo apt install zsh`
    - Neovim: `sudo apt install neovim`
    - Neofetch: `sudo apt install neofetch`
    - Tmux: `sudo apt install tmux`
    - Starship: Follow the installation guide on the [Starship website](https://starship.rs/).

3. **Use Stow to create symbolic links**:

    ```bash
    stow -t ~ zsh
    stow -t ~ config
    ```

    This will create symbolic links for the `.zshrc` file and the configuration files within the `~/.config` directory.

## Directory Structure

```plaintext
dotfiles/
├── .zshrc
└── config/
    ├── nvim/
    │   └── (Neovim configuration files)
    ├── neofetch/
    │   └── (Neofetch configuration files)
    ├── tmux/
    │   └── (Tmux configuration files)
    └── starship.toml
```

## Customizing

Feel free to modify any of the configuration files to suit your preferences. Each configuration file is well-documented to help you understand the settings and make changes as needed.

## Updating Configurations

If you make changes to the configurations and want to update the symbolic links, simply run the `stow` command again:

```bash
stow -t ~ zsh
stow -t ~ config
```

## Contributing

If you have suggestions or improvements, feel free to open an issue or submit a pull request. Contributions are welcome!

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
