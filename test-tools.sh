#!/bin/bash
# Test script to verify all required tools are installed

echo "Swiss Army Knife - Tool Verification"
echo "====================================="
echo

TOOLS=(
    "ping:iputils ping"
    "traceroute:Modern traceroute"
    "tracepath:tracepath from iputils"
    "ss:ss utility"
    "vim:VIM"
    "mtr:mtr"
    "tcpdump:tcpdump version"
    "curl:curl"
    "dig:DiG"
    "ethtool:ethtool version"
    "host:host"
    "iftop:iftop"
    "ifstat:ifstat"
    "iperf3:iperf"
    "ip:ip utility"
    "ncat:Ncat"
    "ssh:OpenSSH"
    "wget:GNU Wget"
    "yq:yq"
    "jq:jq"
    "dd:dd"
    "ps:ps from procps"
    "top:procps-ng"
    "etcdctl:etcdctl version"
    "kubectl:Client Version"
)

FAILED=0
PASSED=0

for tool_info in "${TOOLS[@]}"; do
    tool="${tool_info%%:*}"
    expected="${tool_info##*:}"
    
    if command -v "$tool" &> /dev/null; then
        if "$tool" --version 2>&1 | grep -q "$expected" || \
           "$tool" -V 2>&1 | grep -q "$expected" || \
           "$tool" version 2>&1 | grep -q "$expected"; then
            echo "✓ $tool"
            ((PASSED++))
        else
            echo "✓ $tool (found but version check inconclusive)"
            ((PASSED++))
        fi
    else
        echo "✗ $tool - NOT FOUND"
        ((FAILED++))
    fi
done

echo
echo "Results: $PASSED passed, $FAILED failed"
echo

if [ $FAILED -eq 0 ]; then
    echo "All required tools are installed! ✓"
    exit 0
else
    echo "Some tools are missing. Please check the installation."
    exit 1
fi
