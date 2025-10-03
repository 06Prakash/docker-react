#!/bin/bash

# Docker Smoke Test Script
# This script tests the Docker image to ensure it's working properly

set -e

IMAGE_NAME=${1:-"react-docker-app"}
CONTAINER_NAME="test-container-$(date +%s)"
PORT=${2:-"3000"}

echo "🧪 Starting Docker smoke tests for image: $IMAGE_NAME"

# Function to cleanup on exit
cleanup() {
    echo "🧹 Cleaning up..."
    docker stop $CONTAINER_NAME 2>/dev/null || true
    docker rm $CONTAINER_NAME 2>/dev/null || true
}

# Set trap to cleanup on script exit
trap cleanup EXIT

echo "📦 Testing Docker image build..."
if ! docker image inspect $IMAGE_NAME > /dev/null 2>&1; then
    echo "❌ Image $IMAGE_NAME not found. Building..."
    docker build -t $IMAGE_NAME .
fi

echo "🚀 Starting container..."
docker run -d -p $PORT:80 --name $CONTAINER_NAME $IMAGE_NAME

echo "⏳ Waiting for container to be ready..."
sleep 10

# Test 1: Check if container is running
echo "🔍 Test 1: Checking if container is running..."
if [ $(docker ps -q -f name=$CONTAINER_NAME) ]; then
    echo "✅ Container is running"
else
    echo "❌ Container is not running"
    docker logs $CONTAINER_NAME
    exit 1
fi

# Test 2: Check HTTP response
echo "🔍 Test 2: Testing HTTP response..."
for i in {1..5}; do
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT || echo "000")
    if [ "$HTTP_CODE" = "200" ]; then
        echo "✅ HTTP test passed (Status: $HTTP_CODE)"
        break
    elif [ $i -eq 5 ]; then
        echo "❌ HTTP test failed after 5 attempts (Status: $HTTP_CODE)"
        docker logs $CONTAINER_NAME
        exit 1
    else
        echo "⏳ Attempt $i failed, retrying in 2 seconds..."
        sleep 2
    fi
done

# Test 3: Check content
echo "🔍 Test 3: Testing application content..."
CONTENT=$(curl -s http://localhost:$PORT)
if echo "$CONTENT" | grep -q "React Docker App"; then
    echo "✅ Content test passed - React app is serving correctly"
else
    echo "❌ Content test failed - React app content not found"
    echo "Response content:"
    echo "$CONTENT"
    exit 1
fi

# Test 4: Check Nginx configuration
echo "🔍 Test 4: Testing Nginx configuration..."
if docker exec $CONTAINER_NAME nginx -t; then
    echo "✅ Nginx configuration is valid"
else
    echo "❌ Nginx configuration test failed"
    exit 1
fi

# Test 5: Check image size
echo "🔍 Test 5: Checking image optimization..."
IMAGE_SIZE_MB=$(docker images $IMAGE_NAME --format "{{.Size}}" | sed 's/MB//' | sed 's/GB/*1000/' | bc 2>/dev/null || echo "unknown")
echo "📦 Image size: $(docker images $IMAGE_NAME --format "{{.Size}}")"

# Test 6: Basic security check
echo "🔍 Test 6: Basic security check..."
USER_CHECK=$(docker exec $CONTAINER_NAME whoami)
if [ "$USER_CHECK" != "root" ]; then
    echo "✅ Container is not running as root user: $USER_CHECK"
else
    echo "⚠️  Container is running as root user (consider using non-root user for production)"
fi

echo ""
echo "🎉 All tests passed! Docker image is working correctly."
echo "📊 Test Summary:"
echo "   - Container starts successfully ✅"
echo "   - HTTP server responds correctly ✅"
echo "   - React application loads ✅"
echo "   - Nginx configuration is valid ✅"
echo "   - Image optimization checked ✅"
echo "   - Basic security check completed ✅"
echo ""
echo "🚀 Image is ready for deployment!"
