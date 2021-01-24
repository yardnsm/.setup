#!/usr/bin/env bash

# --------------------------------------------------------------------------------------------------

declare -r formulae=(
  'rbenv'
  'git'
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

  'mongo'
  'mysql'

  'docker'
  'docker-machine'

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
  'm-cli'
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
  'libxml2'
  'mhash'
  'mcrypt'
  'ntfs-3g'

  # ---[ Retired ]----------------------------------------------------------------------------------

  # 'phantomjs'
  # 'sudolikeaboss'
  # 'hub'
  # 'git-extras'
  # 'yarn'
  # 'heroku'
)

# --------------------------------------------------------------------------------------------------

main () {
  for formula in "${formulae[@]}"; do
    brew::install "$formula"
  done
}

main "$@"
