FROM ubuntu:24.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install base tools
RUN apt-get update && apt-get install -y \
    # Networking utilities
    iputils-ping \
    iputils-tracepath \
    traceroute \
    iproute2 \
    mtr-tiny \
    tcpdump \
    curl \
    dnsutils \
    ethtool \
    bind9-host \
    iftop \
    ifstat \
    iperf3 \
    ncat \
    openssh-client \
    wget \
    # Text editor
    vim \
    # JSON/YAML processors
    jq \
    # System utilities
    coreutils \
    procps \
    # Additional utilities
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install yq (YAML processor)
# Note: Using --no-check-certificate to handle SSL inspection in some build environments
# WARNING: This bypasses SSL validation. In production, use proper certificates.
# TODO: Add checksum verification for additional security
RUN wget --no-check-certificate -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq

# Copy helper script for kubectl installation
COPY install-kubectl.sh /usr/local/bin/install-kubectl
RUN chmod +x /usr/local/bin/install-kubectl

# Copy tool verification script
COPY test-tools.sh /usr/local/bin/test-tools
RUN chmod +x /usr/local/bin/test-tools

# Install kubectl (using a fixed stable version with retries)
# Note: Using -k (insecure) to handle SSL inspection in some build environments
# WARNING: This bypasses SSL validation. In production, use proper certificates.
# TODO: Add checksum verification for additional security
RUN KUBECTL_VERSION=v1.31.4 && \
    for i in 1 2 3; do \
        curl -Lk --retry 3 --retry-delay 2 -o /usr/local/bin/kubectl https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && break || sleep 5; \
    done && \
    if [ -f /usr/local/bin/kubectl ]; then chmod +x /usr/local/bin/kubectl; fi || echo "kubectl installation skipped due to network issues"

# Install etcdctl (using a fixed stable version with retries)
# Note: Using --no-check-certificate to handle SSL inspection in some build environments
# WARNING: This bypasses SSL validation. In production, use proper certificates.
# TODO: Add checksum verification for additional security
RUN ETCD_VER=v3.5.17 && \
    for i in 1 2 3; do \
        wget --no-check-certificate https://github.com/etcd-io/etcd/releases/download/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz && break || sleep 5; \
    done && \
    if [ -f etcd-${ETCD_VER}-linux-amd64.tar.gz ]; then \
        tar xzvf etcd-${ETCD_VER}-linux-amd64.tar.gz && \
        mv etcd-${ETCD_VER}-linux-amd64/etcdctl /usr/local/bin/ && \
        rm -rf etcd-${ETCD_VER}-linux-amd64* && \
        chmod +x /usr/local/bin/etcdctl; \
    fi || echo "etcdctl installation skipped due to network issues"

# Set default shell
CMD ["/bin/bash"]
