#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
  && source "../.lib/initializer.sh"

# --------------------------------------------------------------------------------------------------

declare -r crates=(
  'stylua'
)

# --------------------------------------------------------------------------------------------------

main() {
  output::info "Installing Crates"

  for crate in "${crates[@]}"; do
    crate::install "$crate"
  done
}

main "$@"
