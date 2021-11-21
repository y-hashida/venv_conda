#!/bin/bash

set -eu
set -o pipefail

## このスクリプト本体があるディレクトリの絶対パス
#  - ${BASH_SOURCE:-$0} については以下のURLを参考
#  - 参考: https://qiita.com/tkygtr6/items/fee79f710c55e3649ec0
__SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}) && pwd)
# リポジトリのルートディレクトリパス (スクリプトと同じ)
__REPO_DIR="${__SCRIPT_DIR}"

## REQ_YML
if [ -e "${__REPO_DIR}/../req.yml" ]; then
    __REQ_YML="${__REPO_DIR}/../req.yml"
else
    __REQ_YML="${__REPO_DIR}/_scripts/req.yml"
fi

## venv ディレクトリ名
__REQUIREMENT_HASH="$(cat "${__REQ_YML}" | openssl dgst -md5 | sed 's/^.* //')"
__VENV_DIR="$(cd ${__REPO_DIR}/_venvs && pwd)/${__REQUIREMENT_HASH}"

## anaconda のアクティベートとパス追加
. "${__VENV_DIR}/etc/profile.d/conda.sh"
export PATH="${__VENV_DIR}/bin:$PATH"

## 変数を unset
unset __REPO_DIR
unset __SCRIPT_DIR
unset __REQ_YML
unset __REQUIREMENT_HASH
unset __VENV_DIR
