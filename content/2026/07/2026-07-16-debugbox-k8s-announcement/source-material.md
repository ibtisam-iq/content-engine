# Raw Source Material

## 1. Reference Links

- Repository: https://github.com/ibtisam-iq/debugbox
- Documentation: https://debugbox.ibtisam-iq.com
- GHCR: ghcr.io/ibtisam-iq/debugbox
- Docker Hub: docker.io/mibtisam/debugbox
- v1.1.0 Release Notes: https://github.com/ibtisam-iq/debugbox/releases/tag/v1.1.0

## 2. Key Data Points

- netshoot size: 202 MB (compressed)
- DebugBox lite: ~15 MB (93% smaller than netshoot)
- DebugBox balanced: ~47 MB (default, daily driver)
- DebugBox power: ~91 MB (forensics and packet analysis)
- Architectures: amd64 + arm64
- Registries: GHCR + Docker Hub
- Tags per release: 22

## 3. CLI Commands

```bash
# Ephemeral container (lite)
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:lite --target=my-container

# Ephemeral container (balanced, default)
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox --target=my-container

# Power via debug pod (requires NET_ADMIN)
kubectl apply -f https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/power-debug-pod.yaml
kubectl exec -it debug-power -- bash
```

## 4. Variant Tool Scope

- Lite: curl, dig, nslookup, host, ip, ping, tracepath, netcat, jq, yq
- Balanced adds: bash, vim, git, openssl, tcpdump, strace, htop, kubectx/kubens, socat, mtr
- Power adds: tshark, nmap, iperf3, iftop, iptables, conntrack, ltrace, ethtool
