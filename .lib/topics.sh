#!/usr/bin/env bash

# --------------------------------------------------------------------------------------------------

# Get all topics
topics::get_all() {
  find "$SETUP_ROOT" \
    -maxdepth 1 \
    -type d \
    ! -name '.*' \
    -exec basename {} \; \
    | sort

}

# Check if a topic exists
topics::exists() {
  test -d "$SETUP_ROOT/$1"
  return $?
}

# Install a specific topic
topics::install_single() {
  local -r TOPIC=$1

  output::title "Current topic is '$TOPIC'"
  source "$SETUP_ROOT/$TOPIC/install.sh"
}

# Run the installation script for each topic
# shellcheck disable=SC2207,SC2206
topics::install_multiple() {
  local topics_to_install=( $1 )
  local topic

  for topic in "${topics_to_install[@]}"; do
    topics::install_single "$topic"
  done
}
