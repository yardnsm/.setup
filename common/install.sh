#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
  && source "../.setup/initializer.sh"

# --------------------------------------------------------------------------------------------------

__symlink_all() {
  local readlink_cmd="readlink"

  if [[ "$(os::get_name)" == "macos" ]]; then

    # Use greadlink on the mac
    readlink_cmd="greadlink"
  fi

  local item_src
  local item_dest

  local src_realpath
  local dest_realpath

  # Everything should be relative to .config
  pushd "$CONFIG_ROOT" &> /dev/null \
    || return 1

  for symlink in "${SYMLINKS[@]}"; do

    [[ -z "$symlink" ]] \
      && continue

    item_src="$(echo "$symlink" | awk '{print $1}')"
    item_dest="$(echo "$symlink" | awk '{print $2}')"

    src_realpath="$("${readlink_cmd}" -f "$item_src")"

    if [[ -z "$item_dest" ]]; then

      # Default under $HOME
      dest_realpath="$HOME/$(basename "$item_src")"
    else

      # Relative to $HOME
      dest_realpath="$HOME/$item_dest"
    fi

    if ! [[ -e "$dest_realpath" ]]; then
      commands::execute "ln -sf $src_realpath $dest_realpath" \
        "$src_realpath -> ~${dest_realpath#$HOME}"
    elif [[ "$("${readlink_cmd}" "$dest_realpath")" == "$src_realpath" ]]; then
      output::status "$src_realpath -> ~${dest_realpath#$HOME} (alreay linked)"
    else
      output::error "~${dest_realpath#$HOME} already exists, Skipping."
    fi

  done

  popd &> /dev/null \
    || return 1
}

# --------------------------------------------------------------------------------------------------

main() {
  output::info "Symlinking and shit"
  __symlink_all
}

main "$@"
