alias sfprod='sf --env=prod';
alias sfdev='sf --env=dev';

sf() (
    case "${1}" in
        new )
            shift && exec sfnew "$@"
            ;;
        serve )
            shift && exec sfserve "$@"
            ;;
        php )
            if command -v symfony >/dev/null; then
                shift && exec symfony php "$@"
            fi

            shift && exec php "$@"
            ;;
        composer )
            if command -v symfony >/dev/null; then
                shift && exec symfony composer "$@"
            fi

            shift && exec composer "$@"
            ;;
        phpunit )
            if command -v symfony >/dev/null; then
                shift && exec symfony php bin/phpunit "$@"
            fi

            echo 'Symfony CLI required: https://symfony.com/download' >&2 && return 1
            ;;
        run )
            if command -v symfony >/dev/null; then
                shift && exec symfony run "$@"
            fi

            echo 'Symfony CLI required: https://symfony.com/download' >&2 && return 1
            ;;
        psql )
            if command -v symfony >/dev/null; then
                shift && exec symfony run psql "$@"
            fi

            echo 'Symfony CLI required: https://symfony.com/download' >&2 && return 1
            ;;
        open )
            if command -v symfony >/dev/null; then
                shift && exec symfony open:local "$@"
            fi

            echo 'Symfony CLI required: https://symfony.com/download' >&2 && return 1
            ;;
        status )
            if command -v symfony >/dev/null; then
                shift && exec symfony server:status "$@"
            fi

            echo 'Symfony CLI required: https://symfony.com/download' >&2 && return 1
            ;;
        mails|webmail )
            if command -v symfony >/dev/null; then
                shift && exec symfony open:local:webmail "$@"
            fi

            echo 'Symfony CLI required: https://symfony.com/download' >&2 && return 1
            ;;
    esac

    if [[ ! -f bin/console ]]; then
        echo 'Symfony console not found: bin/console' >&2
        return 1
    fi

    if command -v symfony >/dev/null; then
        exec symfony console "$@"
    fi

    exec bin/console "$@"
)

sfnew() (
    if command -v symfony >/dev/null; then
        exec symfony new "$@"
    fi

    local help version webapp

    zmodload zsh/zutil
    zparseopts -D -F -K -- \
        {h,-help}=help \
        -webapp=webapp \
        -version:=version \
        || return 1

    if [[ -n "${help}" ]]; then
        cat <<HELP
Create a new Symfony project

Usage:
  ${0} [options] [--] [<directory>]

Arguments:

  directory  Directory of the project to create

Options:

  --version=value  The version of the Symfony skeleton
  --webapp         Add the webapp pack to get a fully configured web project
  -h, --help       Show this help
HELP
        return 0
    fi

    if [[ -z ${1} ]]; then
        echo 'A directory must be passed as an argument or via the --dir option' >&2
        return 1
    fi

    composer create-project "symfony/skeleton${version[1]:+:}${version[2]/=}" "${1}" \
        && [[ -n "${webapp}" ]] && composer --working-dir="${1:-skeleton}" require webapp
)

sfserve() (
    if command -v symfony >/dev/null; then
        exec symfony serve "$@"
    fi

    local help port=('--port' '8000') root=('--document-root' 'public')

    zmodload zsh/zutil
    zparseopts -D -F -K -- \
        {h,-help}=help \
        -port:=port \
        -document-root:=root \
        || return 1

    if [[ -n "${help}" ]]; then
        cat <<HELP
Run a local web server

Usage:

  ${0} [options]

Options:

  --port=value           Preferred HTTP port [default: ${port[2]}]
  --document-root=value  Project document root [default: ${root[2]}]
  -h, --help             Show this help
HELP
        return 0
    fi

    exec php -S "127.0.0.1:${port[2]}" -t "${root[2]}"
)

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

    "${1}" --no-ansi list | \
        sed -nr \
        -e '1,/Available commands/d' \
        -e 's/([[]|[]])/\\\1/g' \
        -e 's/:/\\\:/g' \
        -e 's/^  ?([^[:space:]]+) +(.*)$/"\1[\2]"/p' \
    ;
}

_symfony_get_options() {
    ([[ -z $1 ]] || [[ -z $2 ]]) && return 1;

    "${1}" "${2}" --help --no-ansi | \
        sed -nr \
        -e '1,/^Options/d' \
        -e '/^Help/,$d' \
        -e 's/([[]|[]])/\\\1/g' \
        -e 's/:/\\\:/g' \
        -e 's/^.*(--[^=\[[:space:]]+=?)[^[:space:]]*[[:space:]]*(.*)$/"\1[\2]"/p' \
    ;
}

_symfony_get_items() {
    "${1}" "${2}" --no-ansi | sed -nr 's/^  ?([a-z_][^[:space:]]+) .*$/\1/p';
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
            cmds_list=($'""'
                $'"mails[Open the local project mail catcher web interface in a browser]"'
                $'"new[Create a new Symfony project]"'
                $'"serve[Run a local web server]"'
                $'"status[Get the local web server status]"'
                $'"open[Open the local project in a browser]"'
                $'"php[Run PHP (version depends on project\'s configuration)]"'
                $'"composer[Run Composer without memory limit]"'
                $'"phpunit[Run PHPUnit]"'
                $'"psql[Run psql]"'
                $(_symfony_get_commands sf 2>/dev/null)
            );
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
compdef _symfony_console 'sfhelp';
compdef _symfony_console_debug_config 'sfconfig';
compdef _symfony_console_debug_container 'sfservice';
compdef _symfony_console_debug_router 'sfroute';
