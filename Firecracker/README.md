# Firecracker installieren und ausführen <br>

Zunächst muss hier erwähnt werden, dass es mehrere möglichkeiten gibt ein Firecracker zu installieren und in verschiedenen Umgebungen auszuführen. <br>
In diesem Installationsanleitung werde ich 2 Möglichkeiten zeigen. <br>
1. Möglichkeit, über ein KVM Firecracker starten. <br>
2. Möglichkeit, über ein Firecracker Container starten. <br> 

# 1. Firecracker installieren und über ein KVM starten <br>

# Firecracker installieren <br>
```bash
sudo setfacl -m u:${USER}:rw /dev/kvm
curl -Lo firecracker https://github.com/firecracker-microvm/firecracker/releases/download/v0.16.0/firecracker-v0.16.0

chmod +x firecracker

sudo mv firecracker /usr/local/bin/firecracker
```

Nachdem wir die Grundlegende Architektur installiert haben können wir jetzt anfangen Firecracker zum laufen zu bringen. <br>
Zunächst benötigen wir ein Kernel und ein Ubuntu System, damit wir auch mit unserem Fircracker richtig arbeiten können. <br>
Dafür verwenden wir ein Ubuntu Kernel und ein Alpine System. <br>

Amazone hat diese 2 Daten schon bereitgestellt, man es einfach Herunterladen. <br>
Wer ein andere System verwenden möchte kann auch sein eigene Rootfs Datei erstellen. Es ist sehr aufwändig aber lohnenswert es mal ausprobiert zu haben!.<br>

# Rootfs und Kernel für Firecracker installieren <br>
```bash
curl -fsSL -o hello-vmlinux.bin https://s3.amazonaws.com/spec.ccfc.min/img/hello/kernel/hello-vmlinux.bin

curl -fsSL -o hello-rootfs.ext4 https://s3.amazonaws.com/spec.ccfc.min/img/hello/fsfiles/hello-rootfs.ext4
```

Diese zwei Daten sollten in den enstprechenden richtigen Pfaden heruntegeladen werden, damit wir es auch später in unserem Bash Script einbinden können. <br>

# Firecracker starten <br>
Um den Firecracker zu starten werden 2 Bash Scripte benötigt. Der erste Script wird benötigt, damit der Firecracker startet und der zweite Script um den Firecracker mit den ensptrechenden Rottfs, Kernel und Network Konfigurationen zu starten. <br>

# Firecracker starten (Script 1) <br>
```bash 
#!/bin/bash

rm -f /tmp/firecracker.socket

firecracker \
	--api-sock /tmp/firecracker.socket \
```
# Firecracker mit mit den enstprechenden Konfigurationen starten (Script 2) <br>
Bitte beachtet das ihr die entsprechenden Pfade abändern müsst! Bei mir liegen die 2 Datein ```hello-vmlinux.bin``` und ```hello-rootfs.ext4``` im Pfad ```./```.

```bash
rm -f /tmp/firecracker.socket
firecracker --api-sock /tmp/firecracker.socket

curl -fsSL -o hello-vmlinux.bin https://s3.amazonaws.com/spec.ccfc.min/img/hello/kernel/hello-vmlinux.bin

curl -fsSL -o hello-rootfs.ext4 https://s3.amazonaws.com/spec.ccfc.min/img/hello/fsfiles/hello-rootfs.ext4

Als Sript: 

curl --unix-socket /tmp/firecracker.socket -i \
-X PUT 'http://localhost/boot-source' \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
-d '{
"kernel_image_path": "./hello-vmlinux.bin",
"boot_args": "console=ttyS0 reboot=k panic=1 pci=off"
}'

curl --unix-socket /tmp/firecracker.socket -i \
-X PUT 'http://localhost/drives/rootfs' \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
-d '{
"drive_id": "rootfs",
"path_on_host": "./hello-rootfs.ext4",
"is_root_device": true,
"is_read_only": false
}'
curl --unix-socket /tmp/firecracker.socket -i \
-X PUT 'http://localhost/machine-config' \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
-d '{
"vcpu_count": 1,
"mem_size_mib": 512
}'

curl --unix-socket /tmp/firecracker.socket -i \
-X PUT 'http://localhost/actions' \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
-d '{
"action_type": "InstanceStart"
}'
```

