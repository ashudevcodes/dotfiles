# Configs Setup Instruction

## Introduction

This document will help you properly set up and back up your Neovim, Tmux or all the configuration. If you have a pre-existing setup, it's crucial to back it up before proceeding with the new configuration. This guide will walk you through the steps to ensure your old setup is preserved and can be easily restored if needed. i will show the example of neovim configs

## Backup Your Existing Neovim Setup

1. **Locate Your Neovim Configuration Directory**:
    The Neovim configuration directory is typically located at `~/.config/nvim`.

2. **Backup Your Existing Configuration**:
    To back up your existing Neovim configuration, open your terminal and run the following command:
    ```sh
    mv -rf ~/.config/nvim ~/.config/nvim.bak
    ```
    This command renames the `nvim` directory to `nvim.bak`, effectively backing up your old configuration.

3. **Set Up the New Configuration**:
    Now you can set up your new Neovim configuration. Follow the specific instructions provided with the new setup.

## Restore Your Old Configuration

If you need to revert to your old Neovim setup, follow these steps:

1. **Remove the Current Configuration**:
    Open your terminal and run the following command to remove the current Neovim setup:
    ```sh
    rm -rf ~/.config/nvim
    ```

2. **Restore Your Backup**:
    To restore your old configuration, rename the backup directory back to `nvim`:
    ```sh
    mv -rf ~/.config/nvim.bak ~/.config/nvim
    ```

## Important Notes

- **Apply These Steps to All Configuration Changes**:
    Whenever you plan to modify your Neovim configuration or switch to a new setup, it's a good practice to back up your existing setup using the steps mentioned above.

- **Verify Backups**:
    Ensure that your backup directory (`nvim.bak`) contains all necessary files before deleting or overwriting any configuration files.

- **Consistency**:
    Keep the naming convention consistent for easy restoration. Always use `nvim.bak` for the backup directory unless you have multiple backups, in which case you can use names like `nvim.bak1`, `nvim.bak2`, etc.

By following these guidelines, you can seamlessly switch between different Neovim setups while preserving your previous configurations. Happy coding!
