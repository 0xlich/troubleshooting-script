#!/usr/bin/env bash

# Declaring color palettes

RESET="\e[0m"
LIGHT_RED="\e[1;91m" # This will be used for bad configuration
LIGHT_GREEN="\e[1;92m" # This will be used for correct configuration
LIGHT_YELLOW="\e[1;93m"
LIGHT_BLUE="\e[1;94m"
LIGHT_MAGENTA="\e[1;95m"
LIGHT_CYAN="\e[1;96m"

# Search for indexing through directories and files
searching () {
  local result=''
  if [ "$#" -eq 1 ]; then
    result=$(find / -type f -name $1 2>/dev/null)
  elif [ "$#" -eq 2 ]; then
    result=$(find $2 -type -f -name $1 2>/dev/null)
  elif [ "$#" -eq 3 ]; then
    result=$(find $2 -type $3 -name $1 2>/dev/null)
  else
    echo "Error parsing too many variables."
  fi
  echo $result
}

verify_path () {
  local current_path=$(echo $1 | sed 's/\/pocket//g')
  echo $(echo $PATH | grep $current_path)
}

# Running verification
if [[ $EUID -ne 0 ]]; then
  echo -e $LIGHT_RED"This script must be run as root for some checks to take place"$RESET
  exit 1
fi

# Finding pocket binary in path
BINARY_PATH=$(searching 'pocket')
if [ -z $BINARY_PATH ]; then
  echo -e  $LIGHT_RED"Pocket binary not found. Is it installed?\n"$RESET
  exit 1
else
  echo -e $LIGHT_GREEN"Pocket binary found at: "$RESET$BINARY_PATH
  verified=$(verify_path $BINARY_PATH)
  if [[ -z "$verified" ]]; then
    echo -e $LIGHT_YELLOW"Pocket binary NOT in PATH, it's in:"$RESET$BINARY_PATH
  fi
fi

# Searching for .pocket configuration directory
CONFIGURATION_PATH=$(searching '.pocket' '/' 'd')
if [[ -z $CONFIGURATION_PATH ]]; then
  echo -e  $LIGHT_RED"Pocket directory not found. Is it configured?\n"$RESET
  exit 1
else
  echo -e $LIGHT_GREEN"Pocket directory found at: "$RESET$CONFIGURATION_PATH
fi
