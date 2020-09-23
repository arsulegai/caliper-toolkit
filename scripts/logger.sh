#!/bin/bash

# For pretty printing
DARK_GRAY='\033[1;30m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CLEAN='\033[0m'

function print() {
  echo -e "$@"
}

function debug() {
  echo -e "${DARK_GRAY}[DEBUG] $(print "$@") ${CLEAN}"
}

function warn() {
  echo -e "${YELLOW}[WARN] $(print "$@") ${CLEAN}"
}

function error() {
  echo -e "${RED}[ERROR] $(print "$@") ${CLEAN}"
}
