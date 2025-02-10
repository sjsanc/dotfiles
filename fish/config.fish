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
