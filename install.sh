#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
  && source "./.lib/initializer.sh"

# --------------------------------------------------------------------------------------------------

export SETUP_ROOT="$(pwd)"
export CONFIG_ROOT="$HOME/.config"
export CONFIG_GIT_REMOTE="https://github.com/yardnsm/.config.git"

# --------------------------------------------------------------------------------------------------

__check_os() {
  local -r os="$(os::get_name)"

  if [[ "$os" == 'dafuk' ]]; then
    output::error "Don't even try."
    exit 1
  fi

  output::success "Running on $os"
}

__check_xcode_tools() {
  if [[ "$(os::get_name)" == 'macos' ]]; then
    if ! xcode-select --print-path &> /dev/null; then
      output::error "Xcode Command Line tools are not installed!"

      cat <<EOF

          Install them via:

            $ xcode-select --install

EOF
    else
      output::success "Xcode Command Line tools are installed"
    fi
  fi
}

# --------------------------------------------------------------------------------------------------

__init_config_repo() {
  if [[ -d "$CONFIG_ROOT" ]]; then
    if [[ -d "$CONFIG_ROOT/.git" ]]; then
      output::success "Base dir exists"
      return 0
    else
      output::error "Base dir is not a git repository; aborting."
      exit 1
    fi
  fi

  # Clone the repo!
  commands::execute "git clone $CONFIG_GIT_REMOTE $CONFIG_ROOT" \
    "Cloning base dir"
}

__init_submodules() {
  pushd "$CONFIG_ROOT" &> /dev/null \
    || return 1

  commands::execute "git submodule update --init --recursive --remote -q" \
    "Initializing git modules"

  popd &> /dev/null \
    || return 1
}

# --------------------------------------------------------------------------------------------------

main() {
  export PROFILE=$1

  declare -r PROFILE_PATH="./.profiles/$PROFILE"

  if [[ -z "$PROFILE" ]]; then
    output::error "Missing profile"
    output::help
    exit 1
  fi

  if ! [[ -f "$PROFILE_PATH" ]]; then
    output::error "Unknown profile: $PROFILE"
    output::help
    exit 1
  fi

  # Load profile
  source "$PROFILE_PATH"

  # Make sure it exported the good stuff
  if [[ -z "$SYMLINKS" ]] || [[ -z "$TOPICS" ]]; then
    output::error "Profile $PROFILE does not export \$SYMLINKS ot \$TOPICS"
    exit 1
  fi

  output::welcome_message

  # Run checks
  __init_config_repo
  __init_submodules
  __check_os
  __check_xcode_tools

  # Ask if it's okay
  if ! os::is_ci; then
    output::info "Just to make sure"
    ask::prompt_confirmation "Continue? "
  fi

  # Check if answer is yes
  if ! ( ask::answer_is_yes || os::is_ci ); then
    output::error "Error: aborted"
    exit 1
  fi

  ask::check_sudo

  # Install!
  topics::install_multiple "${TOPICS[*]}"

  output::info "Setup is done! You might need to restart your system to see full changes."
}

echo
main "$@"
