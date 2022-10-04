#!/usr/bin/env bash
readonly SELF="$0"
readonly SELF_NAME="${SELF##*/}"

readonly THIS_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

readonly WA_PROJECT_DIR="${THIS_DIR}/../"
readonly WA_SCRIPS_DIR="${THIS_DIR}"
readonly PYVENV_DIR="${WA_PROJECT_DIR}/venv"

# load env variables
set -a
. "${WA_PROJECT_DIR}/.env"
set +a

function log() {
  echo "[$SELF_NAME] ($(date +'%Y.%m.%d %H:%M:%S')) :: $1" >&2
}

function PYVENV_ACTIVATE() {
    source "${PYVENV_DIR}/bin/activate"
}

function PYVENV_DEACTIVATE() {
    deactivate
}

function run() {
    local rc
    echo "[$SELF_NAME] ($(date +'%Y.%m.%d %H:%M:%S')) >> $*"
    "$@"
    rc="$?"
    if [ "$rc" != 0 ]; then
        echo "Command failed (RC=$rc): $*" 1>&2
        exit $rc
    fi
}

function join { local IFS="$1"; shift; echo "$*"; }

