#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
  && source "../.lib/initializer.sh"

# --------------------------------------------------------------------------------------------------

# I realy don't want to add shellcheck as a submodule,
# so this script assume you got it installed on your machine.

main() {
  output::info "Running shellcheck"

  if ! commands::exists "shellcheck"; then
    output::error "shellcheck is not installed!"
    return 1
  fi

  find .. \
    -type f \
    -name '*.sh' \
    -exec shellcheck \
    {} +

  output::result $? "Shellcheck"
}

main "$@"
