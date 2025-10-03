#!/bin/bash

# Health Check Script
# Simple health check for the React Docker application

URL=${1:-"http://localhost:3000"}
MAX_ATTEMPTS=${2:-5}
WAIT_TIME=${3:-2}

echo "🏥 Health check for: $URL"

for i in $(seq 1 $MAX_ATTEMPTS); do
    echo "Attempt $i/$MAX_ATTEMPTS..."
    
    # Check HTTP status
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL" 2>/dev/null || echo "000")
    
    if [ "$HTTP_STATUS" = "200" ]; then
        echo "✅ Health check passed!"
        echo "🌐 Application is responding correctly at $URL"
        
        # Optional: Check response time
        RESPONSE_TIME=$(curl -s -o /dev/null -w "%{time_total}" "$URL" 2>/dev/null || echo "0")
        echo "⏱️  Response time: ${RESPONSE_TIME}s"
        
        exit 0
    else
        echo "❌ Health check failed (HTTP $HTTP_STATUS)"
        if [ $i -lt $MAX_ATTEMPTS ]; then
            echo "⏳ Waiting ${WAIT_TIME}s before retry..."
            sleep $WAIT_TIME
        fi
    fi
done

echo "💥 Health check failed after $MAX_ATTEMPTS attempts"
exit 1
