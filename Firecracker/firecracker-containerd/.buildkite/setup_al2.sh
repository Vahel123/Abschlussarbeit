#!/bin/bash

set -eux

source ./.buildkite/al2env.sh

mkdir -p $dir
mkdir -p $dir/rootfs
mkdir -p $bin_path
mkdir -p $devmapper_path
mkdir -p $state_path

./tools/thinpool.sh reset $unique_id

export INSTALLROOT=$dir
export FIRECRACKER_CONTAINERD_RUNTIME_DIR=$dir
make
cp /var/lib/fc-ci/vmlinux.bin $dir/default-vmlinux.bin
make image firecracker
sudo -E INSTALLROOT=$INSTALLROOT PATH=$PATH \
     make install install-firecracker install-default-rootfs

cat << EOF > $dir/config.toml
disabled_plugins = ["cri"]
root = "$dir"
state = "$state_path"
[grpc]
  address = "$dir/containerd.sock"
[plugins]
  [plugins.devmapper]
    pool_name = "fcci--vg-$unique_id"
    base_image_size = "10GB"
    root_path = "$devmapper_path"
[debug]
  level = "debug"
EOF

cat << EOF > $runtime_config_path
{
	"cpu_template": "T2",
	"debug": true,
	"firecracker_binary_path": "$bin_path/firecracker",
	"shim_base_dir": "$dir",
	"kernel_image_path": "$dir/default-vmlinux.bin",
	"kernel_args": "ro console=ttyS0 noapic reboot=k panic=1 pci=off nomodules systemd.journald.forward_to_console systemd.log_color=false systemd.unit=firecracker.target init=/sbin/overlay-init",
	"log_level": "DEBUG",
	"root_drive": "$dir/default-rootfs.img",
	"jailer": {
		"runc_binary_path": "$bin_path/runc",
		"runc_config_path": "$dir/config.json"
	}
}
EOF

cp ./runtime/firecracker-runc-config.json.example $dir/config.json
cp ./_submodules/runc/runc $bin_path/runc
