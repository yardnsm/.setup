#!/usr/bin/env bash

# --------------------------------------------------------------------------------------------------

# Install a package via yay

yay::install() {

  local package="$1"

  if ( yay -Q "$package" &> /dev/null) ; then
    output::success "$package (already installed)"
  else
    commands::execute "yay --noconfirm -S $package" "$package"
  fi
}
