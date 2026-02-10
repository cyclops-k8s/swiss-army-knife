FROM ubuntu:26.04
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        arping \
        arptables \
        bridge-utils \
        ca-certificates \
        conntrack \
        curl \
        dnsutils \
        ethtool \
        iperf \
        iperf3 \
        iproute2 \
        ipset \
        iptables \
        iputils-ping \
        jq \
        kmod \
        ldap-utils \
        less \
        libpcap-dev \
        man \
        manpages-posix \
        mtr \
        net-tools \
        netcat-openbsd \
        openssl \
        openssh-client \
        psmisc \
        socat \
        tcpdump \
        telnet \
        tmux \
        traceroute \
        tcptraceroute \
        tree \
        ngrep \
        vim \
        wget \
        yq && \
    rm -rf /var/lib/apt/lists/* && \
    mv /usr/sbin/traceroute /usr/bin/traceroute

RUN curl -L \
        "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
        -o "/usr/bin/kubectl" && \
    chmod +x /usr/bin/kubectl

RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash

RUN mkdir -p /root/.kube

WORKDIR /root
