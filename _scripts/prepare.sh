#!/bin/bash

set -eu
set -o pipefail

# このスクリプト本体があるディレクトリの絶対パス
SCRIPT_DIR=$(cd $(dirname ${0}) && pwd)
# リポジトリのルートディレクトリパス
REPO_DIR=$(cd "${SCRIPT_DIR}/.." && pwd)
# 一時ファイル用のディレクトリパス
TMP_DIR="${REPO_DIR}/tmp"

## REQ_YML
if [ -e "${REPO_DIR}/../req.yml" ]; then
    REQ_YML="${REPO_DIR}/../req.yml"
else
    REQ_YML="${REPO_DIR}/_scripts/req.yml"
fi

## コマンドライン引数の受け取り
if [ -z $1 ]; then
    echo "usage: bash prepare.sh {VENV_DIR}"
    exit -1
fi
VENV_DIR=$1

## ディレクトリが既に存在すればこのスクリプトは終了
if [ -d ${VENV_DIR} ]; then
    exit 0
fi

## anaconda インストールスクリプト
# TODO: Linux か macOS で分岐させたい
ANACONDA_SH="Anaconda3-2021.11-Linux-x86_64.sh"

## インストール
bash -eu <<EOF
function catch() {
    rm -Rf ${VENV_DIR}
    rm "${TMP_DIR}/${ANACONDA_SH}"
}
trap catch ERR

echo  "download to '${TMP_DIR}/Anaconda3-2021.11-Linux-x86_64.sh'"
echo

curl -o "${TMP_DIR}/${ANACONDA_SH}" -OL "https://repo.anaconda.com/archive/${ANACONDA_SH}"

bash "${TMP_DIR}/${ANACONDA_SH}" -sbf -p ${VENV_DIR}

. "${VENV_DIR}/etc/profile.d/conda.sh"
export PATH="${VENV_DIR}/bin:$PATH"

conda install pyyaml
conda env create --file "${REQ_YML}"
EOF
