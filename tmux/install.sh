#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
  && source "../.lib/initializer.sh"

# --------------------------------------------------------------------------------------------------

main() {
  output::info "Installing plugins"

  commands::execute "$CONFIG_ROOT/tmux/tpm/scripts/install_plugins.sh" \
    "Installing tmux plugins (using tpm)"
}

main "$@"
