if status is-interactive
    # Commands to run in interactive sessions can go here
    source ~/.config/fish/aliases_and_abbreviations.fish
    source ~/.config/fish/env_variables.fish
    source ~/.config/fish/path.fish
    source ~/.config/fish/keybindings.fish
    source ~/.config/fish_secrets.fish

    fish_vi_key_bindings
    zoxide init fish | source
end
