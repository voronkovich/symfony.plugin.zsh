# symfony.plugin.zsh

[![Tests](https://github.com/voronkovich/symfony.plugin.zsh/actions/workflows/tests.yaml/badge.svg)](https://github.com/voronkovich/symfony.plugin.zsh/actions/workflows/tests.yaml)

A zsh plugin for the [Symfony](https://symfony.com/) console and CLI.

## Installation

If yout need an autocompletion, please, install [symfony-complete.plugin.zsh](https://github.com/voronkovich/symfony-complete.plugin.zsh).

[Antigen](https://github.com/zsh-users/antigen):

```sh
antigen bundle voronkovich/symfony.plugin.zsh
```
[Zplug](https://github.com/zplug/zplug):

```sh
zplug "voronkovich/symfony.plugin.zsh"
```

Or clone this repo and add this into your `.zshrc`:

```sh
source path/to/cloned/repo/symfony.plugin.zsh
```

## Usage

This plugin provides some usefull commands and shortcuts:

- `sf` is used for running Symfony console commands e.g `sf debug:router`, `sf c:c` and etc.;
- `sf new` creates new Symfony project. It's just a shortcut for `symfony new`;
- `sf serve` runs a web server. Depending on configuration it's just a shortcut for `symfony serve`, `ddev start` or `php -S`;
- `sf run` runs a program with environment depending on the current context (current machine, `symfony run`, `ddev`, `docker` and etc.);
- `sf php` runs a PHP (version depends on project's configuration);
- `sf composer` runs a [Composer](https://getcomposer.org/);
- `sf phpunit` runs a [PHPUnit](https://phpunit.de/);
- `sf phive` runs a [PHIVE](https://phar.io/);
- `sf psql` runs a [psql](https://www.postgresql.org/docs/current/app-psql.html) PostgreSQL client;
- `sf open` opens a local project in a browser;
- `sf mails` open a local project mail catcher web interface in a browser;
- `sfservice` shows a service definition. It has an autocompletion for services ids;
- `sfroute` shows a route definition. It has autocompletion for routes names;
- `sfconfig` shows a container extensions configuration. It has autocompletion for extensions names;

## Containers support (Docker/DDEV and etc.)

If you need to run you app inside a Docker Container, you should configure a "runner", by setting a special `SF_RUNNER` environment variable. You can place it in your `.zshrc` or in a local `.env.local` file inside you project directory:

```sh
# Should work with https://github.com/dunglas/symfony-docker
SF_RUNNER="docker-compose exec php"
```

If you use a [DDEV](https://ddev.com/) you don'n need to configure anything at all. It works out of the box.

## Ascii movie

[![asciicast](https://asciinema.org/a/03shcf05p1wz0ppg2dambztig.png)](https://asciinema.org/a/03shcf05p1wz0ppg2dambztig)

## License

Copyright (c) Voronkovich Oleg. Distributed under the MIT.
