if status is-interactive
    # Commands to run in interactive sessions can go here
    source ~/.config/fish/easy_env.fish
    source ~/.config/fish/keybindings.fish
    source ~/.config/fish_secrets.fish

    zoxide init fish | source
end

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /home/ben/.ghcup/bin $PATH # ghcup-env
# opencode
fish_add_path /home/ben/.opencode/bin
