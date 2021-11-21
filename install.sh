#!/bin/bash

set -eu

## Setting
REPO_DIR="$(cd $(dirname ${0}) && pwd)"
SCRIPT_DIR="$(cd ${REPO_DIR}/_scripts && pwd)"
CMD_DIR="$(cd ${REPO_DIR}/cmds && pwd)"

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

# ## Create symbolic link
# for COMMAND in ${COMMAND_LIST}; do
#     ln -sf "${SCRIPT_DIR}/wrapper.sh" "${CMD_DIR}/${COMMAND}"
# done
