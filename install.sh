#!/bin/bash

set -eu

## Setting
REPO_DIR="$(cd $(dirname ${0}) && pwd)"
SCRIPT_DIR="$(cd ${REPO_DIR}/_scripts && pwd)"

## コマンドリスト
COMMAND_LIST=$(cat << EOF
python
python3
conda
pip
ansible
EOF
)

## Install conda and python
bash "${SCRIPT_DIR}/wrapper.sh"
