#!/bin/sh
ip tuntap add tun0 mode tun
ip link set tun0 up
ip addr add 192.168.200.2/32 peer 192.168.200.1 dev tun0

ssh -NTCf -w 0:0 -i fly.pem root@52.199.40.8
ip route add 52.199.40.8 via 192.168.1.1  #vps物理以太网口直接出去
ip route add default via 192.168.200.1

iptables -t nat -F
iptables -t nat -A INPUT -p udp -m udp --dport 53 -j ACCEPT
iptables -t nat -A OUTPUT -p udp -m udp --sport 53 -j ACCEPT
iptables -t nat -A POSTROUTING -d 52.199.40.8 -o enp3s0f0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o tun0 -j MASQUERADE


#优化
ip route add 119.29.29.29 via 192.168.1.1
echo 222 china >> /etc/iproute2/rt_tables
ip rule add fwmark 22 table china
ip route add default via 192.168.1.1 dev enp3s0f0 table china


iptables -t nat -F
iptables -t mangle -F
iptables -t nat -A POSTROUTING -d 52.199.40.8 -o enp3s0f0 -j MASQUERADE
iptables -t nat -A POSTROUTING -d 119.29.29.29 -o enp3s0f0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -d 182.50.122.0/24 -o enp3s0f0 -j MASQUERADE
iptables -t nat -A POSTROUTING -o enp3s0f0 -m mark --mark 0x16 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o tun0 -j MASQUERADE

iptables-restore < /opt/aws-vpn/it_rules