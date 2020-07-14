#/bash/bin!

# Container starten und entfernen Test
sudo ~/go/src/github.com/firecracker-containerd/firecracker-control/cmd/containerd/firecracker-ctr --address /run/containerd/containerd.sock \
     run -d \
     --privileged \
     --snapshotter devmapper \
     --runtime aws.firecracker \
     --rm --tty --net-host \
     docker.io/vahelhassan/debian-test:latest ping -c 1 8.8.8.8 \
     test
