#!/bin/sh

#
# Bambu Studio - Enable All Build Plates
#
# removes build plate restrictions from printers in Bambu Studio
#
# What does this do?
# 1) checks which OS it is running under (macOS, Linux, or WSL/Windows)
# 2) removes build plate restrictions from printer profiles
#
# Example: Cool Plate wasn't selectable on several printers.
# This scripts removes that restriction.
# 
# The script will check for common locations and processes json files within.
#
# Tested with sh/bash/zsh on macOS, Linux, and WSL.
# I've tried to make this POSIX compliant for GNU and BSD.
#
#
# 2026-08-18
# * first test
# 
# Nicholas Caito
# https://xenomorph.net
#


# restrictive lines to delete
LINES_TO_DELETE='"image_bed_type"
"bottom_texture_end_name"
"not_support_bed_type"'


# ----------


# determine OS and set parameters

case $(uname | tr '[:upper:]' '[:lower:]') in
 linux*)
  export OS="Linux"

  # is this wsl?
  if grep -qi microsoft /proc/version; then
    export OS="Windows"
    # get windows path
    export WIN_HOME=$(wslpath "$(powershell.exe -NoProfile -NonInteractive -Command "Write-Output \$Env:UserProfile" | tr -d '\r')")
    export JSON_LOC_WIN="$WIN_HOME/AppData/Roaming/BambuStudio/system/BBL/machine"
  fi
  ;;
 darwin*)
  export OS="macOS"
  ;;
 *)
  # export OS="Unknown"
  printf "\nUnknown OS detected!\n\n"
  exit 1
  ;;
esac


# paths: (use $HOME instead of "~")
# macOS: $HOME/Library/Application Support/BambuStudio/system/BBL/machine
# Linux/AppImage: $HOME/.config/BambuStudio/system/BBL/machine
# Linux/Flatpak: $HOME/.var/app/com.bambulab.BambuStudio/config/BambuStudio/system/BBL/machine
# Linux/WSL: %AppData%\BambuStudio\system\BBL\machine


# function to loop through json files
file_loop(){

for file in "$JSON_LOC"/*.json; do

  # make sure things exist
  [ -f "$file" ] || continue;

  CHANGED=false

  # check each line in LINES_TO_DELETE
  printf '%s\n' "$LINES_TO_DELETE" | while IFS= read -r line; do

    # only touch files that have the lines
    if grep -q "$line" "$file"; then

      # use printf to pass the pattern to sed
      pattern=$(printf '%s' "$line")

      # delete if the line matches the pattern
      if [ $OS = "macOS" ]; then
        sed -i "" "/${pattern}/d" "$file"
      else
        sed -i "/${pattern}/d" "$file"
      fi

      CHANGED=true

    fi

  done

  # report if modified
  if [ "$CHANGED" = true ]; then
    echo "File updated: $file"
  fi

done

printf "\n"

}

printf "\nBambu Studio - Enable All Build Plates\n\n"

export JSON_LOC_MAC="$HOME/Library/Application Support/BambuStudio/system/BBL/machine"
export JSON_LOC_APP="$HOME/.config/BambuStudio/system/BBL/machine"
export JSON_LOC_PAK="$HOME/.var/app/com.bambulab.BambuStudio/config/BambuStudio/system/BBL/machine"


if [ -e "$JSON_LOC_MAC" ]; then
  printf "Script for $OS\n"
  export JSON_LOC=$JSON_LOC_MAC
  printf "Checking path: $JSON_LOC\n\n"
  file_loop
fi

if [ -e "$JSON_LOC_APP" ]; then
  printf "Script for $OS\n"
  export JSON_LOC=$JSON_LOC_APP
  printf "Checking path: $JSON_LOC\n\n"
  file_loop
fi

if [ -e "$JSON_LOC_PAK" ]; then
  printf "Script for $OS\n"
  export JSON_LOC=$JSON_LOC_PAK
  printf "Checking path: $JSON_LOC\n\n"
  file_loop
fi

if [ $OS = "Windows" ]; then
  if [ -e "$JSON_LOC_WIN" ]; then
    printf "Script for $OS\n"
    export JSON_LOC=$JSON_LOC_WIN
    printf "Checking path: $JSON_LOC\n\n"
    file_loop
  fi
fi


# EoF
