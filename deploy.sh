#!/bin/bash
set -e

DEPLOY_LOG="/tmp/deploy_personal_page_$(date +%s).log"
PAGE_REPO="/home/worker/personal-page"

cd "$PAGE_REPO" || exit 1

echo "$(date): Pull latest changes" >> $DEPLOY_LOG
git pull origin master

echo "$(date): Syncing to webroot" >> $DEPLOY_LOG
rsync -a --delete --exclude=".git" "${PAGE_REPO}/" /var/www/personal/
echo "$(date): Synced!" >> $DEPLOY_LOG
