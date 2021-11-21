#! /bin/bash -eu

## リポジトリのルートディレクトリ
REPO_DIR="$(cd $(dirname ${0}); pwd)"

## _venvs の _venvs の中身を削除
rm -rf "${REPO_DIR}/"{_venvs,tmp,cmds}
mkdir -p "${REPO_DIR}/"{_venvs,tmp,cmds}
touch "${REPO_DIR}/"{_venvs,tmp,cmds}"/.gitkeep"
