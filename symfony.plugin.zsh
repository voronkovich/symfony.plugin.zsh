alias sfprod='sf --env=prod'
alias sfdev='sf --env=dev'

export PATH="${0:A:h}/bin:${PATH}"

if [[ "$(type -w _symfony_complete)" == '_symfony_complete: function' ]]; then
    fpath=("${0:A:h}/completions" $fpath)
fi

sfservice() {
    sf debug:container "$@"
}

sfroute() {
    sf debug:router "$@"
}

sfconfig() {
    sf debug:config "$@"
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

_symfony_console_debug_config() {
    compadd `_symfony_get_config_keys`
}

_symfony_console_debug_container() {
    compadd `_symfony_get_services`
}

_symfony_console_debug_router() {
    compadd `_symfony_get_routes`
}

compdef _symfony_console_debug_config 'sfconfig'
compdef _symfony_console_debug_container 'sfservice'
compdef _symfony_console_debug_router 'sfroute'