# Firecracker richtig ausführen <br>
Jetzt haben wir beide Scripte vervollständigt und können diese jetzt starten, dafür benötigt man 2 Terminal Fenster. <br>
Der erste Script ist bei mir als ```starteFirecracker.sh``` abgespeichert und der zweite als ```start.sh```. <br>

Wir werden beide paralls ausführen, zuerst den ersten Script ```starteFirecracker.sh``` und danach parallel ```start.sh```. <br>
Das ganze sollte ungefähr wie folgt aussehen. <br>
Terminal 1: <br>
```bash 
root@ubuntu-VirtualBox:/home/ubuntu/Abschlussarbeit/Firecracker# sh startFirecracker.sh 

```
Terminal 2: <br>
```bash
root@ubuntu-VirtualBox:/home/ubuntu/Abschlussarbeit/Firecracker# sh start.sh 
```

Wenn wir ```starteFirecracker.sh``` starten und danach ```start.sh```. Sollte es wie folgt aussehen: <br>
Terminal 1:
```bash
root@ubuntu-VirtualBox:/home/ubuntu/Abschlussarbeit/Firecracker# sh startFirecracker.sh 
[    0.000000] Linux version 4.14.55-84.37.amzn2.x86_64 (mockbuild@ip-10-0-1-79) (gcc version 7.3.1 20180303 (Red Hat 7.3.1-5) (GCC)) #1 SMP Wed Jul 25 18:47:15 UTC 2018
[    0.000000] Command line: console=ttyS0 reboot=k panic=1 pci=off  root=/dev/vda virtio_mmio.device=4K@0xd0000000:5 virtio_mmio.device=4K@0xd0001000:6
[    0.000000] [Firmware Bug]: TSC doesn't count with P0 frequency!
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000003e7fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI not present or invalid.
[    0.000000] Hypervisor detected: KVM
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Using PIT calibration value
[    0.000000] e820: last_pfn = 0x3e800 max_arch_pfn = 0x400000000
[    0.000000] MTRR: Disabled
[    0.000000] x86/PAT: MTRRs disabled, skipping PAT initialization too.
[    0.000000] CPU MTRRs all blank - virtualized system.
[    0.000000] x86/PAT: Configuration [0-7]: WB  WT  UC- UC  WB  WT  UC- UC  
[    0.000000] found SMP MP-table at [mem 0x0009fc00-0x0009fc0f] mapped at [ffffffffff200c00]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000003e7fffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x3e7de000-0x3e7fffff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:3e7dc001, primary cpu clock
[    0.000000] kvm-clock: using sched offset of 224335395727 cycles
[    0.000000] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x000000003e7fffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000003e7fffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000003e7fffff]
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000] MPTABLE: OEM ID: FC      
[    0.000000] MPTABLE: Product ID: 000000000000
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] IOAPIC[0]: apic_id 3, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Processors: 2
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x000fffff]
[    0.000000] e820: [mem 0x3e800000-0xffffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] random: get_random_bytes called from start_kernel+0x94/0x486 with crng_init=0
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] percpu: Embedded 41 pages/cpu @ffff88003e400000 s128728 r8192 d31016 u1048576
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 3e415040
[    0.000000] PV qspinlock hash table entries: 256 (order: 0, 4096 bytes)
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 251881
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: console=ttyS0 reboot=k panic=1 pci=off  root=/dev/vda virtio_mmio.device=4K@0xd0000000:5 virtio_mmio.device=4K@0xd0001000:6
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 989460K/1023608K available (8204K kernel code, 622K rwdata, 1464K rodata, 1268K init, 2820K bss, 34148K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.004000] Hierarchical RCU implementation.
[    0.004000] 	RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=2.
[    0.004000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
[    0.004000] NR_IRQS: 4352, nr_irqs: 56, preallocated irqs: 16
[    0.004000] Console: colour dummy device 80x25
[    0.004000] console [ttyS0] enabled
[    0.004000] tsc: Detected 2096.062 MHz processor
[    0.004000] Calibrating delay loop (skipped) preset value.. 4192.12 BogoMIPS (lpj=8384248)
[    0.004059] pid_max: default: 32768 minimum: 301
[    0.008243] Security Framework initialized
[    0.010260] SELinux:  Initializing.
[    0.018212] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.022240] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.024137] Mount-cache hash table entries: 2048 (order: 2, 16384 bytes)
[    0.028094] Mountpoint-cache hash table entries: 2048 (order: 2, 16384 bytes)
[    0.033713] CPU: Physical Processor ID: 0
[    0.036027] CPU: Processor Core ID: 0
[    0.040097] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.043553] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.044027] Spectre V2 : Spectre mitigation: LFENCE not serializing, switching to generic retpoline
[    0.052025] Spectre V2 : Mitigation: Full generic retpoline
[    0.056056] Spectre V2 : Spectre v2 mitigation: Filling RSB on context switch
[    0.064036] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl and seccomp
[    0.077291] Freeing SMP alternatives memory: 28K
[    0.093919] smpboot: Max logical packages: 1
[    0.097941] x2apic enabled
[    0.100030] Switched APIC routing to physical x2apic.
[    0.114438] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.366758] APIC timer disabled due to verification failure
[    0.368074] smpboot: CPU0: AMD EPYC (family: 0x17, model: 0x18, stepping: 0x1)
[    0.371235] Performance Events: AMD PMU driver.
[    0.372017] ... version:                0
[    0.373655] ... bit width:              48
[    0.376003] ... generic registers:      4
[    0.377517] ... value mask:             0000ffffffffffff
[    0.379547] ... max period:             00007fffffffffff
[    0.380009] ... fixed-purpose events:   0
[    0.381710] ... event mask:             000000000000000f
[    0.384342] Hierarchical SRCU implementation.
[    0.388979] smp: Bringing up secondary CPUs ...
[    0.391556] x86: Booting SMP configuration:
[    0.392007] .... node  #0, CPUs:      #1
[    0.004000] kvm-clock: cpu 1, msr 0:3e7dc041, secondary cpu clock
[    0.410247] KVM setup async PF for cpu 1
[    0.412000] kvm-stealtime: cpu 1, msr 3e515040
[    0.420132] smp: Brought up 1 node, 2 CPUs
[    0.421883] smpboot: Total of 2 processors activated (8384.24 BogoMIPS)
[    0.425193] devtmpfs: initialized
[    0.426709] x86/mm: Memory block size: 128MB
[    0.428882] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.432016] futex hash table entries: 512 (order: 3, 32768 bytes)
[    0.440548] NET: Registered protocol family 16
[    0.444850] cpuidle: using governor ladder
[    0.448173] cpuidle: using governor menu
[    0.464653] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.473461] dmi: Firmware registration failed.
[    0.476275] NetLabel: Initializing
[    0.480047] NetLabel:  domain hash size = 128
[    0.484010] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    0.488038] NetLabel:  unlabeled traffic allowed by default
[    0.492051] clocksource: Switched to clocksource kvm-clock
[    0.494721] Clockevents: could not switch to one-shot mode:
[    0.494723]  lapic is not functional.
[    0.494725] Could not switch to high resolution mode on CPU 0
[    0.495072] Clockevents: could not switch to one-shot mode:
[    0.495075]  lapic is not functional.
[    0.495076] Could not switch to high resolution mode on CPU 1
[    0.511496] VFS: Disk quotas dquot_6.6.0
[    0.513986] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.538651] NET: Registered protocol family 2
[    0.547559] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.557279] TCP bind hash table entries: 8192 (order: 5, 131072 bytes)
[    0.562364] TCP: Hash tables configured (established 8192 bind 8192)
[    0.568082] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.573022] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.577959] NET: Registered protocol family 1
[    0.581347] virtio-mmio: Registering device virtio-mmio.0 at 0xd0000000-0xd0000fff, IRQ 5.
[    0.585123] virtio-mmio: Registering device virtio-mmio.1 at 0xd0001000-0xd0001fff, IRQ 6.
[    0.606019] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.612941] Scanning for low memory corruption every 60 seconds
[    0.619955] audit: initializing netlink subsys (disabled)
[    0.627517] Initialise system trusted keyrings
[    0.627618] audit: type=2000 audit(1591694959.256:1): state=initialized audit_enabled=0 res=1
[    0.638368] Key type blacklist registered
[    0.641272] workingset: timestamp_bits=36 max_order=18 bucket_order=0
[    0.651215] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.716690] Key type asymmetric registered
[    0.719667] Asymmetric key parser 'x509' registered
[    0.723231] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.729089] io scheduler noop registered (default)
[    0.732698] io scheduler cfq registered
[    0.735829] virtio-mmio virtio-mmio.0: Failed to enable 64-bit or 32-bit DMA.  Trying to continue, but this might not work.
[    0.749360] virtio-mmio virtio-mmio.1: Failed to enable 64-bit or 32-bit DMA.  Trying to continue, but this might not work.
[    0.760966] Serial: 8250/16550 driver, 1 ports, IRQ sharing disabled
[    0.801462] serial8250: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a U6_16550A
[    0.829000] loop: module loaded
[    0.836163] tun: Universal TUN/TAP device driver, 1.6
[    0.841559] hidraw: raw HID events driver (C) Jiri Kosina
[    0.844702] nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
[    0.848618] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.873445] Initializing XFRM netlink socket
[    0.876369] NET: Registered protocol family 10
[    0.881229] Segment Routing with IPv6
[    0.883758] NET: Registered protocol family 17
[    0.886862] Bridge firewalling registered
[    0.889767] sched_clock: Marking stable (886721915, 0)->(1380736357, -494014442)
[    0.898145] registered taskstats version 1
[    0.900637] random: fast init done
[    0.902746] Loading compiled-in X.509 certificates
[    0.910720] Loaded X.509 cert 'Build time autogenerated kernel key: 3472798b31ba23b86c1c5c7236c9c91723ae5ee9'
[    0.916584] zswap: default zpool zbud not available
[    0.919722] zswap: pool creation failed
[    0.925892] Key type encrypted registered
[    0.959994] EXT4-fs (vda): recovery complete
[    0.972283] EXT4-fs (vda): mounted filesystem with ordered data mode. Opts: (null)
[    0.977401] VFS: Mounted root (ext4 filesystem) on device 254:0.
[    0.984672] devtmpfs: mounted
[    0.999450] Freeing unused kernel memory: 1268K
[    1.015093] Write protecting the kernel read-only data: 12288k
[    1.027832] Freeing unused kernel memory: 2016K
[    1.037098] Freeing unused kernel memory: 584K
OpenRC init version 0.35.5.87b1ff59c1 starting
Starting sysinit runlevel

   OpenRC 0.35.5.87b1ff59c1 is starting up Linux 4.14.55-84.37.amzn2.x86_64 (x86_64)

 * Mounting /proc ...
 [ ok ]
 * Mounting /run ...
 * /run/openrc: creating directory
 * /run/lock: creating directory
 * /run/lock: correcting owner
 * Caching service dependencies ...
[    1.630282] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1e36a88731c, max_idle_ns: 440795269020 ns
Service `hwdrivers' needs non existent service `dev'
 [ ok ]
