#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
  && source "../.lib/initializer.sh"

# --------------------------------------------------------------------------------------------------

os::verify "macos" \
  || return 1

# --------------------------------------------------------------------------------------------------

declare -r formulae=(
  'rbenv'
  'git'
  'subversion'
  'zsh'
  'neovim'
  'tmux'
  'shellcheck'
  'gpg'
  'ansible'
  'fd'
  'zoxide'
  'qmk/qmk/qmk'

  'Schniz/tap/fnm'
  'node'

  'go'

  'python'
  'python3'
  'pyenv'
  'pyenv-pip-migrate'
  'pyenv-virtualenv'
  'poetry'

  'mysql'
  'docker'
  'coreutils'
  'openssl'

  'wget'
  'tig'
  'fzf'
  'httpie'
  'jq'
  'diff-so-fancy'
  'ripgrep'
  'watchman'
  # 'readline'
  # 'syncthing'
  # 'asciinema'
  'neofetch'
  'htop'
  'cowsay'
  'figlet'
  'tree'
  # 'youtube-dl'
  # 'binwalk'
  # 'apktool'
  # 'jadx'
)

declare -r applications=(
  'iterm2'
  'ghostty'
  'sequel-pro'
  'wireshark'
  'hex-fiend'
  # 'burp-suite'
  # 'android-studio'
  'visual-studio-code'
  # '1password'
  # '1password-cli'
  # 'oracle-jdk'
  # 'android-platform-tools'
  'google-chrome'
  # 'google-chrome-canary'
  # 'firefox-developer-edition'
  # 'keybase'
  # 'obsidian'
  # 'ticktick'
  'keepingyouawake'
  'scroll-reverser'
  # 'spectacle'
  # 'transmission'
  'spotify'
  'vlc'
  # 'discord'
  # 'tunnelblick'
  # 'syncthing'
  'google-drive'
  'docker'
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
  'font-heebo'
  'font-open-sans'
  'font-open-sans-condensed'
  'font-open-sans-hebrew'
  'font-open-sans-hebrew-condensed'
)

load_homebrew() {
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

main() {
  load_homebrew

  output::info "Install Homebrew"

  if ! commands::exists 'brew'; then
    printf "\\n" \
      | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
      &> /dev/null
  fi

  output::result $? 'Homebrew'
  load_homebrew

  output::info "Install Taps"

  brew::tap "homebrew/cask-versions"
  brew::tap "homebrew/cask-fonts"
  brew::tap "mongodb/brew"

  output::info "Updating Homebrew"
  commands::execute "brew update"

  output::info "Install Homebrew dependencies"

  for formula in "${formulae[@]}"; do
    brew::install "$formula"
  done

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

  output::info "Cleaning up"
  commands::execute 'brew cleanup' 'brew (cleanup)'
}

main "$@"
