#!/usr/bin/env bash

updates=$(checkupdates 2>/dev/null | wc -l)

if [ "$updates" -gt 0 ]; then
  hyprctl notify 2 2000000000 "rgba(66ee66ff)" "󰚰  $updates updates available"
fi
