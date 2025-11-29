# @fish-lsp-disable-next-line 4004
function fish_prompt
    set -l last_status $status

    set -l cyan (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -l red (set_color -o red)
    set -l blue (set_color -o blue)
    set -l green (set_color -o green)
    set -l normal (set_color normal)
    set -l white (set_color white)

    set -l cwd (pwd | sed "s|^$HOME|~|")

    set -l vi_mode (fish_default_mode_prompt)
    if test $last_status = 0
        set -l status_indicator "$green➜"
    else
        set -l status_indicator "$red➜"
    end
    echo -n -s "$green┌──($blue" kali㉿kali "$green)-[$white$cwd$green]-$vi_mode" \n "$green└─$blue" \$
end
