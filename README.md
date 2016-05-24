# symfony.plugin.zsh

A zsh plugin for the [Symfony 2/3](https://symfony.com/) with usefull commands and an actual autocompletion.

## Installation

Antigen:

```sh
antigen bundle voronkovich/symfony.plugin.zsh
```

Or clone this repo and add this into your .zshrc:

```sh
source path/to/cloned/repo/symfony.plugin.zsh
```

## Usage

This plugin provides some usefull commands and shortcuts:

- `sf` is used for running Symfony console commands. You can run this command inside project's folders because it searches the console script upward from a current dir;
- `sfprod` and `sfdev` are shortcuts for `sf --env=prod` and `sf --env=dev`;
- `sfsh` launches Symfony's shell;
- `sfservice` shows a service definition. It has an autocompletion for service ids;
- `sfroute` shows a route definition. It has autocompletion for routes names;
- `sfconfig` shows a container extensions configuration. It has autocompletion for extensions names;
- `symfony-get-installer` downloads a Symfony installer from the symfony.com;
- `sfnew` is just a shortcut for `symfony new`.

Also this plugin provides a commands and some options autocompletion for both Symfony's console and installer.

## License

Copyright (c) Voronkovich Oleg. Distributed under the MIT.
