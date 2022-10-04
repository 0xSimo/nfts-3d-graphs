#!/usr/bin/env bash
readonly SELF="$0"
readonly SELF_NAME="${SELF##*/}"
readonly THIS_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

rm -fr "$THIS_DIR/.idea"
rm -fr "$THIS_DIR/venv"
