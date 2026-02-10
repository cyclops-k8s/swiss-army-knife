# swiss-army-knife

A comprehensive Docker image based on Ubuntu 24.04 with networking, debugging, and Kubernetes tools for troubleshooting and system administration.

## Tools Included

### Networking Tools
- **ping** - Test network connectivity
- **traceroute** - Trace the route packets take to a network host
- **tracepath** - Trace path to network host discovering MTU
- **ss** - Socket statistics utility
- **mtr** - Network diagnostic tool combining ping and traceroute
- **tcpdump** - Network packet analyzer
- **curl** - Transfer data from/to servers
- **wget** - Non-interactive network downloader
- **dig** - DNS lookup utility
- **host** - DNS lookup utility
- **ethtool** - Display/change ethernet card settings
- **iftop** - Display bandwidth usage on network interfaces
- **ifstat** - Network interface statistics
- **iperf3** - Network bandwidth measurement tool
- **ip** - Show/manipulate routing, devices, policy routing and tunnels
- **ncat/netcat** - Network utility for reading/writing network connections
- **ssh** - OpenSSH client for secure shell access

### Text Editors & Utilities
- **vim** - Powerful text editor
- **jq** - Command-line JSON processor
- **yq** - Command-line YAML processor

### System Utilities
- **dd** - Convert and copy files
- **ps** - Report process status
- **top** - Display and update sorted information about processes

### Kubernetes & Cluster Tools
- **etcdctl** - Command-line client for etcd (v3.5.17)
- **kubectl** - Kubernetes command-line tool (v1.31.4)
  - Note: If kubectl is not available due to network issues during build, you can install it manually after starting the container:
    ```bash
    install-kubectl
    ```

## Usage

### Pull and Run
```bash
# Pull the image
docker pull cyclops-k8s/swiss-army-knife

# Run interactively
docker run -it --rm cyclops-k8s/swiss-army-knife

# Run with host network for network debugging
docker run -it --rm --network host cyclops-k8s/swiss-army-knife

# Run specific command
docker run --rm cyclops-k8s/swiss-army-knife ping -c 4 google.com
```

### Building from Source
```bash
docker build -t swiss-army-knife .
```

### Kubernetes Deployment
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: swiss-army-knife
spec:
  containers:
  - name: swiss-army-knife
    image: cyclops-k8s/swiss-army-knife
    command: ["/bin/bash"]
    args: ["-c", "sleep infinity"]
```

Then exec into the pod:
```bash
kubectl exec -it swiss-army-knife -- /bin/bash
```

## Examples

### Network Diagnostics
```bash
# Check connectivity
ping -c 4 google.com

# Trace route to a host
traceroute google.com

# Check open ports
ss -tuln

# Network bandwidth test
iperf3 -c server.example.com

# Capture network packets
tcpdump -i eth0 -w capture.pcap

# Check DNS resolution
dig google.com
host google.com
```

### Kubernetes Operations
```bash
# Get cluster info (if kubectl is installed)
kubectl cluster-info

# Check etcd health (if you have access to etcd)
ETCDCTL_API=3 etcdctl --endpoints=http://127.0.0.1:2379 endpoint health
```

### JSON/YAML Processing
```bash
# Pretty print JSON
echo '{"name":"test","value":123}' | jq '.'

# Process YAML
echo 'name: test' | yq eval '.'
```

## License

MIT License - see [LICENSE](LICENSE) file for details.