Starting boot runlevel
 * Remounting devtmpfs on /dev ...
 [ ok ]
 * Mounting /dev/mqueue ...
 [ ok ]
 * Mounting /dev/pts ...
 [ ok ]
 * Mounting /dev/shm ...
 [ ok ]
 * Setting hostname ...
 [ ok ]
 * Checking local filesystems  ...
 [ ok ]
 * Remounting filesystems ...
 [ ok ]
 * Mounting local filesystems ...
 [ ok ]
 * Loading modules ...
modprobe: can't change directory to '/lib/modules': No such file or directory
modprobe: can't change directory to '/lib/modules': No such file or directory
 [ ok ]
 * Mounting misc binary format filesystem ...
 [ ok ]
 * Mounting /sys ...
 [ ok ]
 * Mounting security filesystem ...
 [ ok ]
 * Mounting debug filesystem ...
 [ ok ]
 * Mounting SELinux filesystem ...
 [ ok ]
 * Mounting persistent storage (pstore) filesystem ...
 [ ok ]
Starting default runlevel

Welcome to Alpine Linux 3.8
Kernel 4.14.55-84.37.amzn2.x86_64 on an x86_64 (ttyS0)

localhost login:
```

Terminal 2:
```bash
root@ubuntu-VirtualBox:/home/ubuntu/Abschlussarbeit/Firecracker# sh start.sh 
HTTP/1.1 204 No Content
Date: Tue, 09 Jun 2020 09:29:18 GMT

