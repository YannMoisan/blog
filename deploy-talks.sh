#!/bin/bash
set -e

# Deploy
echo "Deploying to production..."
rsync -av --delete www-backup/www/talks.yannmoisan.com/ blog:/var/www/talks.yannmoisan.com

echo "Deployment completed at $(date)"
