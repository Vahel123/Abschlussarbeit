# Firecracker installieren und über ein Container ausführen <br>
Zunächst benötigen wir wieder unsere Tools. <br>

# Goolang: 
```bash
sudo apt-get update  
sudo apt-get -y upgrade  
cd /tmp  
wget https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz
sudo tar -xvf go1.13.3.linux-amd64.tar.gz  
sudo mv go /usr/local 

export GOROOT=/usr/local/go 
export GOPATH=~/go  
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH 

go env // Pfade überprüfen  
```

# Docker
Hier könnt ihr es über die  <a href="https://docs.docker.com/get-docker/.">Docker </a> herunterladen oder über mein Github <a href="https://github.com/Vahel123/Abschlussarbeit/blob/master/Docker/README.md">Link </a> <br>


# Hardwarde überprüfen <br>
```bash
#!/bin/bash
err=""; \
[ "$(uname) $(uname -m)" = "Linux x86_64" ] \
  || err="ERROR: your system is not Linux x86_64."; \
[ -r /dev/kvm ] && [ -w /dev/kvm ] \
  || err="$err\nERROR: /dev/kvm is innaccessible."; \
(( $(uname -r | cut -d. -f1)*1000 + $(uname -r | cut -d. -f2) >= 4014 )) \
  || err="$err\nERROR: your kernel version ($(uname -r)) is too old."; \
dmesg | grep -i "hypervisor detected" \
  && echo "WARNING: you are running in a virtual machine. Firecracker is not well tested under nested virtualization."; \
[ -z "$err" ] && echo "Your system looks ready for Firecracker!" || echo -e "$err"
```

Als Ergebnis sollten folgende Zeile angezeigt werden: <br>
```bash
WARNING: you are running in a virtual machine. Firecracker is not well tested under nested virtualization.
Your system looks ready for Firecracker!
```

# Docker CE installieren <br>
```bash
sudo mkdir -p /etc/apt/sources.list.d
echo "deb http://ftp.debian.org/debian buster-backports main" | \
  sudo tee /etc/apt/sources.list.d/buster-backports.list
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get \
  install --yes \
  golang-1.13 \
  make \
  git \
  curl \
  e2fsprogs \
  util-linux \
  bc \
  gnupg

export PATH=/usr/lib/go-1.13/bin:$PATH

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
apt-key finger docker@docker.com | grep '9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88' || echo '**Cannot find Docker key**'
echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | \
     sudo tee /etc/apt/sources.list.d/docker.list
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get \
     install --yes \
     docker-ce aufs-tools-
sudo usermod -aG docker $(whoami)

```
# Debian Image installieren <br>
```bash
git clone https://github.com/firecracker-microvm/firecracker-containerd.git
cd firecracker-containerd
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y dmsetup
sg docker -c 'make all image firecracker'
sudo make install install-firecracker demo-network
```


# Kernel
Wir benötigen auch hier ein Kernel. <br>
```bash
curl -fsSL -o hello-vmlinux.bin https://s3.amazonaws.com/spec.ccfc.min/img/hello/kernel/hello-vmlinux.bin
```

Danach sollten folgende Binärdateien erzeugt wurden sein. <br>
```bash

   - runtime/containerd-shim-aws-firecracker
   - firecracker-control/cmd/containerd/firecracker-containerd
   - firecracker-control/cmd/containerd/firecracker-ctr
```

Danach sollten folgende Daten vorhanden sein: <br>
```bash
~/go/src/github.com/firecracker-containerd/_submodules/firecracker/build/cargo_target/x86_64-unknown-linux-musl/release/firecracker

~/go/src/github.com/firecracker-containerd/_submodules/firecracker/build/cargo_target/x86_64-unknown-linux-musl/release/jailer
```

# Docker API-Socket aktivieren <br>
```bash
sudo nano /etc/systemd/system/docker.service.d/startup_options.conf
```
Folgende Zeilen hinzufügen: <br>
```bash
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2376
```
Unit files neu laden und docker neu starten. <br>
```bash
sudo systemctl daemon-reload
sudo systemctl restart docker.service
```

Jetzt können wir unser Image aufbauen. <br>
```bash
sudo mkdir -p /var/lib/firecracker-containerd/runtime
sudo cp tools/image-builder/rootfs.img /var/lib/firecracker-containerd/runtime/default-rootfs.img
```
# Konfiguration von Firecracker-Containerd <br>

Wir müssen erstmal die Datei ```/etc/containerd/config.toml``` richtig konfigurieren. Bitte passt die entsprechede Pfade ab. <br> 
```bash
#   Copyright 2018-2020 Docker Inc.

#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at

#       http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

disabled_plugins = ["cri"]
root = "/var/lib/firecracker-containerd/containerd"
state = "/run/firecracker-containerd"
[grpc]
  address = "/run/firecracker-containerd/containerd.sock"
[plugins]
  [plugins.devmapper]
    pool_name = "fc-dev-thinpool"
    base_image_size = "10GB"
    root_path = "/var/lib/firecracker-containerd/snapshotter/devmapper"
[debug]
  level = "debug"

#root = "/var/lib/containerd"
#state = "/run/containerd"
#subreaper = true
#oom_score = 0

#[grpc]
#  address = "/run/containerd/containerd.sock"
#  uid = 0
#  gid = 0

#[debug]
#  address = "/run/containerd/debug.sock"
#  uid = 0
#  gid = 0
#  level = "info"
```

