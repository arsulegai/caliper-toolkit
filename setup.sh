#!/bin/bash

# For logging
. scripts/logger.sh

# Global Variables
REPO_FOLDER="temp"
FABRIC_VERSION="1.4.0"
INSTALL_PRE_REQ="false"
CLEANUP_ENV="false"
CALIPER_FILES=""
CALIPER_VERSION=0.3.0

# Install pre-requisites
function install_pre_req() {
    # Install npm
    # Install npx
    # TODO
    debug "No pre-requisites defined for installation"
}

# Function that clones the repository into a specified folder
function clone() {
    local current_directory=`pwd`
    mkdir ${REPO_FOLDER}
    cd ${REPO_FOLDER}
    mkdir -p "caliper-benchmarks"
    debug "Created the directory ${REPO_FOLDER}/caliper-benchmarks"
    # git clone https://github.com/hyperledger/caliper-benchmarks.git
    cd ${current_directory}
}

function initialize() {
    local current_directory=`pwd`
    cd ${REPO_FOLDER}"/caliper-benchmarks"
    npm init -y
    npm install --only=prod @hyperledger/caliper-cli@${CALIPER_VERSION}
    npx caliper bind --caliper-bind-sut fabric:${FABRIC_VERSION}
    cd ${current_directory}
}

function copy_artifacts() {
    if [[ "${CALIPER_FILES}" != "" ]]; then
        if [[ ! -d "${CALIPER_FILES}" ]]; then
            error "Invalid artefacts"
	    exit -1
        fi
        local caliper_folder="${REPO_FOLDER}/caliper-benchmarks"
	mkdir -p "${caliper_folder}/src/"
        cp -r "${CALIPER_FILES}/chaincode" ${caliper_folder}"/src/"
        cp -r "${CALIPER_FILES}/caliper" "${CALIPER_FILES}/workloads" ${caliper_folder}
        debug "Copied the artefacts"
    fi
}

function run() {
    local current_dir=`pwd`
    cd ${REPO_FOLDER}"/caliper-benchmarks"
    npx caliper launch master --caliper-workspace ./ --caliper-benchconfig caliper/config.yaml --caliper-networkconfig caliper/network.yaml
    cd ${current_dir}
}

# Helper utility
function usage() {
    print "Usage: $0 [OPTIONS]"
    print "Where [OPTIONS] are as follows"
    print "      -i: Install pre-requisites"
    print "      -c: Cleanup environment"
    print "      -f: Caliper configuration files"
    print "      -v: Hyperledger Fabric Version (Default 1.4.0)"
    print "      -r: Run only"
    print "      -h: Help menu."
}

while getopts "f:v:icrh" opt; do
    case ${opt} in
        v) FABRIC_VERSION=${OPTARG} ;;
        i) INSTALL_PRE_REQ="true" ;;
	c) CLEANUP_ENV="true" ;;
	f) CALIPER_FILES=${OPTARG} ;;
	r) run
           exit 0 ;;
	h) usage
	   exit 0 ;;
	\?) error "Unknown Input Option: " ${opt}
	   exit -1 ;;
    esac
done


# Setup the caliper on this machine
function main() {
    if [[ "${CLEANUP_ENV}" == "true" ]]; then
        rm -rf "${REPO_FOLDER}"
	debug "Cleaned up the working directory"
    else
        warn "Earlier installation exists. Using the same setup."
    fi
    if [[ "${INSTALL_PRE_REQ}" == "true" ]]; then
        install_pre_req
    fi
    clone
    copy_artifacts
    initialize
    run
}

main
