#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
  && source "../.lib/initializer.sh"

# --------------------------------------------------------------------------------------------------

main() {
  cd "$CONFIG_ROOT/coc/extensions" \
    || return 1

  output::info "Installing extensions"

  commands::execute \
    "npm install --global-style --no-bin-links  --no-package-lock --only=prod" \
    "Installing all coc extensions"
}

main "$@"
