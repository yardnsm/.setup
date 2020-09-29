#!/usr/bin/env bash

# --------------------------------------------------------------------------------------------------

# Check if a command exists
commands::exists() {
  command -v "$1" &> /dev/null
  return $?
}

# Execute a command and print a message (and show a spinner!)
commands::execute() {
  local -r CMD="$1"
  local -r MSG="$2"
  local -r TMP_FILE="$(mktemp /tmp/XXXXX)"

  local exit_code=0
  local pid=""

  # Run command and append output to output file
  eval "$CMD" \
    &> /dev/null \
    2> "$TMP_FILE" &

  pid="$!"

  spinner:show_for_process $pid "${MSG:-$CMD}"

  wait $pid &> /dev/null
  exit_code=$?

  output::result $exit_code "${MSG:-$CMD}"

  # Print stderr of an error occured
  if [[ $exit_code -ne 0 ]]; then
    output::error_stream < "$TMP_FILE"
  fi

  rm -rf "$TMP_FILE"

  return $exit_code
}

# Verify commands are available in the system
# USAGE:
#
#   commands::verify [--no-output] [...commands]
#
# shellcheck disable=SC2155 disable=SC2124 disable=SC2206
commands::verify() {
local commands=( $@ )

  for cmd in "${commands[@]}"; do
    if ! commands::exists "$cmd"; then
      if [[ "$1" != "--no-output" ]]; then
        output::divider
        output::status "Command '$cmd' is required, but it is not present"
      fi

      return 1
    fi
  done
}
