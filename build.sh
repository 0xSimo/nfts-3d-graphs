#!/usr/bin/env bash
readonly SELF="$0"
readonly SELF_NAME="${SELF##*/}"
readonly THIS_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
readonly CURR_DIR="$( pwd )"

cd "$THIS_DIR"

# install python3 environment and dependencies
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt
deactivate

cd "$CURR_DIR"
