#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
  && source "../.lib/initializer.sh"

# --------------------------------------------------------------------------------------------------

declare -r PYENV_VIRTUALENV_RELPATH="plugins/pyenv-virtualenv"

declare -r pips=(
  'yapf'
  'flake8'
  'jedi'
  'neovim'
  'pypcap'
  'python-language-server[all]'

  'virtualenv'
  'pipenv'

  'scapy'
  'pyx'
)

# --------------------------------------------------------------------------------------------------

__install_pyenv_virtualenv() {
  if ! commands::exists 'pyenv'; then
    output::error "pyenv does not exist; skipping."
    return 1
  fi

  if [[ -e "$(pyenv root)/$PYENV_VIRTUALENV_RELPATH" ]]; then
    output::success "pyenv-virtualenv is already installed"
  else
    commands::execute "git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/$PYENV_VIRTUALENV_RELPATH" \
      "Installing pyenv-virtualenv"
  fi
}

# --------------------------------------------------------------------------------------------------

main() {
  output::info "Installing pips"

  for pip in "${pips[@]}"; do
    pip::install "$pip"
  done

  output::info "Installing pyenv-virtualenv"
  __install_pyenv_virtualenv
}

main "$@"
