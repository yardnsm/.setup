#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
  && source "../.lib/initializer.sh"

# --------------------------------------------------------------------------------------------------

declare -r dependencies=(
  'http-server'
  'nodemon'
  'json-server'
  'npm-upgrade'
  'trymodule'
  'firebase-tools'
  'speed-test'
)

main() {
  output::info "Installing NPM global dependencies"

  for dep in "${dependencies[@]}"; do
    npm::install "$dep"
  done
}

main "$@"
