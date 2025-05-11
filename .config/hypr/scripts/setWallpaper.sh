#!/bin/bash

WALLPAPER_PATH="/home/ashish/Pictures/wallpaper.jpg"
hyprctl dispatch preload "$WALLPAPER_PATH"

hyprctl dispatch wallpaper "$WALLPAPER_PATH

# Unload the wallpaper (optional, depending on your use case)
hyprctl dispatch unload "$WALLPAPER_PATH"
