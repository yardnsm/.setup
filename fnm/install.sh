#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
  && source "../.lib/initializer.sh"

# --------------------------------------------------------------------------------------------------

declare -r FNM_DIR="${XDG_DAATA_HOME:-$HOME/.local/share}/.fnm"
declare -r FNM_INSTALL_FILE="https://raw.githubusercontent.com/Schniz/fnm/master/.ci/install.sh"

# --------------------------------------------------------------------------------------------------

# We're installing fnm via Homebrew under macOS
os::verify "macos" \
  || return 1

# --------------------------------------------------------------------------------------------------

main() {
  output::info "Installing fnm"

  if [[ -d "$FNM_DIR" ]]; then
    output::success "fnm is installed"
  else
    commands::execute "curl $FNM_INSTALL_FILE | bash -s -- --install-dir $FNM_DIR --skip-shell" \
      "Installing fnm"
  fi
}

main "$@"
