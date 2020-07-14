#!/bin/bash
sudo ~/go/src/github.com/firecracker-containerd/firecracker-control/cmd/containerd/firecracker-ctr --address /run/containerd/containerd.sock \
     image pull \
     --snapshotter devmapper \
     docker.io/vahelhassan/debian-test:latest \

sudo ~/go/src/github.com/firecracker-containerd/firecracker-control/cmd/containerd/firecracker-ctr --address /run/containerd/containerd.sock \
     run -d \
     --privileged \
     --snapshotter devmapper \
     --runtime aws.firecracker \
     --rm --tty --net-host \
     docker.io/vahelhassan/debian-test:latest test99
