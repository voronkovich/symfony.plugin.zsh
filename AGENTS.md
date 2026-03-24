# Project Overview

This project is a Zsh plugin for the Symfony PHP framework. It provides a set of useful commands and shortcuts to streamline development workflows. The plugin also includes autocompletion for Symfony's console commands, the Symfony CLI, and various other tools.

The plugin is designed to be highly configurable and can be adapted to work with different development environments, including local setups, Docker, and DDEV. It also has support for other PHP frameworks like Laravel.

# Building and Running

This is a Zsh plugin, so there is no traditional "build" process. To "run" the plugin, you need to install it and configure your Zsh environment to load it.

## Installation

The `README.md` file provides detailed instructions for installing the plugin using various Zsh plugin managers like Antigen, Zplug, and Oh My Zsh. It also provides instructions for manual installation.

## Testing

The project has a test suite that can be run to verify its functionality. The tests are located in the `tests` directory and can be executed using the `zunit` test runner.

To run the tests, you'll need to have `zunit` installed. Then, you can run the following command from the project's root directory:

```sh
zunit tests
```

# Development Conventions

The project follows standard shell scripting conventions. The code is well-structured and makes good use of functions to organize logic.

The main plugin file is `symfony.plugin.zsh`, which defines the core functions and aliases. The `bin/sf` script is the main entry point for the `sf` command and handles command-line argument parsing and environment detection.

The `completions` directory contains the autocompletion scripts for the plugin's commands. These scripts are written in Zsh's completion syntax.
