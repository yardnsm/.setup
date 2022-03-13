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
  'np'
  'firebase-tools'
  'ava'
  'speed-test'

  'stylelint-config-standard'

  # ---[ Retired ]----------------------------------------------------------------------------------

  # 'bower'
  # 'gulp'
  # 'bs-platform'
  # 'hicat'
  # 'yo'
  # 'typescript'
  # 'tern'
  # 'tern-jsx'
  # 'fast-cli'
  # 'emoj'
  # 'javascript-typescript-langserver'
  # 'vscode-css-languageserver-bin'
  # 'typescript-language-server'
  # 'vscode-html-languageserver-bin'
  # 'bash-language-server'
  # 'stylable-intelligence'
)

# --------------------------------------------------------------------------------------------------

main() {
  output::info "Installing NPM global dependencies"

  for dep in "${dependencies[@]}"; do
    npm::install "$dep"
  done
}

main "$@"
