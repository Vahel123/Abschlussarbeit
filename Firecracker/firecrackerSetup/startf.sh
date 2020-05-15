# Die MAX Adresse muss immer an tab0 MAC Adresse angepasst werden
./firectl \
  --kernel=hello-vmlinux.bin \
  --root-drive=hello-rootfs.ext4 \
  --kernel-opts="console=ttyS0 noapic reboot=k panic=1 pci=off nomodules rw" \
  --add-drive=file.qcow2:rw \
  --tap-device=tap0/72:66:9b:2e:45:c7


