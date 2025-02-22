#!/usr/bin/fish
echo 🎤(amixer get Capture | rg % | head -n 1 | string match -r '\d+%')
