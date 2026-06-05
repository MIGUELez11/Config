if status is-interactive
# Commands to run in interactive sessions can go here
end

# === MIGUELez11 config ===
# Load MIGUELez11 config functions
source $__fish_config_dir/conf.d/miguelez11_theme.fish
source $__fish_config_dir/conf.d/abbreviations.fish
for file in $__fish_config_dir/functions/miguelez11/**/*.fish
    source $file
end

for file in $__fish_config_dir/completions/miguelez11/**/*.fish
    source $file
end

# Default editor
set -gx EDITOR vim
set -gx VISUAL vim

# Node version manager default (jorgebucaran/nvm.fish, optional)
# Inert unless nvm.fish is installed; the installer can add it on request.
set -gx nvm_default_version lts

# Enable vi mode: Esc enters normal mode
fish_vi_key_bindings

# Use your editor for the current command buffer
bind --mode insert ctrl-e edit_command_buffer
bind --mode default ctrl-e edit_command_buffer

starship init fish | source
zoxide init fish | source
# === End MIGUELez11 config ===
