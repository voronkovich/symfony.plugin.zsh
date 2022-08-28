alias sfprod='sf --env=prod';
alias sfdev='sf --env=dev';
alias sfnew='symfony new';

sf() {
    if [[ ! -f bin/console ]]; then
        echo 'Symfony console not found: bin/console' >&2;

        return 1;
    fi

    if command -v symfony >/dev/null; then
        symfony console "$@";

        return;
    fi

    bin/console "$@";
}

sfservice() {
    sf debug:container "$@";
}

sfroute() {
    sf debug:router "$@";
}

sfconfig() {
    sf debug:config "$@";
}

sfhelp() {
    sf help "$@";
}

_symfony_get_commands() {
    [[ -z $1 ]] && return 1;

    $1 --no-ansi list | \
        sed -nr \
        -e '1,/Available commands/d' \
        -e 's/([[]|[]])/\\\1/g' \
        -e 's/:/\\\:/g' \
        -e 's/^  ?([^[:space:]]+) +(.*)$/"\1[\2]"/p' \
    ;
}

_symfony_get_options() {
    ([[ -z $1 ]] || [[ -z $2 ]]) && return 1;

    $1 --no-ansi $2 --help | \
        sed -nr \
        -e '1,/^Options/d' \
        -e '/^Help/,$d' \
        -e 's/([[]|[]])/\\\1/g' \
        -e 's/:/\\\:/g' \
        -e 's/^.*(--[^=\[[:space:]]+=?)[^[:space:]]*[[:space:]]*(.*)$/"\1[\2]"/p' \
    ;
}

_symfony_get_items() {
    $1 --no-ansi $2 | sed -nr 's/^  ?([a-z_][^[:space:]]+) .*$/\1/p';
}

_symfony_get_services() {
    if [[ $? -eq 0 ]]; then
        _symfony_get_items sf debug:container;
        return 0;
    else
        return 1;
    fi
}

_symfony_get_routes() {
    if [[ $? -eq 0 ]]; then
        _symfony_get_items sf debug:router;
        return 0;
    else
        return 1;
    fi
}

_symfony_get_config_keys() {
    if [[ $? -eq 0 ]]; then
        sf debug:config |  sed -nr 's/^.*\| ([a-z_][^[:space:]]+) .*$/\1/p';
        return 0;
    else
        return 1;
    fi
}

_symfony_console() {

    local curcontext="$curcontext" state line _packages _opts ret=1

    _arguments -s -w '1: :->cmds' '*:: :->args' && ret=0;

    case $state in
        cmds)
            cmds_list=($(_symfony_get_commands sf));
            eval _values $cmds_list && ret=0;
            ;;
        args)
            opts_list=($(_symfony_get_options sf $line[1]));
            eval _arguments $opts_list && ret=0;
            ;;
    esac;

    return ret;
}

_symfony_console_debug_config() {
    compadd `_symfony_get_config_keys`;
}

_symfony_console_debug_container() {
    compadd `_symfony_get_services`;
}

_symfony_console_debug_router() {
    compadd `_symfony_get_routes`;
}

compdef _symfony_console 'sf';
compdef _symfony_console 'bin/console';
compdef _symfony_console 'sfhelp';
compdef _symfony_console_debug_config 'sfconfig';
compdef _symfony_console_debug_container 'sfservice';
compdef _symfony_console_debug_router 'sfroute';
