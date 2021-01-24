#!/usr/bin/env bash

# --------------------------------------------------------------------------------------------------

declare -r __PROFILES_ROOT="$SETUP_ROOT/.profiles"

# Get the path to the profiles directory
profiles::get_path() {
  echo "$__PROFILES_ROOT/$1"
}

# Get all profiles
profiles::get_all() {
  find "$__PROFILES_ROOT" \
    ! -name ".profiles" \
    -exec basename {} \;
}

# Check if a profile exists
profiles::exists() {
  test -f "$__PROFILES_ROOT/$1"
  return $?
}

# Load a specific profile
profiles::load() {
  local -r PROFILE="$1"
  shift
  source "$__PROFILES_ROOT/$PROFILE" "$@"
}
