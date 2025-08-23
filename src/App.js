import React from 'react';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>🐳 React Docker App</h1>
        <p>
          Welcome to your Dockerized React application!
        </p>
        <p>
          Perfect for learning CI/CD with AWS 🚀
        </p>
        <div className="features">
          <h2>Features Ready for CI/CD:</h2>
          <ul>
            <li>✅ Dockerized React Application</li>
            <li>✅ Multi-stage Docker Build</li>
            <li>✅ Production-ready Nginx Serving</li>
            <li>✅ Optimized for AWS Deployment</li>
          </ul>
        </div>
        <p className="version">
          Version: 1.0.0
        </p>
      </header>
    </div>
  );
}

export default App;
