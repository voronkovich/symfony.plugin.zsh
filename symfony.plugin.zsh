alias sfsh='sf --shell';
alias sfprod='sf --env=prod';
alias sfdev='sf --env=dev';
alias sfnew='symfony new';
alias sfstart='sf server:start';
alias sfrun='sf server:start';
alias sfstop='sf server:stop';

sf() {
    console=$(_symfony_find_console);

    if [[ $? -eq 0 ]]; then
        $console $@;
    else
        echo "Symfony console not found" >&2;
    fi
}

sfservice() {
    sf debug:container $@
}

sfroute() {
    sf debug:router $@
}

sfconfig() {
    sf debug:config $@
}

sfhelp() {
    sf help $@
}

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
            return 0;
        elif [[ -f "$dir/app/console" ]]; then
            # Symfony 2
            echo "$dir/app/console";
            return 0;
        fi

        [[ "$dir" == '' ]] && break;

        dir="${dir%/*}";
    done

    return 1;
}

_symfony_get_commands() {
    [[ -z $1 ]] && return 1;

    $1 --no-ansi list | \
        sed -nr \
        -e '1,/Available commands/d' \
        -e 's/:/\\\:/g' \
        -e 's/^  ?([^[:space:]]+) +(.*)$/\1/p' \
    ;
}

_symfony_get_options() {
    ([[ -z $1 ]] || [[ -z $2 ]]) && return 1;

    $1 --no-ansi $2 --help | \
        sed -nr \
        -e '1,/^Options/d' \
        -e '/^$/,$d' \
        -e 's/^.*(--[^=\[[:space:]]+=?).*/\1:/p' \
    ;
}

_symfony_get_items() {
    $1 --no-ansi $2 | sed -nr 's/^  ?([a-z_][^[:space:]]+) .*$/\1/p';
}

_symfony_get_services() {
    console=${1-$(_symfony_find_console)};

    if [[ $? -eq 0 ]]; then
        _symfony_get_items "$console" debug:container;
        return 0;
    else
        return 1;
    fi
}

_symfony_get_routes() {
    console=${1-$(_symfony_find_console)};

    if [[ $? -eq 0 ]]; then
        _symfony_get_items "$console" debug:router;
        return 0;
    else
        return 1;
    fi
}

_symfony_get_config_keys() {
    console=${1-$(_symfony_find_console)};

    if [[ $? -eq 0 ]]; then
        "$console" debug:config |  sed -nr 's/^.*\| ([a-z_][^[:space:]]+) .*$/\1/p';
        return 0;
    else
        return 1;
    fi
}

_symfony_installer() {

    local curcontext="$curcontext" state line _packages _opts ret=1

    _arguments -s -w '1: :->cmds' '*:: :->args' && ret=0;

    case $state in
        cmds)
            cmds_list=(`_symfony_get_commands symfony`);
            _values $cmds_list && ret=0;
            ;;
        args)
            opts_list=(`_symfony_get_options symfony $line[1]`);
            _arguments $opts_list && ret=0;
            ;;
    esac;

    return ret;
}

_symfony_console() {

    local curcontext="$curcontext" state line _packages _opts ret=1

    _arguments -s -w  '1: :->cmds' '*:: :->args' && ret=0;

    case $state in
        cmds)
            cmds_list=(`_symfony_get_commands "$(_symfony_find_console)"`);
            _values $cmds_list && ret=0;
            ;;
        args)
            opts_list=(`_symfony_get_options "$(_symfony_find_console)" $line[1]`);
            _arguments $opts_list && ret=0;
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

compdef _symfony_installer 'symfony';
compdef _symfony_console_debug_config 'sfconfig';
compdef _symfony_console_debug_container 'sfservice';
compdef _symfony_console_debug_router 'sfroute';
compdef _symfony_console 'app/console';
compdef _symfony_console 'bin/console';
compdef _symfony_console 'sf';
compdef _symfony_console 'sfhelp';
