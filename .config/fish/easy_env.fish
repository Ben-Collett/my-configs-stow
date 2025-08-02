#environment variables
set -gx APP_IMAGE_PATH ~/Desktop/app_images
set -gx SOURCE_CODES ~/Desktop/source_codes_for_building
set -gx EDITOR nvim
set -gx JAVA_HOME ~/java/bin
set -gx MANPAGER "nvim +Man!"
set -gx flutter_path /home/ben/programs/flutter/bin

#update path
fish_add_path ~/.cargo/bin/
fish_add_path ~/.nix-profile/bin/
fish_add_path $flutter_path

#aliases
alias sthing $SOURCE_CODES/syncthing/bin/syncthing
alias dart /home/ben/programs/flutter/bin/dart

#abbreviations
abbr ls eza --icons
abbr sl eza --icons
abbr sls eza --icons
abbr la eza -a --icons
abbr al eza -a --icons
abbr ll eza -l --icons
abbr lla eza -al --icons
abbr lal eza -al --icons
abbr l eza
abbr lg 'eza|rg'
abbr lga 'eza -a|rg'
abbr lt 'eza | tail -n'
abbr lta 'eza -a| tail -n'
abbr lh 'eza | head -n'
abbr lha 'eza -a| head -n'
abbr sh0 shutdown now
abbr s0h shutdown now
abbr 0sh shutdown now
abbr h0s shutdown now
abbr shr shutdown -r now
abbr cl clear
abbr lc clear
abbr dc cd
abbr cn nmtui
abbr mkp mkdir -p
abbr cat lolcat
abbr intellij idea
abbr fokular org.kde.okular
abbr clo cloc -q --hide-rate .