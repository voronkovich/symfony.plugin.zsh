alias sf='`_symfony_find_console`';

symfony-get-installer() {
    save_to="${1:-.}/symfony";

    if [[ -f "$save_to" ]]; then
        echo "Symfony installer script already exists: $save_to" >&2;
        return 1;
    fi

    curl -LsS https://symfony.com/installer -o "$save_to" && chmod a+x "$save_to";
}

_symfony_find_console() {
    dir="$PWD";

    # Upward search
    while ((1)); do

        if [[ -f "$dir/bin/console" ]]; then
            # Symfony 3
            echo "$dir/bin/console";
            break;
        elif [[ -f "$dir/app/console" ]]; then
            # Symfony 2
            echo "$dir/app/console";
            break;
        fi

        [[ "$dir" == '' ]] && break;

        dir="${dir%/*}";
    done
}

_symfony_get_command_list() {
    $1 --no-ansi list | \
        sed -nr \
        -e '1,/Available commands/d' \
        -e 's/^  ?([^[:space:]]+) +(.*)$/\1:"\2"/p' \
    ;
}

_symfony_installer() {
    commands_list=$(_symfony_get_command_list symfony);

    _arguments -s -w \
        '(-V|--version)'{-V,--version}'[Display this application version]' \
        '(-h|--help)'{-h,--help}'[Display a help message]' \
        '(-n|---no-interaction)'{-n,--no-interaction}'[Do not ask any interactive question]' \
        '(-q|--quiet)'{-q,--quiet}'[ Do not output any message]' \
        '(-v|--verbose)'{-v,--verbose}'[Increase the verbosity of messages]' \
        '-vv[More verbose output]' \
        '-vvv[The verbosest output: debug]' \
        '--ansi[Force ANSI output]' \
        '--no-ansi[Disable ANSI output]' \
        "1:command:(($commands_list))" \
        '*:file:_files -/' \
        && return 0;
}

_symfony_console() {
    commands_list=$(_symfony_get_command_list "$(_symfony_find_console)" | sed -rne 's/:([^"])/\\\\\\:\1/gp');

    _arguments -s -w \
        '(-V|--version)'{-V,--version}'[Display this application version]' \
        '(-e|--env)'{-e,--env}'=[The Environment name (default: "dev")]:::("dev" "prod" "test")' \
        '(-h|--help)'{-h,--help}'[Display a help message]' \
        '(-n|---no-interaction)'{-n,--no-interaction}'[Do not ask any interactive question]' \
        '(-q|--quiet)'{-q,--quiet}'[ Do not output any message]' \
        '(-s|--shell)'{-s,--shell}'[Launch the shell]' \
        '(-v|--verbose)'{-v,--verbose}'[Increase the verbosity of messages]' \
        '-vv[More verbose output]' \
        '-vvv[The verbosest output: debug]' \
        '--ansi[Force ANSI output]' \
        '--no-ansi[Disable ANSI output]' \
        '--no-debug[Switches off debug mode]' \
        '--process-isolation[Launch commands from shell as a separate process]' \
        "1:command:(($commands_list))" \
        '*:file:_files -/' \
        && return 0;
}

compdef _symfony_installer symfony;

compdef _symfony_console '`_symfony_find_console`';
compdef _symfony_console 'app/console';
compdef _symfony_console 'bin/console';
compdef _symfony_console 'sf';