HTTP/1.1 204 No Content
Date: Tue, 09 Jun 2020 09:29:18 GMT

HTTP/1.1 204 No Content
Date: Tue, 09 Jun 2020 09:29:18 GMT

HTTP/1.1 204 No Content
Date: Tue, 09 Jun 2020 09:29:18 GMT

HTTP/1.1 204 No Content
Date: Tue, 09 Jun 2020 09:29:18 GMT
```

Unser Firecracker läuft jetzt. Der Login und Password ist root. Mit dem befehl reboot wird ihr ausgelogt. 

# Netzwerk verbindung <br>

Für eine Netzwerk verbindung müssen wir wie folgt auf dem Host System befehle ausführen. Ich Empfehle auch hier ein Bash Script. <br>
```bash
root@ubuntu-VirtualBox:/home/ubuntu/Abschlussarbeit/Firecracker# cat network.sh 
#!/bin/bash

sudo ip tuntap add tap0 mode tap
sudo ip addr add 172.20.0.1/24 dev tap0
sudo ip link set tap0 up

DEVICE_NAME=enp0s3

sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i tap0 -o enp0s3 -j ACCEPT
sudo ip addr add 172.20.0.1/24 dev tap0

root@ubuntu-VirtualBox:/home/ubuntu/Abschlussarbeit/Firecracker# sh network.sh 
```
Diese führt ihr aus und überprüft mit ifconfig ob die Schnittstelle richtig eingestellt wurde. Kopiert euch die MAC-Adresse die wird im nächsten Schritt benötigt!. <br>

# Mac Adresse <br>

Jetzt müsst ihr zu euerem start.sh Script die folgenden Adressen mit der entsprechenden MAC-Adresse die ihr im vorherigen Schritt kopiert habt einfügen. <br>
```bash
curl --unix-socket /tmp/firecracker.socket -i \
  -X PUT 'http://localhost/network-interfaces/eth0' \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
      "iface_id": "eth0",
      "guest_mac": "a2:96:04:dc:75:a1",
      "host_dev_name": "tap0"
    }'
