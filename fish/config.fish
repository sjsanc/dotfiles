# Set editors with fallbacks
if command -v helix >/dev/null
    set -x EDITOR helix
else if command -v vim >/dev/null
    set -x EDITOR vim
else
    set -x EDITOR nano
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Wayland DPI fix
set -x ELECTRON_OZONE_PLATFORM_HINT auto

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Start ssh-agent if not already running
if test -z "$SSH_AGENT_PID"
    eval (ssh-agent -c) >/dev/null
end

function fish_greeting
    curl -s curl https://api.wc3.blizzardquotes.com/v1/quotes/random | jq '.value'
end

fish_add_path $HOME/.local/bin
fish_add_path $HOME/.dotnet/tools
fish_add_path (go env GOPATH)/bin
