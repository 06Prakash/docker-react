#!/bin/bash

# GitHub Actions Workflow Validation Script
# This script validates the GitHub Actions workflow configuration

echo "🔍 Validating GitHub Actions workflow..."

# Check if workflow file exists
if [ ! -f ".github/workflows/ci.yml" ]; then
    echo "❌ Workflow file not found: .github/workflows/ci.yml"
    exit 1
fi

echo "✅ Workflow file found"

# Check for required files
echo "🔍 Checking required files..."

REQUIRED_FILES=(
    "package.json"
    "Dockerfile"
    "src/App.js"
    "src/App.test.js"
    "src/setupTests.js"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
        exit 1
    fi
done

# Check package.json for required dependencies
echo "🔍 Checking package.json dependencies..."

if command -v jq >/dev/null 2>&1; then
    # Use jq if available
    REACT_SCRIPTS=$(jq -r '.dependencies["react-scripts"] // empty' package.json)
    TESTING_LIBRARY=$(jq -r '.devDependencies["@testing-library/react"] // empty' package.json)
    
    if [ ! -z "$REACT_SCRIPTS" ]; then
        echo "✅ react-scripts found: $REACT_SCRIPTS"
    else
        echo "❌ react-scripts not found in dependencies"
    fi
    
    if [ ! -z "$TESTING_LIBRARY" ]; then
        echo "✅ @testing-library/react found: $TESTING_LIBRARY"
    else
        echo "❌ @testing-library/react not found in devDependencies"
    fi
else
    # Fallback to grep if jq is not available
    if grep -q '"react-scripts"' package.json; then
        echo "✅ react-scripts found in package.json"
    else
        echo "❌ react-scripts not found in package.json"
    fi
    
    if grep -q '"@testing-library/react"' package.json; then
        echo "✅ @testing-library/react found in package.json"
    else
        echo "❌ @testing-library/react not found in package.json"
    fi
fi

# Check Docker configuration
echo "🔍 Checking Docker configuration..."

if docker --version >/dev/null 2>&1; then
    echo "✅ Docker is available"
else
    echo "⚠️  Docker not available (required for local testing)"
fi

# Validate workflow syntax (basic check)
echo "🔍 Basic workflow syntax validation..."

if grep -q "on:" .github/workflows/ci.yml && \
   grep -q "jobs:" .github/workflows/ci.yml && \
   grep -q "runs-on:" .github/workflows/ci.yml; then
    echo "✅ Basic workflow syntax looks good"
else
    echo "❌ Basic workflow syntax validation failed"
    exit 1
fi

echo ""
echo "🎉 GitHub Actions workflow validation completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Commit and push your changes to trigger the workflow"
echo "2. Check the Actions tab in your GitHub repository"
echo "3. Review any failed steps and debug as needed"
echo "4. Set up GitHub environments if you want to use deployment gates"
echo ""
echo "💡 Tips:"
echo "- Make sure your repository has the necessary secrets configured"
echo "- Check that GitHub Actions are enabled for your repository"
echo "- Consider setting up branch protection rules"