```
Jetzt startet ihr erneut Firecracker. <br> 

# Im Gast System MAC-Adresse detection <br>

Jetzt sollte euere Maschine die enstprechende IP-Adresse haben. Es muss nur noch die MAC-Adresse erkannt werden und schon habt ihr eine Internet verbindung. <br>

Hier Empfehle ich wieder ein Bash Script in euere Maschine zu erstellen und diese dann einfach ausführen. <br>

```bash
localhost:~# cat network.sh 
#!/bin/bash
ifconfig eth0 up && ip addr add dev eth0 172.20.0.2/24
ip route add default via 172.20.0.1 && echo "nameserver 8.8.8.8" > /etc/resolv.conf

localhost:~# sh network.sh 
localhost:~# [   84.039625] IPv6: eth0: IPv6 duplicate address fe80::644b:8dff:fe3d:7605 detected!
```

Jetzt könnt ihr google.de versuchen zu pingen. <br>
```bash
localhost:~# ping google.de
PING google.de (172.217.18.3): 56 data bytes
64 bytes from 172.217.18.3: seq=0 ttl=54 time=61.114 ms
64 bytes from 172.217.18.3: seq=1 ttl=54 time=20.210 ms
64 bytes from 172.217.18.3: seq=2 ttl=54 time=16.319 ms
64 bytes from 172.217.18.3: seq=3 ttl=54 time=18.812 ms

