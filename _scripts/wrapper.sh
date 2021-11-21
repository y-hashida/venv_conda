#!/bin/bash

set -eu
set -o pipefail

## シンボリックリンクのリンク先の絶対パスを知る関数
# Usage:
#   readlink_f <filename>
#
# 参考: https://qiita.com/edvakf@github/items/b8400f7dfe9210aadddd
function readlink_f() {
    local TARGET_FILE=$1
    cd $(dirname ${TARGET_FILE})
    TARGET_FILE=$(basename ${TARGET_FILE})

    # Iterate down a (possible) chain of symlinks
    while [ -L "${TARGET_FILE}" ]
    do
        TARGET_FILE=$(readlink ${TARGET_FILE})
        cd $(dirname ${TARGET_FILE})
        TARGET_FILE=$(basename ${TARGET_FILE})
    done

    # Compute the canonicalized name by finding the physical path
    # for the directory we're in and appending the target file.
    local PHYS_DIR=$(pwd -P)
    echo ${PHYS_DIR}/${TARGET_FILE}
}

## 以下メインの処理
SCRIPT_PATH=$(readlink_f $0)
SCRIPT_DIR=$(cd $(dirname ${SCRIPT_PATH}); pwd)

## REQ_YML
if [ -e "${SCRIPT_DIR}/../../req.yml" ]; then
    REQ_YML="${SCRIPT_DIR}/../../req.yml"
else
    REQ_YML=${SCRIPT_DIR}/req.yml
fi

## venv ディレクトリを用意
REQUIREMENT_HASH="$(cat "${REQ_YML}" | openssl dgst -md5 | sed 's/^.* //')"
VENV_DIR="$(cd ${SCRIPT_DIR}/../_venvs; pwd)/${REQUIREMENT_HASH}"

## anaconda のインストール
bash ${SCRIPT_DIR}/prepare.sh ${VENV_DIR}

## anaconda のアクティベート
. "${VENV_DIR}/etc/profile.d/conda.sh"
export PATH="${VENV_DIR}/bin:$PATH"


## req.yml でインストールしたものをアクティベートする
# 1. まずは req.yml の name を取得
CONDA_ENV_NAME=$("${VENV_DIR}/bin/python3" - "${REQ_YML}" << 'EOS'
import sys, yaml
req_yml: str = sys.argv[1]
with open(req_yml, 'r') as file:
    req = yaml.safe_load(file)
    print(req['name'])
EOS
)
# 2. 次に, req.yml をアクティベート
conda activate "${CONDA_ENV_NAME}"

## スクリプト名とコマンドライン引数を取得
WRAPPER_CMD_NAME="$(basename ${0})"
ARGS=("$@")

## スクリプト名 が wrapper.sh の時はここで終了.
if [[ "${WRAPPER_CMD_NAME}" == "wrapper.sh" ]]; then
    exit 0
fi

## シンボリック名に合わせて実行このスクリプトを実行
"${VENV_DIR}/bin/${WRAPPER_CMD_NAME}" "${ARGS[@]}"