# Thinpool Datei erstellen <br>
Damit unser Container laufen müssen wir ein Thinpool Datei erstellen. <br>
Am besten legt ihr eine Datei an wie zum Beispiel ```CreateThinpool.sh ``` und führt danach die folgenden Script Zeilen aus.
```bash
#!/bin/bash
set -ex

DATA_DIR=/var/lib/firecracker-containerd/snapshotter/devmapper
POOL_NAME=fc-dev-thinpool

mkdir -p ${DATA_DIR}

# Create data file
sudo touch "${DATA_DIR}/data"
sudo truncate -s 100G "${DATA_DIR}/data"

# Create metadata file
sudo touch "${DATA_DIR}/meta"
sudo truncate -s 10G "${DATA_DIR}/metadata"

# Allocate loop devices
DATA_DEV=$(sudo losetup --find --show "${DATA_DIR}/data")
META_DEV=$(sudo losetup --find --show "${DATA_DIR}/metadata")

# Define thin-pool parameters.
# See https://www.kernel.org/doc/Documentation/device-mapper/thin-provisioning.txt for details.
SECTOR_SIZE=512
DATA_SIZE="$(sudo blockdev --getsize64 -q ${DATA_DEV})"
LENGTH_IN_SECTORS=$(echo $((${DATA_SIZE}/${SECTOR_SIZE})))
DATA_BLOCK_SIZE=128
LOW_WATER_MARK=32768

THINP_TABLE="0 ${LENGTH_IN_SECTORS} thin-pool ${META_DEV} ${DATA_DEV} ${DATA_BLOCK_SIZE} ${LOW_WATER_MARK} 1 skip_block_zeroing"
echo "${THINP_TABLE}"

if ! $(dmsetup reload "${POOL_NAME}" --table "${THINP_TABLE}"); then
dmsetup create "${POOL_NAME}" --table "${THINP_TABLE}"
fi
```
Jetzt müssen noch die Datei ```firecracker-runtime.json``` richtig einstellen. <br>
Die Datei liegt meistens im Pfad ```/ets/containerd/```.
```bash
{
  "firecracker_binary_path": "/usr/local/bin/firecracker",
  "kernel_image_path": "/var/lib/firecracker-containerd/runtime/hello-vmlinux.bin",
  "kernel_args": "console=ttyS0 noapic reboot=k panic=1 pci=off nomodules ro systemd.journald.forward_to_console systemd.unit=firecracker.target init=/sbin/overlay-init",
  "root_drive": "/var/lib/firecracker-containerd/runtime/default-rootfs.img",
  "cpu_template": "T2",
  "log_fifo": "fc-logs.fifo",
  "log_level": "Debug",
  "metrics_fifo": "fc-metrics.fifo",
  "shim_base_dir": "/root/go/src/github.com/firecracker-containerd/runtime/containerd-shim-aws-firecracker",
  "default_network_interfaces": [{
    "CNIConfig": {
      "NetworkName": "fcnet",
      "InterfaceName": "veth0"
    }
  }]
}
```
# Firecracker Container starten <br>
```bash
mkdir -p /var/lib/firecracker-containerd
```
Tool starten <br>
```bash
 sudo PATH=$PATH ~/go/src/github.com/firecracker-containerd/firecracker-control/cmd/containerd/firecracker-containerd  \
  --config /etc/containerd/config.toml
```

Image pullen <br>
```bash
sudo ~/go/src/github.com/firecracker-containerd/firecracker-control/cmd/containerd/firecracker-ctr --address /run/firecracker-containerd/containerd.sock \
     image pull \
     --snapshotter devmapper \
     docker.io/library/debian:latest
```

Container starten <br>
```bash
sudo ~/go/src/github.com/firecracker-containerd/firecracker-control/cmd/containerd/firecracker-ctr --address /run/firecracker-containerd/containerd.sock \
     run \
     --snapshotter devmapper \
     --runtime aws.firecracker \
     --rm --tty --net-host \
     docker.io/library/debian:latest \
     Debian
  ```
  
Damit wir eine Netzwerk Verbingung herstellen können müssen wir in dem Container ein Nameserver hiinzufügen, dazu müssen wir zunächst shm umounten. <br>
Damit wir das machen können müssen wir beim starten des Firecracker Container folgendes hinzufügen. <br>
```bash
--privileged \
```

so sollte es dann aussehen: <br>
```bash
sudo ~/go/src/github.com/firecracker-containerd/firecracker-control/cmd/containerd/firecracker-ctr --address /run/firecracker-containerd/containerd.sock \
     run \
     --privileged \
     --snapshotter devmapper \
     --runtime aws.firecracker \
     --rm --tty --net-host \
     docker.io/library/debian:latest \
     Debian
```

Jetzt müssen wir nur noch `/etc/resolv.conf` umounten danach ein Nameserver hinzufügen. <br>
```bash
[Container]umount /etc/resolf.conf
[Container]echo "nameserver 8.8.8.8" > /etc/resolv.conf
```

Jetzt nur noch ping google.de testen und fertig. <br>
```bash
ping google.de
PING google.de (172.217.18.163) 56(84) bytes of data.
64 bytes from fra15s29-in-f3.1e100.net (172.217.18.163): icmp_seq=1 ttl=114 time=40.7 ms
64 bytes from fra15s29-in-f3.1e100.net (172.217.18.163): icmp_seq=2 ttl=114 time=31.5 ms
64 bytes from fra15s29-in-f3.1e100.net (172.217.18.163): icmp_seq=3 ttl=114 time=46.10 ms
```
