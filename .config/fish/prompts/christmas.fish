# @fish-lsp-disable-next-line 4004
function fish_prompt
    set -l last_status $status

    set -l cyan (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -l red (set_color -o D50000)
    set -l blue (set_color -o blue)
    set -l green (set_color -o green)
    set -l normal (set_color normal)
    set -l white (set_color white)
    set -l silver (set_color B5B5B5)
    set -l gold (set_color C1A520)

    set -l magenta (set_color --bold magenta)

    set -l cwd (pwd | sed "s|^$HOME|🎅|")
    #set -l vi_mode (fish_default_mode_prompt)
    switch $fish_bind_mode
        case default
            set -g vi_mode (echo $red"[N]")
        case insert
            set -g vi_mode (echo '[I]')
        case replace_one
            set -g vi_mode (echo '[R]')
        case replace
            set -g vi_mode (echo $silver'[R]')
        case visual
            set -g vi_mode (echo $magenta'[V]')
    end

    if test $last_status = 0
        set -l status_indicator "$cyan➜"
    else
        set -l status_indicator "$red➜"
    end
    echo -n -s "$cyan┌──($green"marry🎄christmas"$cyan)-[$red$cwd$cyan]-$vi_mode" \n "$cyan└─$gold" \$
end
