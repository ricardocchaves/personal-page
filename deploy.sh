#!/bin/bash
set -e

PAGE_REPO="/home/worker/personal-page"

cd "$PAGE_REPO" || exit 1

# Pull latest changes
git pull origin master

# Sync to web root
rsync -a --delete --exclude=".git" "${PAGE_REPO}/" /var/www/personal/
