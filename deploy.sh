#!/bin/bash
set -e

# Ensure site is built
echo "Building site..."
bundle exec jekyll build

# Check if _site exists
if [ ! -d "_site" ]; then
    echo "Error: _site directory not found"
    exit 1
fi

# Deploy
echo "Deploying to production..."
rsync -av --delete _site/ blog:/var/www/yannmoisan.com

echo "Deployment completed at $(date)"
