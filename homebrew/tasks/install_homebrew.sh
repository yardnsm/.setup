#!/usr/bin/env bash

# --------------------------------------------------------------------------------------------------


__load_homebrew() {
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

main() {

  __load_homebrew

  # Install Homebrew
  if ! commands::exists 'brew'; then
    printf "\\n" \
      | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
      &> /dev/null
  fi

  output::result $? 'Homebrew'

  __load_homebrew
}

main "$@"
