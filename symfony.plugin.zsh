alias sfsh='sf --shell';
alias sfprod='sf --env=prod';
alias sfdev='sf --env=dev';
alias sfnew='symfony new';
alias sfstart='sf server:start';
alias sfrun='sf server:run -vvv';
alias sfstop='sf server:stop';
alias encore-watch='encore dev --watch'

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

flex() {
    if [[ $# -eq 0 ]]; then
        echo -en "
\e[32mSymfony Flex Helper\e[0m by your best friend Oleg Voronkovich

\e[33mUsage:\e[0m

    \e[32mflex\e[0m new      Create a new Symfony project in the current dir
    \e[32mflex\e[0m PACKAGES Install a set of listed packages

\e[33mExamples:\e[0m

    \e[32mflex\e[0m new
    \e[32mflex\e[0m new 3.3

    \e[32mflex\e[0m api admin
    \e[32mflex\e[0m cli:dev-master
"
        return 0;
    fi

    if [[ "$1" == 'new' ]]; then
        composer create-project symfony/skeleton . $2;
    else
        composer require $@;
    fi
}

encore() {
    pwd=$(pwd);
    if [[ ! -f "$(pwd)/node_modules/.bin/encore" ]]; then
        echo  "
Encore is not found. Install it by using one of these commands:

yarn add @symfony/webpack-encore --dev

npm install @symfony/webpack-encore --save-dev

flex webpack-encore" >&2;

        return 1;
    fi

    "$pwd/node_modules/.bin/encore" $*;
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
        -e '/^.*--help.*$/,$d' \
        -e 's/([[]|[]])/\\\1/g' \
        -e 's/:/\\\:/g' \
        -e 's/^.*(--[^=\[[:space:]]+=?)[^[:space:]]*[[:space:]]*(.*)$/"\1[\2]"/p' \
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
        '1: :->cmds' \
        '*:: :->args' \
        && ret=0;

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
        '1: :->cmds' \
        '*:: :->args' \
        && ret=0;

    case $state in
        cmds)
            cmds_list=(`_symfony_get_commands "$(_symfony_find_console)"`);
            eval _values $cmds_list && ret=0;
            ;;
        args)
            opts_list=(`_symfony_get_options "$(_symfony_find_console)" $line[1]`);
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

_symfony_flex() {
    _symfony_flex_load_aliases;
    compadd 'new';
    compadd $(echo $SYMFONY_FLEX_ALIASES);
}

export SYMFONY_FLEX_ALIASES='';
_symfony_flex_load_aliases() {
    if [[ "$SYMFONY_FLEX_ALIASES" == '' ]]; then
        echo "\nLoading information about available packages from symfony.sh ...";
        SYMFONY_FLEX_ALIASES=$(curl -sf 'https://symfony.sh/aliases.json' | tr -s '{}:,"' ' ' | xargs -n1 | sort -u);
    fi
}

_symfony_encore() {
    compadd 'dev' 'dev-server' 'production';
}

compdef _symfony_installer 'symfony';
compdef _symfony_console_debug_config 'sfconfig';
compdef _symfony_console_debug_container 'sfservice';
compdef _symfony_console_debug_router 'sfroute';
compdef _symfony_console 'app/console';
compdef _symfony_console 'bin/console';
compdef _symfony_console 'sf';
compdef _symfony_console 'sfhelp';
compdef _symfony_flex 'flex';
compdef _symfony_encore 'encore';
