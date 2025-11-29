function change_prompt
    if test (count $argv) -ne 1
        echo "Usage: change_prompt <name>"
        return 1
    end

    set promptname $argv[1]
    set prompts_dir "$HOME/.config/fish/prompts"
    set functions_dir "$HOME/.config/fish/functions"
    set target "$prompts_dir/$promptname.fish"
    set link "$functions_dir/fish_prompt.fish"

    # Check if prompt exists
    if not test -f $target
        echo "Prompt '$promptname' not found in $prompts_dir"
        return 1
    end

    # Remove old symlink or file
    if test -e $link
        rm $link
    end

    # Create the new symlink
    ln -s $target $link

    echo "Prompt changed to: $promptname"
    echo "Run 'source ~/.config/fish/config.fish' or start a new shell to see it."
end
