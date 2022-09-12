path=("${0:A:h}/bin" $path)

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

__symfony_get_items() {
    "$@" --no-ansi 2>/dev/null | sed -nr 's/^  ?([a-z_][^[:space:]]+) .*$/\1/p'
}

__symfony_get_services() {
    __symfony_get_items sf debug:container
}

__symfony_get_routes() {
    __symfony_get_items sf debug:router
}

__symfony_get_config_keys() {
    sf debug:config --no-ansi 2>&1 | sed -nE -e 's/^.*\w+Bundle[[:space:]]+([a-z_]+).*$/\1/p'
}

_symfony_console_debug_config() {
    compadd `__symfony_get_config_keys`
}

_symfony_console_debug_container() {
    compadd `__symfony_get_services`
}

_symfony_console_debug_router() {
    compadd `__symfony_get_routes`
}

compdef _symfony_console_debug_config 'sfconfig'
compdef _symfony_console_debug_container 'sfservice'
compdef _symfony_console_debug_router 'sfroute'
