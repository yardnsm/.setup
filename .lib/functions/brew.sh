#!/usr/bin/env bash

# --------------------------------------------------------------------------------------------------

declare HOMEBREW_PACKAGES_LIST
declare HOMEBREW_TAPS_LIST

# --------------------------------------------------------------------------------------------------

# Install a hombrew / Cask package
brew::install() {

  local package="$1"
  local extra_flags="$2"

  # This for cases when we want to use the x86 version of homwbrew. We'll use it
  # for formulae installations only - not for package list.
  local brew_bin="${3:-brew}"

  if [[ -z "${HOMEBREW_PACKAGES_LIST}" ]]; then
    output::status "Fetching installed packages. This could take a while...\\n"
    HOMEBREW_PACKAGES_LIST="$(brew list && brew cask list 2> /dev/null)"

    # For cases where the list is actually empty on the first run
    [[ -z "${HOMEBREW_PACKAGES_LIST}" ]] && HOMEBREW_PACKAGES_LIST=" "
  fi

  if echo "${HOMEBREW_PACKAGES_LIST}" | grep -q "${package}"; then
    output::success "$package (already installed)"
  else
    commands::execute "$brew_bin install $extra_flags $package" "$package"
  fi
}

# --------------------------------------------------------------------------------------------------

# Install a hombrew tap
brew::tap() {

  local tap="$1"

  if [[ -z "${HOMEBREW_TAPS_LIST}" ]]; then
    HOMEBREW_TAPS_LIST="$(brew tap 2> /dev/null)"
  fi

  if echo "${HOMEBREW_TAPS_LIST}" | grep -q "${tap}"; then
    output::success "Tapping $tap (already installed)"
  else
    commands::execute "brew tap $tap" "Tapping $tap"
  fi
}
