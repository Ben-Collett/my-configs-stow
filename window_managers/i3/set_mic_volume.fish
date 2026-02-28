#!/usr/bin/fish
amixer set Capture $argv

source ~/.config/i3/get_mic_volume.fish > ~/.config/i3/current_mic_volume.txt

