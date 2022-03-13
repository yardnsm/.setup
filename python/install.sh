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
  'virtualenv'
  'pipenv'
  'scapy'
)

# --------------------------------------------------------------------------------------------------

__install_pyenv_python() {
  if ! commands::exists 'pyenv'; then
    output::error "pyenv does not exist; skipping."
    return 1
  fi

  if [[ -z "$PYENV_VERSION" ]]; then
    output::error "\$PYENV_VERSION is not set; skipping."
    return 1
  fi

  eval "$(command pyenv init -)"

  if pyenv versions | grep -q "$PYENV_VERSION"; then
    output::success "Version $PYENV_VERSION already installed."
    return 0
  fi

  commands::execute "pyenv install $PYENV_VERSION" \
    "Installing Python $PYENV_VERSION"
}

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
  output::info "Installing python via pyenv"
  __install_pyenv_python

  output::info "Installing pips"

  for pip in "${pips[@]}"; do
    pip::install "$pip"
  done

  output::info "Installing pyenv-virtualenv"
  __install_pyenv_virtualenv
}

main "$@"
