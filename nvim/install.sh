#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
  && source "../.lib/initializer.sh"

# --------------------------------------------------------------------------------------------------

commands::verify "curl" \
  || return 1

# --------------------------------------------------------------------------------------------------

declare -r VIM_PLUG_PATH="$CONFIG_ROOT/nvim/autoload/plug.vim"
declare -r VIM_PLUG_FILE="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

# --------------------------------------------------------------------------------------------------

install_vim_plug() {
  if [[ -e "$VIM_PLUG_PATH" ]]; then
    output::success "vim-plug is installed"
  else
    commands::execute "curl -fLo $VIM_PLUG_PATH --create-dirs $VIM_PLUG_FILE" \
      "Installing vim-plug"
  fi
}

install_plugins() {
  if os::is_ci; then
    output::status "Skipping inside a CI"
  else

    # For some reason, `PlugInstall` hates output::execute
    nvim -c 'PlugInstall' -c 'UpdateRemotePlugins' -c 'qall' &> /dev/null
    output::result $? "Installed plugins"
  fi
}

install_lsp_servers() {
  if os::is_ci; then
    output::status "Skipping inside a CI"
  else
    commands::execute "nvim -c 'LspInstallAll' -c 'qall'" \
      "Installing LSP servers"
  fi
}

setup_python_venv() {
  local -r venv_name="$1"
  local -r python_version="$2"

  output::info "Setting Virtual Environment '$venv_name' with version $python_version"

  if ! commands::exists 'pyenv'; then
    output::error "pyenv does not exist; skipping."
    return 1
  fi

  eval "$(command pyenv init -)"

  if pyenv virtualenvs | awk '{ print $1 }' | grep -q "$python_version/envs/$venv_name"; then
    output::status "Virtualenv '$venv_name' already exists; skipping."
    return 0
  fi

  commands::execute "pyenv install $python_version" \
    "Installing Python $python_version"

  commands::execute "pyenv virtualenv $python_version $venv_name" \
    "Creating a virtualenv $venv_name"

  pyenv activate "$venv_name" &> /dev/null
  output::result "$?" " --> Activating virtualenv $venv_name"

  commands::execute "pip3 install neovim pynvim" \
    "Installing neovim pip module"

  commands::execute "pip3 install python-language-server jedi" \
    "Installing additional pipes"

  pyenv deactivate &> /dev/null
  output::result "$?" " <-- De-activating virtualenv $venv_name"
}

# --------------------------------------------------------------------------------------------------

main() {
  output::info "Installing vim-plug"
  install_vim_plug

  output::info "Installing plugins"
  install_plugins
  install_lsp_servers

  setup_python_venv "neovim3" "3.9.1"
  # setup_python_venv "neovim2" "2.7.13"
}

main "$@"
