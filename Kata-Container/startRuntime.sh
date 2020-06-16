#!/bin/bash
bundle="/tmp/bundle" 
rootfs="$bundle/rootfs"
mkdir -p "$rootfs" && (cd "$bundle" && kata-runtime spec)
sudo docker export $(sudo docker create busybox) | tar -C "$rootfs" -xvf -
sudo kata-runtime --log=/dev/stdout run --bundle "$bundle" foo
