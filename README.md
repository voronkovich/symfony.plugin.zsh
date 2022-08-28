# symfony.plugin.zsh

A zsh plugin for the [Symfony](https://symfony.com/) with usefull commands and an actual autocompletion.

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
- `sfservice` shows a service definition. It has an autocompletion for service ids;
- `sfroute` shows a route definition. It has autocompletion for routes names;
- `sfconfig` shows a container extensions configuration. It has autocompletion for extensions names;
- `sfhelp` shows a help message for a specified command;
- `sfnew` is just a shortcut for `symfony new`.

Also this plugin provides a commands and some options autocompletion for both Symfony's console and installer.

## Ascii movie

[![asciicast](https://asciinema.org/a/03shcf05p1wz0ppg2dambztig.png)](https://asciinema.org/a/03shcf05p1wz0ppg2dambztig)

## License

Copyright (c) Voronkovich Oleg. Distributed under the MIT.
