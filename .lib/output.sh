#!/usr/bin/env bash

# --------------------------------------------------------------------------------------------------

output::green() {
  printf "\\e[0;32m%b\\e[0m" "$1"
}

output::blue() {
  printf "\\e[0;34m%b\\e[0m" "$1"
}

output::purple() {
  printf "\\e[0;35m%b\\e[0m" "$1"
}

output::cyan() {
  printf "\\e[36m%b\\e[0m" "$1"
}

output::red() {
  printf "\\e[0;31m%b\\e[0m" "$1"
}

output::yellow() {
  printf "\\e[0;33m%b\\e[0m" "$1"
}

output::darkgrey() {
  printf "\\e[0;90m%b\\e[0m" "$1"
}

output::white() {
  printf "\\e[1;37m%b\\e[0m" "$1"
}

# --------------------------------------------------------------------------------------------------

output::title() {
  output::white "\\n$(tput bold)  -  $1$(tput sgr0)\\n"
}

output::info() {
  output::cyan "\\n     $1\\n\\n"
}

output::error() {
  # shellcheck disable=SC2059
  output::red "     ✘" && printf "  $1\\n"
}

output::question() {
  # shellcheck disable=SC2059
  output::yellow "     ?" && printf "  $1"
}

output::status() {
  # shellcheck disable=SC2059
  output::yellow "     ℹ" && printf "  $1\\n"
}

output::success() {
  # shellcheck disable=SC2059
  output::green "     ●" && printf "  $1\\n"
}

# --------------------------------------------------------------------------------------------------

# Print the message based the last exit
output::result() {
  [[ "$1" -eq 0 ]] \
    && output::success "$2" \
    || output::error "$2 $(output::purple "(exited with $1)")"

  return "$1"
}

# Print a divider (newline)
output::divider() {
  printf "\\n"
}

output::error_stream() {
  while read -r line; do
    echo "↳ ERROR: $line"
  done
}

# Print welcome message
output::welcome_message() {

  tput clear

  # shellcheck disable=SC1117,SC2016,SC1004
  output::blue '
                                     ._
                                   ,(  `-.
                                 ,'\'': `.   `.
                               ,` *   `-.   \
                             ,'\''  ` :+  = `.  `.
                           ,~  (o):  .,   `.  `.
                         ,'\''  ; :   ,(__) x;\`.  ;
                       ,'\''  :'\''  itz  ;  ; ; _,-'\''
                     .'\''O ; = _'\'' C ; ;'\''_,_ ;
                   ,;  _;   ` : ;'\''_,-'\''   i'\''
                 ,` `;(_)  0 ; '\'','\''       :
               .'\'';6     ; '\'' ,-'\''~
             ,'\'' Q  ,& ;'\'',-.'\''
           ,( :` ; _,-'\''~  ;
         ,~.`c _'\'','\''                  __
       .'\'';^_,-'\'' ~         ________  / /___  ______
     ,'\''_;-'\'''\''             / ___/ _ \/ __/ / / / __ \
    ,,~               _ (__  )  __/ /_/ /_/ / /_/ /
    i'\''               (_)____/\___/\__/\__,_/ .___/
    :                                     /_/

     https://github.com/yardnsm/.setup/

'

  output::cyan "     $(tput bold)Base dir:$(tput sgr0) \\t ~${CONFIG_ROOT#$HOME} \\n"
  output::cyan "     $(tput bold) Profile:$(tput sgr0) \\t ${PROFILE} \\n"
  output::cyan "     $(tput bold)  Topics:$(tput sgr0) \\t ${TOPICS[*]} \\n\\n"
}

output::help() {
  cat <<EOF

  yardnsm's setup scripts

  Usage

    ./install.sh <profile>
    ./install.sh -t <topic>

  Options:

    -t      Run a single topic

  Available profiles:

    $(find "$SETUP_ROOT/.profiles" ! -name ".profiles" -exec basename {} \; | column)
EOF
}
