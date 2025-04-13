#!/bin/bash

docker build -t azure-devops-build-agent .

# Stop and remove the old container if it exists
docker rm -f azure-devops-build-agent-container 2>/dev/null || true

# Run the new container
docker run -d -p 3522:8080 --name azure-devops-build-agent-container azure-devops-build-agent