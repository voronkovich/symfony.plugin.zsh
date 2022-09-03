alias sfprod='sf --env=prod'
alias sfdev='sf --env=dev'

export PATH="${0:A:h}/bin:${PATH}"

sfservice() {
    sf debug:container "$@"
}

sfroute() {
    sf debug:router "$@"
}

sfconfig() {
    sf debug:config "$@"
}

_symfony_get_commands() {
    "$@" list --no-ansi 2>/dev/null | \
        sed -nr \
        -e '1,/Available commands/d' \
        -e 's/([[]|[]])/\\\1/g' \
        -e 's/:/\\\:/g' \
        -e 's/^  ([[:alnum:]\\:-]+).*  (.*)$/\1[\2]/p'
}

_symfony_get_options() {
    "$@" --help --no-ansi 2>/dev/null | \
        sed -nr \
        -e '1,/^Options/d' \
        -e '/^Help/,$d' \
        -e 's/([[]|[]])/\\\1/g' \
        -e 's/:/\\\:/g' \
        -e 's/^.*[[:space:]](--[[:alnum:]-]+=?).*  (.*)$/\1[\2]/p'
}

_symfony_get_items() {
    "$@" --no-ansi 2>/dev/null | sed -nr 's/^  ?([a-z_][^[:space:]]+) .*$/\1/p'
}

_symfony_get_services() {
    _symfony_get_items sf debug:container
}

_symfony_get_routes() {
    _symfony_get_items sf debug:router
}

_symfony_get_config_keys() {
    sf debug:config | sed -nr 's/^.*\| ([a-z_][^[:space:]]+) .*$/\1/p'
}

_sf() {
    local curcontext="${curcontext}" state line ret=1
    typeset -A opt_args

    _arguments '1: :->cmds' '*: :->args' && ret=0

    case ${state} in
        cmds)
            IFS=$'\n' cmds_list=(
                $'new[Create a new Symfony project]'
                $'serve[Run a local web server]'
                $'status[Get the local web server status]'
                $'open[Open the local project in a browser]'
                $'mails[Open the local project mail catcher web interface in a browser]'
                $'run[Run a program with environment variables set depending on the current context]'
                $'php[Run PHP (version depends on project\'s configuration)]'
                $'composer[Run Composer without memory limit]'
                $'phpunit[Run PHPUnit]'
                $'psql[Run psql]'
                $(_symfony_get_commands sf 2>/dev/null)
            )
            _values '' ${cmds_list} && ret=0
            ;;
        args)
            IFS=$'\n' opts_list=($(_symfony_get_options sf "${line[1]}" 2>/dev/null))
            _arguments '*: :_files' ${opts_list} && ret=0
            ;;
    esac

    return ret
}

_symfony_cli() {
    local curcontext="${curcontext}" state line ret=1
    typeset -A opt_args

    _arguments '1: :->cmds' '*: :->args' && ret=0

    case ${state} in
        cmds)
            IFS=$'\n' local cmds_list=(
                $'serve[Run a local web server]'
                $'run[Run a program with environment variables set depending on the current context]'
                $(_symfony_get_commands symfony 2>/dev/null | sed -e 's/^local\\:server/server/')
            )
            _values '' ${cmds_list} && ret=0
            ;;
        args)
            IFS=$'\n' local opts_list=($(_symfony_get_options symfony "${line[1]}" 2>/dev/null))
            _arguments '*: :_files' ${opts_list} && ret=0
            ;;
    esac

    return ret
}

_symfony_console() {
    local curcontext="${curcontext}" state line ret=1
    typeset -A opt_args

    _arguments '1: :->cmds' '*: :->args' && ret=0

    case ${state} in
        cmds)
            IFS=$'\n' local cmds_list=($(_symfony_get_commands "${words[1]}" 2>/dev/null))
            _values '' ${cmds_list} && ret=0
            ;;
        args)
            IFS=$'\n' local opts_list=($(_symfony_get_options "${words[1]}" "${line[1]}" 2>/dev/null))
            _arguments '*: :_files' ${opts_list} && ret=0
            ;;
    esac

    return ret
}

_symfony_console_debug_config() {
    compadd `_symfony_get_config_keys`
}

_symfony_console_debug_container() {
    compadd `_symfony_get_services`
}

_symfony_console_debug_router() {
    compadd `_symfony_get_routes`
}

compdef _sf 'sf'
compdef _symfony_cli 'symfony'
compdef _symfony_console 'bin/console'
compdef _symfony_console_debug_config 'sfconfig'
compdef _symfony_console_debug_container 'sfservice'
compdef _symfony_console_debug_router 'sfroute'
