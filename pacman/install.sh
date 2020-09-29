#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
  && source "../.lib/initializer.sh"

# --------------------------------------------------------------------------------------------------

os::verify "linux" \
  || return 1

commands::verify "pacman" \
  || return 1

# --------------------------------------------------------------------------------------------------

declare -r main_packages=(
  "curl"
  "base-devel"
  "git"
  "zsh"

  "xorg-server"
  "xorg-xinit"
  "xorg-xrandr"
  "xorg-xdpyinfo"
  "xorg-xrdb"
  "xorg-xinput"
  "xorg-xset"
  "xorg-xwininfo"

  "i3-gaps"
  "dmenu"
  "i3status"
  "rxvt-unicode"
  "arandr"
  "neovim"
  "python-neovim"
  "vim"
  "ranger"
  "zsh"
  "tmux"
  "neofetch"
  "httpie"
  "wget"
  "htop"
  "the_silver_searcher"
  "tig"
  "network-manager-applet"
  "noto-fonts"
  "noto-fonts-emoji"
  "feh"
  "rofi"
  "picom"
  "openssh"
  "jq"
  "scrot"
  "xclip"
  "fzf"
  "neofetch"
  "python-pywal"
  "mpd"
  "mpc"
  "mpv"
  "man-db"
  "ntfs-3g"
  "pulseaudio-alsa"
  "pulsemixer"
  "pamixer"
  "unclutter"
  "zathura"
  "youtube-dl"
  "pyenv"
)

declare -r aur_packages=(
  "xcursor-chromeos"
  "google-chrome"
  "ttf-iosevka"
  "diff-so-fancy"
  "fnm"
)

# Append extras if exist
[[ -n "$PACMAN_EXTRAS" ]] \
  && main_packages+=( "${PACMAN_EXTRAS[@]}" )

[[ -n "$AUR_EXTRAS" ]] \
  && aur_packages+=( "${AUR_EXTRAS[@]}" )

# --------------------------------------------------------------------------------------------------

__update_configs() {
  # Taken from https://github.com/lukesmithxyz/larbs/blob/master/larbs.sh, cuz why not
  commands::execute 'grep -q "^Color" /etc/pacman.conf || sudo sed -i "s/^#Color$/Color/" /etc/pacman.conf' \
    "Set Color"
}

__update_keyring() {
  commands::execute "sudo pacman --noconfirm -Sy archlinux-keyring" \
    "Refreshing Arch Keyring"
}

__install_yay() {
  if commands::exists 'yay'; then
    output::success "yay is already installed"
    return
  fi

  local tmpdir="$(mktemp -d)"

  commands::execute "git clone https://aur.archlinux.org/yay.git $tmpdir" \
    "Cloning yay from AUR"

  pushd "$tmpdir" &> /dev/null \
    || return 1

  commands::execute "sudo makepkg --noconfirm -si" \
    "Installing yay"

  popd &> /dev/null \
    || return 1
}

# --------------------------------------------------------------------------------------------------

main() {
  output::info "Update configs"
  __update_configs

  output::info "Update keyring"
  __update_keyring

  output::info "Install yay"
  __install_yay

  output::info "Install packages from main"

  for pkg in "${main_packages[@]}"; do
    pacman::install "$pkg"
  done

  output::info "Install packages from AUR"

  for pkg in "${aur_packages[@]}"; do
    yay::install "$pkg"
  done
}

main "$@"
