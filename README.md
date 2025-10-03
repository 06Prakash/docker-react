# React Docker App 🐳

A simple React application containerized with Docker, perfect for learning CI/CD pipelines with AWS.

## Features

- ⚛️ React 18 application
- 🐳 Multi-stage Docker build
- 🚀 Production-ready with Nginx
- 📦 Docker Compose for easy development
- 🔧 Optimized for AWS deployment

## Getting Started

### Prerequisites

- Docker
- Docker Compose (optional)

### Running with Docker

1. **Build the Docker image:**
   ```bash
   docker build -t react-docker-app .
   ```

2. **Run the container:**
   ```bash
   docker run -p 3000:80 react-docker-app
   ```

3. **Open your browser:**
   Navigate to `http://localhost:3000`

### Running with Docker Compose

1. **Start the application:**
   ```bash
   docker-compose up --build
   ```

2. **Open your browser:**
   Navigate to `http://localhost:3000`

3. **Stop the application:**
   ```bash
   docker-compose down
   ```

### Development Mode

If you want to run in development mode:

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Start development server:**
   ```bash
   npm start
   ```

## Docker Architecture

This project uses a multi-stage Docker build:

1. **Build Stage**: Uses Node.js to build the React application
2. **Production Stage**: Uses Nginx Alpine to serve the built files

### Benefits:
- Small production image size
- Fast serving with Nginx
- Optimized for production deployment

## AWS Deployment Ready

This application is configured for easy deployment to AWS services:

- **AWS ECS**: Ready for container orchestration
- **AWS Fargate**: Serverless container deployment
- **AWS App Runner**: Direct deployment from container registry
- **AWS Elastic Beanstalk**: Platform-as-a-Service deployment

## CI/CD Pipeline

This project includes a comprehensive GitHub Actions CI/CD pipeline that:

### 🧪 **Testing Phase**

- Runs unit tests with Jest and React Testing Library
- Generates test coverage reports
- Uploads test results as artifacts

### 🐳 **Docker Testing Phase**

- Builds the Docker image
- Runs comprehensive container tests:
  - Container startup verification
  - HTTP response testing
  - Content validation
  - Nginx configuration validation
  - Image size optimization check
  - Basic security checks

### 🔒 **Security Scanning**

- Runs Trivy vulnerability scanner
- Uploads security scan results to GitHub Security tab

### 📦 **Build and Push**

- Builds multi-architecture images (AMD64, ARM64)
- Pushes to GitHub Container Registry
- Generates Software Bill of Materials (SBOM)
- Uses build caching for optimization

### 🚀 **Deployment**

- Automated staging deployment on main branch
- Environment protection rules
- Ready for AWS integration

### Manual Testing

You can run the Docker tests manually using the provided scripts:

```bash
# Make scripts executable
chmod +x scripts/*.sh

# Run comprehensive Docker tests
./scripts/test-docker.sh

# Run health check
./scripts/health-check.sh http://localhost:3000

# Run unit tests
npm test
```

## Project Structure

```
.
├── public/
│   └── index.html
├── src/
│   ├── App.js
│   ├── App.css
│   ├── index.js
│   └── index.css
├── Dockerfile
├── docker-compose.yml
├── nginx.conf
├── package.json
└── README.md
```

## Useful Commands

```bash
# Build image
docker build -t react-docker-app .

# Run container
docker run -p 3000:80 react-docker-app

# Run in background
docker run -d -p 3000:80 react-docker-app

# View running containers
docker ps

# Stop container
docker stop <container-id>

# Remove image
docker rmi react-docker-app
```

## License

This project is created for educational purposes.
