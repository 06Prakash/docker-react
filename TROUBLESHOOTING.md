# GitHub Actions Troubleshooting Guide

This guide helps resolve common issues with the CI/CD pipeline.

## Common Issues and Solutions

### 1. npm ci fails with lock file sync error

**Error:**
```
npm error `npm ci` can only install packages when your package.json and package-lock.json are in sync
```

**Solutions:**
- Delete `package-lock.json` and run `npm install` to regenerate it
- Make sure both files are committed to the repository
- Use the fallback strategy: `npm ci || npm install`

### 2. Deprecated Actions Warnings

**Error:**
```
This request has been automatically failed because it uses a deprecated version of actions/upload-artifact: v3
```

**Solution:**
Update to latest action versions:
- `actions/upload-artifact@v4`
- `github/codeql-action/upload-sarif@v3`
- Use specific versions instead of `@master` or `@v0`

### 3. AWS Elastic Beanstalk Deployment Failures

**Common Errors:**

**Error: Access Denied**
```
An error occurred (AccessDenied) when calling the CreateApplicationVersion operation
```
**Solution:**
- Check IAM permissions include: `AdministratorAccess-AWSElasticBeanstalk`
- Verify AWS credentials are correctly set in GitHub secrets

**Error: Environment Not Found**
```
No Environment found for EnvironmentName: 'your-env-name'
```
**Solution:**
- Verify `EB_APPLICATION_NAME` and `EB_ENVIRONMENT_NAME` secrets match your actual EB setup
- Check the environment exists and is in the correct region

**Error: Invalid Dockerrun.aws.json**
```
Invalid dockerrun format
```
**Solution:**
- Ensure your Docker image is accessible from EB
- Check the image registry permissions
- Verify the image tag exists

**Error: S3 Bucket Not Found**
```
An error occurred (NoSuchBucket) when calling the PutObject operation: The specified bucket does not exist
```
**Solution:**
- The deployment now automatically creates the required S3 bucket
- Ensure your IAM user has `AmazonS3FullAccess` permissions
- The bucket follows AWS naming: `elasticbeanstalk-{region}-{account-id}`

**Error: Health Check Failures**
```
Environment health has transitioned from Info to Severe
```
**Solution:**
- Check EB logs in AWS Console
- Verify your Docker container exposes port 80
- Ensure your app responds to HTTP requests on port 80

### 4. Security Scan Issues

**Error: Resource not accessible by integration**
```
Warning: Resource not accessible by integration - https://docs.github.com/rest
```
**Solution:**
- This happens when GitHub Advanced Security is not enabled
- The workflow will continue - security scan results are uploaded as artifacts instead
- To enable: Go to Repository Settings → Security & analysis → Enable GitHub Advanced Security

**Error: SARIF upload failed**
```
Error: Resource not accessible by integration
```
**Solution:**
- Security scans will still run and results are available as artifacts
- Download the `trivy-scan-results` artifact from the Actions run
- Consider running security scans locally with the provided script

### 5. SBOM Generation Failures

**Error: Could not determine source**
```
could not determine source: errors occurred attempting to resolve 'ghcr.io/username/repo:latest'
```
**Solution:**
- SBOM generation now uses local image instead of registry image
- Has fallback to Syft direct installation
- SBOM step won't fail the build (continue-on-error: true)

**Error: Image not found for SBOM**
```
docker: could not parse reference: ghcr.io/username/repo:latest
```
**Solution:**
- Build local image first before SBOM generation
- Use local image tag instead of registry reference
- SBOM generation is optional and won't block deployment

### 6. Docker Build Failures

**Common issues:**
- Missing package-lock.json in Docker context
- Network issues during package installation
- Out of memory during build

**Solutions:**
- Use multi-stage builds to reduce image size
- Add fallback installation commands
- Increase Docker memory limits if needed

### 4. Test Failures in CI

**Common causes:**
- Environment differences between local and CI
- Missing test dependencies
- Browser/headless environment issues

**Solutions:**
- Set `CI=true` environment variable
- Use `--passWithNoTests` flag
- Add proper test setup files

## Debugging Tips

### Check GitHub Actions Logs
1. Go to the "Actions" tab in your repository
2. Click on the failed workflow run
3. Expand the failed step to see detailed logs

### Test Locally
```bash
# Test the same commands locally
npm ci
npm test -- --watchAll=false --ci
docker build -t test-image .
```

### Validate Workflow Syntax
```bash
# Use the validation script
./scripts/validate-workflow.sh
```

## Environment Setup

### Required Repository Settings
- Actions must be enabled
- Secrets configured if needed
- Branch protection rules (optional)

### Local Development Requirements
- Node.js 18+
- Docker
- Git
- npm or yarn

## Quick Fixes

### Regenerate Lock File
```bash
rm package-lock.json
npm install
git add package-lock.json
git commit -m "Regenerate package-lock.json"
```

### Reset Docker
```bash
docker system prune -f
docker build --no-cache -t react-docker-app .
```

### Force Fresh Install
```bash
rm -rf node_modules package-lock.json
npm install
```

## Getting Help

If issues persist:
1. Check the [GitHub Actions documentation](https://docs.github.com/en/actions)
2. Review action-specific documentation on GitHub Marketplace
3. Check repository issues and discussions
4. Ensure all required files are committed and pushed
