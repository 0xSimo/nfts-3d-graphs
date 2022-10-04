#!/usr/bin/env bash

function usage {
        echo "Usage: $(basename $0) [-h] -a STR -o PATH" 2>&1
        echo 'Create the graph html and json file'
        echo ''
        echo '   -a FILE   The collections address'
        echo '   -o PATH   The output files root path'
        echo '   -h        Print this message and exits'
        echo ''
        exit 1
}

. $(dirname "$0")/utils.sh
ADDRESS=()
OUTPUT_PATH=""

while [[ "$#" -gt 0 ]]; do case $1 in
  -a) ADDRESS="$2"; shift;;
  -o) OUTPUT_PATH="$2"; shift;;
  -h) usage;;
   *)
    log "Unknown parameter: $1"
    log "try with '$0 -h'"
    exit 1 ;;
esac; shift; done

if [ -z "$ADDRESS" ]; then
    log "Address not provided"
    log "try with '$0 -h'"
    exit 1
fi

if [ -z "$OUTPUT_PATH" ]; then
    log "Output directory not provided"
    log "try with '$0 -h'"
    exit 1
fi

PYVENV_ACTIVATE

log "Creating the 'realtime' dashboard files..."
ARGUMENTS=("$ADDRESS" "$OUTPUT_PATH")

run python3 "$WA_PROJECT_DIR/nft_graph.py" "${ARGUMENTS[@]}"
log "done"

PYVENV_DEACTIVATE
