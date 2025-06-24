#!/bin/bash

set -e

# Configuration
PROJECT_ID="m06308803865"  
BACKEND_IMAGE="gcr.io/$PROJECT_ID/task-manager-backend:latest"
FRONTEND_IMAGE="gcr.io/$PROJECT_ID/task-manager-frontend:latest"

echo "🔁 Stopping existing containers (if any)..."
docker stop backend frontend 2>/dev/null || true
docker rm backend frontend 2>/dev/null || true

echo "📥 Pulling the latest Docker images..."
docker pull "$BACKEND_IMAGE"
docker pull "$FRONTEND_IMAGE"

echo "🚀 Starting backend container (Flask on port 3000)..."
docker run -d \
  --name backend \
  -p 3000:3000 \
  "$BACKEND_IMAGE"

echo "🚀 Starting frontend container (React + NGINX on port 80)..."
docker run -d \
  --name frontend \
  -p 80:80 \
  "$FRONTEND_IMAGE"

echo "✅ Deployment successful!"
echo "🌍 Frontend available at: http://$(curl -s ifconfig.me)"
echo "🔙 Backend API available at: http://$(curl -s ifconfig.me):3000"
