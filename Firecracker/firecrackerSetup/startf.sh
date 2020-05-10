./firectl \
  --kernel=hello-vmlinux.bin \
  --root-drive=hello-rootfs.ext4 \
  --kernel-opts="console=ttyS0 noapic reboot=k panic=1 pci=off nomodules rw" \
  --add-drive=file.qcow2:rw \
  --tap-device=tap0/ip a | grep -A1 tap0 | grep ..:[0-9\|A-Z].:..:..:..:..

