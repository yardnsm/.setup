#!/usr/bin/env bash

# --------------------------------------------------------------------------------------------------

main() {

  # Tap stuff
  if commands::exists 'brew'; then
    brew::tap "homebrew/cask-versions"
    brew::tap "homebrew/cask-fonts"
    brew::tap "mongodb/brew"
  else
    output::error "Homebrew is not installed!"
  fi
}

main "$@"
