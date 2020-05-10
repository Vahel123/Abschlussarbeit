sudo ip tuntap add tap0 mode tap
sudo ip addr add 172.20.0.1/24 dev tap0
sudo ip link set tap0 up

DEVICE_NAME=enp0s3

sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i tap0 -o enp0s3 -j ACCEPT
sudo ip addr add 172.20.0.1/24 dev tap0
