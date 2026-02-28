function clip
    if test $XDG_SESSION_TYPE = wayland
        wl-copy $argv
    else if test $XDG_SESSION_TYPE = x11
        xsel $argv
    end
end
