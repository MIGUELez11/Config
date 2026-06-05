function open_editor
    $EDITOR $argv[1]
end

function config
    set -l CONFIG_DIR $__fish_config_dir
    cd $CONFIG_DIR
    echo "Switching to config directory: $CONFIG_DIR"

    switch $argv[1]
        case -e --edit
            open_editor $__fish_config_dir/config.fish
        case *
            echo "Use with -e or --edit to edit the config file"
    end
end

function reload_config
    echo "Sourcing fish config files again..."
    source $__fish_config_dir/config.fish
    return 0
end