#!/usr/bin/env bash

# --------------------------------------------------------------------------------------------------

declare -r formulae=(
  'rbenv'
  'git'
  'subversion'
  'zsh'
  'neovim'
  'tmux'

  'reattach-to-user-namespace'
  'shellcheck'
  'gpg'
  'ansible'
  'maven'

  'Schniz/tap/fnm'
  'node'

  'python'
  'python3'
  'pyenv'
  'pyenv-pip-migrate'
  'pyenv-virtualenv'
  'poetry'
  'mysql'

  'docker'

  'wget'
  'tig'
  'fzf'
  'httpie'
  'jq'
  'diff-so-fancy'
  'imagemagick'
  'the_silver_searcher'
  'ripgrep'
  'watchman'
  'readline'
  'syncthing'
  'asciinema'
  'neofetch'
  'htop'
  'cowsay'
  'figlet'
  'tree'
  'youtube-dl'
  'binwalk'
  'apktool'
  'jadx'

  'coreutils'
  'openssl'

  # From the mongodb/brew tap
  'mongodb-community@5.0'
)

# --------------------------------------------------------------------------------------------------

main () {
  for formula in "${formulae[@]}"; do
    brew::install "$formula"
  done
}

main "$@"
