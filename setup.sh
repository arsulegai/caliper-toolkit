#!/bin/bash

# For logging
. scripts/logger.sh

# Global Variables
REPO_FOLDER="temp"
FABRIC_VERSION="1.4.0"
INSTALL_PRE_REQ="false"

# Install pre-requisites
function install_pre_req() {
    # Install npm
    # Install npx
    # TODO
}

# Function that clones the repository into a specified folder
function clone() {
    local current_directory=`pwd`
    mkdir ${REPO_FOLDER}
    cd ${REPO_FOLDER}
    git clone https://github.com/hyperledger/caliper-benchmarks.git
    cd ${current_directory}
}

function initialize() {
    local current_directory=`pwd`
    cd ${REPO_FOLDER}"/caliper-benchmarks"
    npm init -y
    npm install --only=prod @hyperledger/caliper-cli@0.3.0
    npx caliper bind --caliper-bind-sut fabric:${FABRIC_VERSION}
    cd ${current_directory}
}

function copy_artifacts() {
    # TODO
}

# Helper utility
function usage() {
    print "Usage: $0 [OPTIONS]"
    print "Where [OPTIONS] are as follows"
    print "      -v: Hyperledger Fabric Version (Default 1.4.0)"
    print "      -h: Help menu."
}

while getopts "v:ih" opt; do
    case ${opt} in
        v) FABRIC_VERSION=${OPTARG} ;;
        i) INSTALL_PRE_REQ="true" ;;
	h) usage
	   exit 0 ;;
	\?) error "Unknown Input Option: " ${opt}
	   exit -1 ;;
    esac
done


# Setup the caliper on this machine
function main() {
    if [[ "${INSTALL_PRE_REQ}" == "true" ]]; then
        install_pre_req
    fi
    clone
    copy_artifacts
    initialize
}

main
