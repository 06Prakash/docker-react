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

Perfect for learning CI/CD with tools like:
- AWS CodePipeline
- AWS CodeBuild
- GitHub Actions
- GitLab CI/CD

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
