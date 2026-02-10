#!/bin/bash
# Script to install kubectl if it's not already installed
# This can be run after the container starts if network issues prevented installation during build

set -e

KUBECTL_VERSION=${KUBECTL_VERSION:-v1.31.4}

if command -v kubectl &> /dev/null; then
    echo "kubectl is already installed:"
    kubectl version --client
    exit 0
fi

echo "Installing kubectl version ${KUBECTL_VERSION}..."

# Try multiple mirrors/methods
for attempt in 1 2 3; do
    echo "Attempt $attempt..."
    if curl -Lk --retry 3 --retry-delay 2 -o /usr/local/bin/kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" 2>/dev/null; then
        chmod +x /usr/local/bin/kubectl
        echo "kubectl installed successfully!"
        kubectl version --client
        exit 0
    fi
    sleep 5
done

echo "Failed to install kubectl after 3 attempts. Please check your network connection."
exit 1
