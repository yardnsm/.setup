#!/usr/bin/env bash

# --------------------------------------------------------------------------------------------------

declare CRATES_PACKAGES_LIST

# --------------------------------------------------------------------------------------------------

# Install a Crate
crate::install() {

  local package="$1"

  if [[ -z "${CRATES_PACKAGES_LIST}" ]]; then
    output::status "Fetching installed packages. This could take a while...\\n"
    CRATES_PACKAGES_LIST="$(cargo install --list)"
  fi

  if echo "${CRATES_PACKAGES_LIST}" | grep -q "${package}"; then
    output::success "$package (already installed)"
  else
    commands::execute "cargo install $package" "$package"
  fi
}
