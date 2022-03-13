#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
  || exit 1

# --------------------------------------------------------------------------------------------------

export SETUP_ROOT="$(pwd)"
export CONFIG_ROOT="$HOME/.config"
export CONFIG_GIT_REMOTE="https://github.com/yardnsm/.config.git"
export CONFIG_ENV_FILE="$CONFIG_ROOT/zsh/.zshenv"

# --------------------------------------------------------------------------------------------------

source "./.lib/initializer.sh"

commands::verify "git" \
  || return 1

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

__check_rosetta() {
  if [[ "$(os::get_name)" == 'macos' ]]; then
    if ! pkgutil --files com.apple.pkg.RosettaUpdateAuto &> /dev/null; then
      output::error "Rosetta 2 is not installed!"

      cat <<EOF

          Install it via:

            $ sudo softwareupdate --install-rosetta

EOF
    else
      output::success "Rosetta 2 is installed"
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

  commands::execute "git clone --recursive $CONFIG_GIT_REMOTE $CONFIG_ROOT" \
    "Cloning base dir"

}

__init_secrets() {
  pushd "$CONFIG_ROOT" &> /dev/null \
    || return 1

  if ! [[ -f "$CONFIG_ROOT/smudge.sed" ]]; then
    commands::execute "sed 's/^.*\({{.*}}\).*$/s\/\1\/value\//' clean.sed > smudge.sed" \
      "Creating a smudge.sed file for secrets"
  fi

  commands::execute "git config --local filter.vault.clean 'sed -f ~/.config/clean.sed'" \
    "Setting 'clean' filter"

  commands::execute "git config --local filter.vault.smudge 'sed -f ~/.config/smudge.sed'" \
    "Setting 'smudge' filter"

  popd &> /dev/null \
    || return 1
}

__init_environment_variables() {
  if [[ -f "$CONFIG_ENV_FILE" ]]; then
    source "$CONFIG_ENV_FILE"
  else
    output::status "Environment file ($CONFIG_ENV_FILE) is not available - maybe the .config"
    output::status "repository is not initialized correctly. Topics may relay on this file, so"
    output::status "expect weird behaviour.\n"

    ask::prompt_confirmation "Do you want to proceed?"
    if ! ask::answer_is_yes; then
      output::error "Aborted"
      exit 1
    fi

    output::divider
    return 1
  fi
}

# --------------------------------------------------------------------------------------------------

run_topic() {
  local topic="$1"

  if [[ -z "$topic" ]]; then
    output::error "Missing topic to run"
    output::help
    exit 1
  fi

  if ! topics::exists "$topic"; then
    output::error "Unknown topic: $topic"
    output::help
    exit 1
  fi

  __init_environment_variables

  output::status "Please note that this topic might require root privileges"
  topics::install_single "$topic"
}

run_profile() {
  export PROFILE=$1

  if [[ -z "$PROFILE" ]]; then
    output::error "Missing profile"
    output::help
    exit 1
  fi

  if ! profiles::exists "$PROFILE"; then
    output::error "Unknown profile: $PROFILE"
    output::help
    exit 1
  fi

  # Load profile
  source "$(profiles::get_path "$PROFILE")"

  # Make sure it exported the good stuff
  if [[ -z "$SYMLINKS" ]] || [[ -z "$TOPICS" ]]; then
    output::error "Profile $PROFILE does not export \$SYMLINKS ot \$TOPICS"
    exit 1
  fi

  output::welcome_message

  # Run checks
  __check_os
  __check_xcode_tools
  __check_rosetta

  output::info "Initializing base dir"
  __init_config_repo
  __init_secrets
  __init_environment_variables

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

# --------------------------------------------------------------------------------------------------

main() {
  if [[ "$1" == "-t" ]]; then
    shift
    run_topic "$@"
  else
    run_profile "$@"
  fi
}

echo
main "$@"