--- google.de ping statistics ---
4 packets transmitted, 4 packets received, 0% packet loss
round-trip min/avg/max = 16.319/29.113/61.114 ms
```
Finish! <br>

# 2. Firecracker installieren und über ein Container ausführen <br>
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


# Kernel
Wir benötigen auch hier ein Kernel. <br>
```bash
curl -fsSL -o hello-vmlinux.bin https://s3.amazonaws.com/spec.ccfc.min/img/hello/kernel/hello-vmlinux.bin
```

# Firecracker-Container repository <br>
in ```~/go``` Pfad den repostory clonen. <br>
```bash
git clone --recurse-submodules https://github.com/firecracker-microvm/firecracker-containerd
```

Jetzt müssen wir bestimmte Binärdateien aufbauen. <br>
```bash
cd firecracker-containerd
GO111MODULE=on make all
```

Danach sollten folgende Binärdateien erzeugt wurden sein. <br>
```bash

   - runtime/containerd-shim-aws-firecracker
   - firecracker-control/cmd/containerd/firecracker-containerd
   - firecracker-control/cmd/containerd/firecracker-ctr
```

jetzt lassen wir Firecracker aufbauen. <br>

```bash
make firecracker
```
Danach sollten folgende Daten vorhanden sein: <br>
```bash
~/go/src/github.com/firecracker-containerd/_submodules/firecracker/build/cargo_target/x86_64-unknown-linux-musl/release/firecracker

~/go/src/github.com/firecracker-containerd/_submodules/firecracker/build/cargo_target/x86_64-unknown-linux-musl/release/jailer
```

# Image aufbauen <br>
Bevor wir den Image aufbauen müssen wir ```Docker API Socket``` anschalten. <br>

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
make image
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
sudo truncate -s 10G "${DATA_DIR}/meta"

# Allocate loop devices
DATA_DEV=$(sudo losetup --find --show "${DATA_DIR}/data")
META_DEV=$(sudo losetup --find --show "${DATA_DIR}/meta")

# Define thin-pool parameters.
# See https://www.kernel.org/doc/Documentation/device-mapper/thin-provisioning.txt for details.
SECTOR_SIZE=512
DATA_SIZE="$(sudo blockdev --getsize64 -q ${DATA_DEV})"
LENGTH_IN_SECTORS=$(echo $((${DATA_SIZE}/${SECTOR_SIZE})))
DATA_BLOCK_SIZE=128
LOW_WATER_MARK=32768

# Create a thin-pool device
sudo dmsetup create "${POOL_NAME}" \
    --table "0 ${LENGTH_IN_SECTORS} thin-pool ${META_DEV} ${DATA_DEV} ${DATA_BLOCK_SIZE} ${LOW_WATER_MARK}"

cat << EOF
#
# Add this to your config.toml configuration file and restart containerd daemon
#
disabled_plugins = ["cri"]
root = "/var/lib/firecracker-containerd/containerd"
state = "/run/firecracker-containerd"
[grpc]
  address = "/run/firecracker-containerd/containerd.sock"
[plugins]
  [plugins.devmapper]
    pool_name = "${POOL_NAME}"
    base_image_size = "10GB"
    root_path = "${DATA_DIR}"
[debug]
  level = "debug"
EOF

```
# Firecracker Container starten <br>
```bash
mkdir -p /var/lib/firecracker-containerd
```
Start container <br>
```bash
cd ~/go/src/github.com/firecracker-containerd/firecracker-control/cmd/containerd/
 sudo PATH=$PATH ~/go/src/github.com/firecracker-containerd/firecracker-control/cmd/containerd/firecracker-containerd  \
  --config /etc/containerd/config.toml
```


Image pullen <br>
```bash
sudo ./firecracker-ctr --address /run/firecracker-containerd/containerd.sock images \
  pull --snapshotter devmapper \
  docker.io/library/busybox:latest
```
