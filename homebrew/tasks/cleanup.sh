#!/usr/bin/env bash

# --------------------------------------------------------------------------------------------------

main() {
  if commands::exists 'brew'; then
    commands::execute 'brew cleanup' 'brew (cleanup)'
  fi
}

main "$@"
