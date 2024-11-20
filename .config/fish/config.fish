if status is-interactive
    # Commands to run in interactive sessions can go here

    set APP_IMAGE_PATH ~/Desktop/app_images
    set SOURCE_CODES ~/Desktop/source_codes_for_building
    set -gx EDITOR nvim
    set -gx IPYTHONDIR ~/.config/ipython
    set -x JAVA_HOME /usr/lib/jvm/java-17-openjdk/
    set -x PATH $JAVA_HOME/bin $PATH
    set -x MANPAGER "nvim +Man!"

    abbr ls 'eza --icons'
    abbr sl 'eza --icons'
    abbr sls 'eza --icons'
    abbr la 'eza -a --icons'
    abbr ll 'eza -l --icons '
    abbr lla 'eza -al --icons '
    abbr l eza
    abbr sh0 'shutdown now'
    abbr shr 'shutdown -r now'
    abbr lg 'eza|rg'
    abbr lga 'eza -a|rg'
    abbr lt 'eza | tail -n'
    abbr lta 'eza -a| tail -n'
    abbr lh 'eza | head -n'
    abbr lha 'eza -a| head -n'
    abbr lpwd 'eza --icons --absolute'
    abbr cl clear
    abbr lc clear
    
    abbr mkp 'mkdir -p'
    abbr intellij idea
    abbr cat lolcat

    
    alias p='~/programs/pycharm-community-2024.1.1/bin/pycharm.sh'
    alias semail="firefox https://mail.google.com/mail/u/0/#inbox"
    alias vscode='flatpak run com.visualstudio.code'
    alias lflutter='mpv ~/Downloads/Flutter\ Course\ for\ Beginners\ –\ 37-hour\ Cross\ Platform\ App\ Development\ Tutorial\ \[VPvVD8t02U8\].mp4'
    alias sthing $SOURCE_CODES/syncthing/bin/syncthing
    alias ladybird /home/ben/programs/ladybird/Build/ladybird/bin/Ladybird
    set flutter_path /home/ben/programs/flutter/bin
    set -x PATH $flutter_path/ $PATH
    alias dart /home/ben/programs/flutter/bin/dart

    bind \er launch_ranger

    fish_vi_key_bindings
    zoxide init fish | source

end

#need to find a way to change cursor after using alt-r ot launch
function launch_ranger
    ranger .
end

