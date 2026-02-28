#!/bin/fish
brightnessctl set $argv

source ~/.config/i3/brightness.fish > ~/.config/i3/current_brightness.txt
