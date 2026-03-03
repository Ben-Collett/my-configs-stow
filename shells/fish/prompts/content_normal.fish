# @fish-lsp-disable-next-line 4004
function fish_prompt
    set -l last_status $status

    # Colors
    set -l amber (set_color -o yellow)
    set -l orange (set_color F98128)
    set -l cyan (set_color -o cyan)
    set -l green (set_color -o green)
    set -l rust (set_color -o red)
    set -l dim (set_color brblack)
    set -l purple (set_color -o magenta)
    set -l normal (set_color normal)

    set -l cwd (pwd | sed "s|^$HOME|~|")
    set -l ship CodeCowboy

    # Default color logic
    set color $rust
    if test $last_status -eq 0
        set color $cyan
    end

    if test $__session_has_run -eq 0
        set color $dim
        set -g __first_prompt 0
    end

    if test "$fish_bind_mode" = visual
        set color $purple
    end
    if test "$fish_bind_mode" = replace
        set color $orange
    end
    # if test "$fish_bind_mode" = default
    #     set color $green
    # end
    set core $color●

    # --- TOP LINE ---
    echo -s \
        "$color╭─[" \
        "$amber$ship" \
        "$color]─(" \
        "$amber$cwd" \
        "$color)─" \
        "$core"

    # --- BOTTOM LINE ---
    echo -n -s \
        "$color╰─➤" \
        "$amber"
end
