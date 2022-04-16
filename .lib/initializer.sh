#!/usr/bin/env bash

# This script will be sourced in other scripts, so we don't want
# it to mess with the cwd
pushd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null \
  || exit 1

declare __initialized=${__initialized:-}

# --------------------------------------------------------------------------------------------------

# Check if sourced before
if [[ -z "$__initialized" ]]; then

  __initialized=1

  source "./functions/apt.sh"
  source "./functions/brew.sh"
  source "./functions/gem.sh"
  source "./functions/crate.sh"
  source "./functions/npm.sh"
  source "./functions/pip.sh"
  source "./functions/pacman.sh"
  source "./functions/yay.sh"

  source "./actions.sh"
  source "./ask.sh"
  source "./commands.sh"
  source "./topics.sh"
  source "./profiles.sh"
  source "./os.sh"
  source "./output.sh"
  source "./spinner.sh"
fi

# --------------------------------------------------------------------------------------------------

popd &> /dev/null \
  || return 1
