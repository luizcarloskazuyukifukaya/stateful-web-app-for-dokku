#!/bin/bash

# Configuration
APP_NAME="daily-activity-log"
DB_NAME="activity-db"
HOST_PORT=8082
CONTAINER_PORT=5000
GITHUB_USER="luizcarloskazuyukifukaya"

echo "🚀 Starting deployment for $APP_NAME..."

# 1. Create App
echo "Creating Dokku app..."
sudo dokku apps:create $APP_NAME || echo "App already exists"

# 2. Port Mapping
echo "Setting port mapping (Host $HOST_PORT -> Container $CONTAINER_PORT)..."
sudo dokku ports:set $APP_NAME http:$HOST_PORT:$CONTAINER_PORT

# 3. Database Setup (using dokku-postgres)
echo "Setting up PostgreSQL..."
sudo dokku postgres:create $DB_NAME || echo "DB already exists"
sudo dokku postgres:link $DB_NAME $APP_NAME || echo "DB already linked"

# 4. Resource Limits
echo "Setting memory limit to 512MB..."
sudo dokku resource:limit $APP_NAME --memory 512m || sudo dokku resource:set $APP_NAME --memory 512m

# 5. Git & Deployment
echo "Committing and pushing code..."

# Ensure local git config
git config user.email "luizcarloskazuyukifukaya@gmail.com"

git add .
git commit -m "Secure deployment script and update configuration" || echo "Nothing to commit"

# Push to Dokku
echo "Pushing to Dokku..."
if ! git remote | grep -q "dokku"; then
    git remote add dokku dokku@localhost:$APP_NAME
fi
git push dokku master

# Push to GitHub
echo "Pushing to GitHub..."
if [ -n "$GITHUB_PAT" ]; then
    git push https://$GITHUB_USER:$GITHUB_PAT@github.com/$GITHUB_USER/stateful-web-app-for-dokku.git master
else
    echo "⚠️  GITHUB_PAT environment variable not set. Skipping GitHub push."
    echo "To push, use: GITHUB_PAT=your_token ./deploy-to-dokku.sh"
fi

echo "✅ Deployment complete!"
echo "Access your app at:"
echo "Internal: http://$(hostname -I | awk '{print $1}'):$HOST_PORT"
echo "Public:   https://web3.luizcarloskazuyukifukaya.org"
