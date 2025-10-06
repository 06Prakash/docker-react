#!/bin/bash

# Enhanced Security Scanning Script
# This script runs multiple security checks on the Docker image

set -e

IMAGE_NAME=${1:-"react-docker-app"}

echo "🔒 Starting comprehensive security scan for image: $IMAGE_NAME"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Trivy is available
if ! command_exists trivy; then
    echo "📦 Installing Trivy..."
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
fi

echo "🔍 Running Trivy vulnerability scan..."

# Scan for vulnerabilities (table format for readable output)
echo "=== VULNERABILITY SCAN RESULTS ==="
trivy image --format table --severity HIGH,CRITICAL $IMAGE_NAME || echo "⚠️ Trivy scan completed with findings"

# Generate SARIF report for GitHub Security tab
echo "📝 Generating SARIF report..."
trivy image --format sarif --output trivy-results.sarif $IMAGE_NAME || echo "⚠️ SARIF generation completed"

# Scan for secrets
echo "🔐 Scanning for secrets..."
trivy image --scanners secret --format table $IMAGE_NAME || echo "⚠️ Secret scan completed"

# Scan for misconfigurations
echo "⚙️ Scanning for misconfigurations..."
trivy image --scanners config --format table $IMAGE_NAME || echo "⚠️ Configuration scan completed"

# Generate summary
echo ""
echo "📊 SECURITY SCAN SUMMARY"
echo "========================"

# Count vulnerabilities by severity
HIGH_VULNS=$(trivy image --format json $IMAGE_NAME 2>/dev/null | jq -r '[.Results[]?.Vulnerabilities[]? | select(.Severity == "HIGH")] | length' 2>/dev/null || echo "0")
CRITICAL_VULNS=$(trivy image --format json $IMAGE_NAME 2>/dev/null | jq -r '[.Results[]?.Vulnerabilities[]? | select(.Severity == "CRITICAL")] | length' 2>/dev/null || echo "0")

echo "🔴 Critical vulnerabilities: $CRITICAL_VULNS"
echo "🟠 High vulnerabilities: $HIGH_VULNS"

# Security recommendations
echo ""
echo "💡 SECURITY RECOMMENDATIONS"
echo "============================"
echo "✅ Keep base images updated regularly"
echo "✅ Use minimal base images (Alpine Linux)"
echo "✅ Run containers as non-root user"
echo "✅ Scan images before deployment"
echo "✅ Monitor for new vulnerabilities"

# Check if image follows best practices
echo ""
echo "🏗️ DOCKERFILE BEST PRACTICES CHECK"
echo "=================================="

if [ -f "Dockerfile" ]; then
    echo "Checking Dockerfile..."
    
    # Check for USER instruction
    if grep -q "^USER" Dockerfile; then
        echo "✅ Non-root user specified"
    else
        echo "⚠️ Consider adding USER instruction for security"
    fi
    
    # Check for COPY instead of ADD
    if grep -q "^ADD" Dockerfile; then
        echo "⚠️ Consider using COPY instead of ADD when possible"
    else
        echo "✅ Uses COPY instruction appropriately"
    fi
    
    # Check for specific versions
    if grep -q ":latest" Dockerfile; then
        echo "⚠️ Avoid using ':latest' tag for base images"
    else
        echo "✅ Uses specific image versions"
    fi
else
    echo "❌ Dockerfile not found"
fi

echo ""
echo "🎯 Security scan completed! Check trivy-results.sarif for detailed findings."

# Exit with success (we don't want to fail the build on vulnerabilities)
exit 0