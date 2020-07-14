#!/usr/bin/env bash

set -e

readonly SOURCE_PLIST='/Library/Preferences/com.lethalaudio.Lethal.plist'

function move_libraries() {
  local -r target_directory="$1"
  defaults read "$SOURCE_PLIST" | grep "=     {" | while read -r line; do
    # shellcheck disable=SC2001
    library_name=$(echo "$line" | sed 's/.*"\(.*\)".*/\1/g')
    installation_dir="$target_directory/$library_name"
    echo "Processing library $library_name..."
    sudo defaults write "$SOURCE_PLIST" "$library_name" -dict-add \
      InstallDir "$installation_dir" \
      IconFile "/$target_directory/$library_name/icon.png"
    echo "Re-pointed to $installation_dir"
  done
}

move_libraries "$@"
