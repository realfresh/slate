#!/usr/bin/env bash

git commit -a -m $1
git push
bash ./deploy.sh