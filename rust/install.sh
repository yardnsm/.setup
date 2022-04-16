#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
  && source "../.lib/initializer.sh"

# --------------------------------------------------------------------------------------------------

main() {
  output::info "Installing Rust"

  if ! commands::exists 'rust'; then
    commands::execute \
      "curl https://sh.rustup.rs -sSf | sh -s -- -y" \
      "Rust (via rustup)"
  else
    output::success 'Rust is already installed'
  fi
}

main "$@"
