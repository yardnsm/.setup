#!/usr/bin/env bash

# --------------------------------------------------------------------------------------------------

declare -r applications=(
  'iterm2'
  'sequel-pro'
  'wireshark'
  'hex-fiend'

  'android-studio'
  'visual-studio-code'

  '1password'
  '1password-cli'

  'oracle-jdk'
  'android-platform-tools'

  'google-chrome'
  'google-chrome-canary'
  'firefox-developer-edition'

  'keybase'
  'ticktick'
  'keepingyouawake'
  'scroll-reverser'
  'spectacle'
  'transmission'
  'spotify'
  'vlc'
  'discord'
  'tunnelblick'

  'syncthing'
  'google-drive'
)

declare -r applications_x86=(
  'virtualbox'
)

declare -r fonts=(
  'font-hack'
  'font-fira-code'
  'font-source-code-pro'
  'font-ubuntu'
  'font-cousine'
  'font-mononoki'
  'font-iosevka'
  'font-iosevka-nerd-font'

  'font-open-sans'
  'font-open-sans-condensed'
  'font-open-sans-hebrew'
  'font-open-sans-hebrew-condensed'
)

# --------------------------------------------------------------------------------------------------

main() {
  output::info "Install applications"

  for app in "${applications[@]}"; do
    brew::install "$app" '--cask'
  done

  output::info "Install x86 applications"

  for app_x86 in "${applications_x86[@]}"; do
    brew::install "$app_x86" '--cask' 'arch --x86_64 /usr/local/Homebrew/bin/brew'
  done

  output::info "Install fonts"

  for font in "${fonts[@]}"; do
    brew::install "$font" '--cask'
  done
}

main "$@"
