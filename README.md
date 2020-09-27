# .setup

[![Build Status](https://github.com/yardnsm/.setup/workflows/main/badge.svg)](https://github.com/yardnsm/.setup/actions)

These are my setup scripts for setting up a new machine. It installs my
[dotfiles](https://github.com/yardnsm/.config), which placed by default under `~/.config`.

## Installation

Simply run the following commands in your terminal:

```bash
# Clone this repository
$ git clone https://github.com/yardnsm/.setup ~/dev/.setup

# Run the installation script
$ cd dev/.setup
$ ./install.sh
```

## Order and hierarchy

A "profile" is shell scripts that sets up environment variables which configure the installation of
the dotfiles. They are located under [`./.profiles`](./.profiles) and should export the following
environment variables:

### `$SYMLINKS`

An array that contains the files to symlink from the dotfiles repository to `$HOME`, or any other
directory on the system.

```bash
export SYMLINKS=(
  # By default, items will be symlinked from the dotfiles repository (located under ~/.config) to
  # $HOME.

  # This will symlink ~/.config/zsh/.zshenv to ~/.zshenv
  "zsh/.zshenv"

  # You can specify a name for the target. The following will symlink ~/.config/tmux/tmux.conf to
  # ~/.tmux.conf
  "tmux/tmux.conf .tmux.conf"

  # Of course, you can symlinks files to anywhere in the system. The following will symlink
  # ~/.config/bash/bashrc to /etc/bashrc
  "bash/bashrc /etc/bashrc"
)
```

### `$TOPICS`

Every non-hidden directory in this repo is considered as a "topic". A topic must have an
`install.sh` file that will run during the installation of this repo.

The `$TOPICS` variable specifies the topics to run when installing the profile.

```bash
export TOPICS=(
  common
  homebrew
  macos
  nvim
  ssh
  zsh
)
```

----------------------------------------------------------------------------------------------------

###### This repository is a squashed fork of [`yardnsm/.config@053dc7b`](https://github.com/yardnsm/.config/tree/053dc7baaf8ae34d731947d7b6146539b55115a0).

## License

MIT © [Yarden Sod-Moriah](http://yardnsm.net/)
