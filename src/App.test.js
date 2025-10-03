import { render, screen } from '@testing-library/react';
import App from './App';

test('renders React Docker App heading', () => {
  render(<App />);
  const headingElement = screen.getByText(/React Docker App/i);
  expect(headingElement).toBeInTheDocument();
});

test('renders welcome message', () => {
  render(<App />);
  const welcomeElement = screen.getByText(/Welcome to your Dockerized React application/i);
  expect(welcomeElement).toBeInTheDocument();
});

test('renders CI/CD features list', () => {
  render(<App />);
  const featuresElement = screen.getByText(/Features Ready for CI\/CD/i);
  expect(featuresElement).toBeInTheDocument();
});

test('renders all feature items', () => {
  render(<App />);
  
  // Check if all feature items are present - using more specific text patterns
  expect(screen.getByText(/✅ Dockerized React Application/i)).toBeInTheDocument();
  expect(screen.getByText(/✅ Multi-stage Docker Build/i)).toBeInTheDocument();
  expect(screen.getByText(/✅ Production-ready Nginx Serving/i)).toBeInTheDocument();
  expect(screen.getByText(/✅ Optimized for AWS Deployment/i)).toBeInTheDocument();
});

test('renders version information', () => {
  render(<App />);
  const versionElement = screen.getByText(/Version: 1\.0\.0/i);
  expect(versionElement).toBeInTheDocument();
});
