#!/usr/bin/env sh

# abort on errors
set -e

# build
yarn build --base=./

# navigate into the build output directory
cd dist

git init
git add .
git commit -am 'deploy'
git branch -M gh-pages

git push -f git@github.com:inallylin/rhythm.git gh-pages

cd -