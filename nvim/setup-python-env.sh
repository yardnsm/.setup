#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
  && source "../.lib/initializer.sh"

# --------------------------------------------------------------------------------------------------

setup_env() {
  local -r venv_name="$1"
  local -r python_version="$2"

  output::title "Setting Virtual Environment '$venv_name' with version $python_version"

  if pyenv virtualenvs | awk '{ print $1 }' | grep -q "$python_version/envs/$venv_name"; then
    echo
    output::status "Virtualenv '$venv_name' already exists; skipping."
    return 0
  fi

  output::info "Installing Python $python_version"
  pyenv install "$python_version"

  output::info "Creating a virtualenv $venv_name"
  pyenv virtualenv "$python_version" "$venv_name"
  pyenv activate "$venv_name"

  output::info "Installing neovim pip module"
  pip install neovim pynvim

  output::info "Installing additional pipes"
  pip install python-language-server jedi

  pyenv deactivate
}

main() {
  eval "$(command pyenv init -)"

  if ! commands::exists 'pyenv'; then
    output:error "pyenv does not exist; skipping."
    return 1
  fi

  setup_env "neovim3" "3.6.3"
  setup_env "neovim2" "2.7.13"
}

main "$@"
