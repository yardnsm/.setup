#!/usr/bin/env bash

# --------------------------------------------------------------------------------------------------

# Detect os
os::get_name() {
  if [[ "$(uname -s)" == "Linux" ]]; then
    echo "linux"
  elif [[ "$(uname -s)" == "Darwin" ]]; then
    echo 'macos'
  else
    echo ''
  fi
}

# Verify the running os
# USAGE:
#
#   os::verify [--no-output] [...commands]
#
# shellcheck disable=SC2155 disable=SC2124
os::verify() {
  local names="$@"
  local current="$(os::get_name)"

  if [[ ! " ${names[*]} " == *" ${current} "* ]]; then
    if [[ "$1" != "--no-output" ]]; then
      output::divider
      output::status "Not suitable for $current"
    fi

    return 1
  fi
}

# Are we inside... a CI?
os::is_ci() {
  [[ -n "$CI" ]] \
    || [[ -n "$TRAVIS" ]] \
    || [[ -n "$GITHUB_WORKFLOW" ]]
}
