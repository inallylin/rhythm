#!/usr/bin/env sh
# 當發生錯誤時終止腳本運行
set -e
yarn build --mode github
cd dist
git init
git add -A
git commit -m 'deploy'
git push -f git@github.com:inallylin/rhythm.git main:gh-pages
cd -