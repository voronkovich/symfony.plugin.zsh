# symfony.plugin.zsh

[![Tests](https://github.com/voronkovich/symfony.plugin.zsh/actions/workflows/tests.yaml/badge.svg)](https://github.com/voronkovich/symfony.plugin.zsh/actions/workflows/tests.yaml)

A zsh plugin for the [Symfony](https://symfony.com/) PHP framework.

## Features

* Useful commands and shortcuts.
* Symfony's [commands](https://symfony.com/doc/current/console.html) and options autocompletion.
* Autocompletion for [Symfony CLI](https://symfony.com/download).
* [Docker](https://docker.com/) and [DDEV](https://ddev.com/) support.
* Works with [Laravel](#laravel) or any other similar PHP framework.

## Installation

If you need an autocompletion, please, install [symfony-complete.plugin.zsh](https://github.com/voronkovich/symfony-complete.plugin.zsh) first.

### [Antigen](https://github.com/zsh-users/antigen)

```sh
antigen bundle voronkovich/symfony.plugin.zsh

```
### [Zplug](https://github.com/zplug/zplug)

```sh
zplug "voronkovich/symfony.plugin.zsh"
```

### [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)

```sh
git clone https://github.com/voronkovich/symfony.plugin.zsh ~/.oh-my-zsh/custom/plugins/symfony
```

Edit `.zshrc` to enable the plugin:

```sh
plugins=(... symfony)
```

### Manual

Clone this repo and add this into your `.zshrc`:

```sh
source path/to/cloned/repo/symfony.plugin.zsh
```

## Usage

This plugin provides some useful commands and shortcuts:

* `sf` is used for running Symfony's [console commands](https://symfony.com/doc/current/console.html) e.g., `sf debug:router`, `sf c:c`, etc. But it also has some special subcommands:
  - `serve` runs a development web server. Depending on the configuration, it will use `docker compose up`, `symfony serve`, `ddev start`, or `php -S`.
  - `status` shows status (web server, containers, etc.).
  - `stop` stops a development web server.
  - `run` runs a program with an environment depending on the current context (current machine, `symfony run`, `ddev`, `docker`, etc.).
  - `php` runs a PHP (version depends on project's configuration).
  - `composer` runs a [Composer](https://getcomposer.org/).
  - `phpunit` runs a [PHPUnit](https://phpunit.de/).
  - `phive` runs a [PHIVE](https://phar.io/).
  - `psql` runs a [psql](https://www.postgresql.org/docs/current/app-psql.html) PostgreSQL client.
  - `open` opens a local project in a browser.
  - `mails` opens a local project mail catcher web interface in a browser.
* `sfnew` creates a new Symfony project. It's just a shortcut for `symfony new`.
* `sfservice` shows a service definition. It has autocompletion for service IDs.
* `sfroute` shows a route definition. It has autocompletion for route names.
* `sfconfig` shows a container extensions configuration. It has autocompletion for extension names.

## Container Support (Docker/DDEV, etc.)

If you run your app inside a [Docker](https://www.docker.com/) container, you'll probably need to configure a "runner": a command that executes other commands. You can do it by setting a special `SF_RUNNER` environment variable. Just place it in your `.zshrc` or in a local `.env` or `.env.local` files inside of your project's root:

```sh
# "symfony" is a service name in a `docker-compose.yml`
SF_RUNNER="docker-compose exec symfony --"
```

However, if you use [DDEV](https://ddev.com/) or [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker) you don't need to configure anything. It works out of the box.

## Configuration

The `sf` command can be configured via the following environment variables:

- `SF_CONSOLE`: Sets the console binary

   **Allowed values**: Any valid path to a binary file

   **Default:** "bin/console"

   ```sh
   # Yes, you can use this plugin with the Laravel too
   export SF_CONSOLE="artisan"
   ```

- `SF_RUNNER`: Sets the command runner

   **Allowed values**: Any valid command

   **Default:** configured automatically

   ```sh
   export SF_RUNNER="docker-compose exec -- laravel.test"
   ```

- `SF_DDEV`: Enables/disables DDEV auto-detection.

   **Allowed values:** "on", "off"

   **Default:** "on"

   When enabled, `sf` will check the project's folder for the existence of a `.ddev` directory and configure the runner to use `ddev exec`

   ```sh
   # Disable DDEV detection
   export SF_DDEV=off
   ```

- `SF_DOCKER`: Enables/disables Docker auto-detection.

   **Allowed values:** "on", "off"

   **Default:** "on"

   When enabled, `sf` will try to detect a proper runner from `docker-compose.yml` or `docker-compose.yaml` files. If the file exists, `sf` will try to find common service names (`php` and `app`) and automatically configure the runner (e.g., `docker compose exec php --`).

   ```sh
   # Disable Docker detection
   export SF_DOCKER=off
   ```

- `SF_SYMFONY_CLI`: Enables/disables [Symfony CLI](https://symfony.com/download) usage.

   **Allowed values:** "on", "off"

   **Default:** "on"

   When enabled, `sf` will try to detect if [Symfony CLI](https://symfony.com/download) is installed and use it as the runner instead of local `php`.

   ```sh
   # Disable Symfony CLI
   export SF_SYMFONY_CLI=off
   ```

- `SF_LOCAL`: Enables/disables local runner.

   **Allowed values:** "on", "off"

   **Default:** "on"

   When enabled, `sf` will use a default system PHP installation as a fallback.

   ```sh
   # Disable local
   export SF_LOCAL=off
   ```

You can put the configuration in your global `.zshrc` file or in a local `.env` or `.env.local` files inside of your project's root.

## Laravel

By the way, you can use this plugin with [Laravel](https://laravel.com/). To do this, just create a wrapper function in your `.zshrc` with a configuration like this (in this example, I use [Sail](https://laravel.com/docs/9.x/sail)):

```zsh
artisan() {
    SF_CONSOLE='artisan' SF_RUNNER='docker-compose exec -- laravel.test' sf "$@"
}

compdef _sf artisan
```

## ASCII movie

[![asciicast](https://asciinema.org/a/03shcf05p1wz0ppg2dambztig.png)](https://asciinema.org/a/03shcf05p1wz0ppg2dambztig)

## License

Copyright (c) Voronkovich Oleg. Distributed under the MIT.
