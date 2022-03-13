#!/usr/bin/env bash

# --------------------------------------------------------------------------------------------------

declare NPM_PACKAGES_LIST

# --------------------------------------------------------------------------------------------------

# Install an NPM package
npm::install() {

  local package="$1"

  if [[ -z "${NPM_PACKAGES_LIST}" ]]; then
    output::status "Fetching installed packages. This could take a while...\\n"
    NPM_PACKAGES_LIST="$(npm list -g --depth 0 -s)"

    # For cases where the list is actually empty on the first run
    [[ -z "${NPM_PACKAGES_LIST}" ]] && NPM_PACKAGES_LIST=" "
  fi

  if echo "${NPM_PACKAGES_LIST}" | grep -q "${package}@"; then
    output::success "$package (already installed)"
  else
    commands::execute "npm install $package -g" "$package"
  fi
}
