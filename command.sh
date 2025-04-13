#!/bin/bash

docker build -t azure-devops-build-agent .

# Stop and remove the old container if it exists
docker rm -f azure-devops-build-agent-container 2>/dev/null || true

export AZP_URL="https://dev.azure.com/qdraw/"
export AZP_TOKEN="3rzK9Jf6jw3RXfAeSUlO33VKtmmLgaFIPUT6MSSCRb5q2dYA2vD4JQQJ99BDACAAAAAAAAAAAAASAZDO3x07"

# Run the new container
docker run -d -p 3522:8080 --name azure-devops-build-agent-container -e AZP_TOKEN="$AZP_TOKEN" -e AZP_TOKEN="$AZP_TOKEN" -e AZP_URL="$AZP_URL" azure-devops-build-agent