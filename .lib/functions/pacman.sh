#!/usr/bin/env bash

# --------------------------------------------------------------------------------------------------

# Install a package via pacman

pacman::install() {

  local package="$1"

  if ( pacman -Q "$package" &> /dev/null) ; then
    output::success "$package (already installed)"
  else
    commands::execute "sudo pacman --noconfirm --needed -S $package" "$package"
  fi
}
