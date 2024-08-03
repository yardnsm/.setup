#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
  && source "../.lib/initializer.sh"

# --------------------------------------------------------------------------------------------------

os::verify "linux" \
  || return 1

commands::verify "apt-get" \
  || return 1

# --------------------------------------------------------------------------------------------------

declare -r packages=(
  'sudo'
  'git'
  'make'
  'curl'
  'tmux'
  'zsh'
  'ruby-full'
  'rbenv'
  'python3.6'
  'neovim'
  'python3-neovim'
  'nodejs'
  'npm'
)

main() {
  output::info "Updating apt"

  commands::execute "sudo apt-get update -qqy" \
    "apt-get (update)"

  output::info "Install APT packages"

  for package in "${packages[@]}"; do
    apt::install "$package"
  done

  output::info "Cleanup"

  commands::execute "sudo apt-get autoremove -qqy" \
    "apt-get (autoremove)"
}

main "$@"
