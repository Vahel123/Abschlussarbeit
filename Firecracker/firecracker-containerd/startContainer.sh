#!/bin/bash
sudo PATH=$PATH ~/go/src/github.com/firecracker-containerd/firecracker-control/cmd/containerd/firecracker-containerd  \
  --config /etc/containerd/config.toml
