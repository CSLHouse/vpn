#!/bin/sh
iptables -t nat -A POSTROUTING -s 192.168.200.0/24 -o eth0 -j MASQUERADE

ip tuntap add mode tun
ip link set tun0 up
ip addr add 192.168.200.1/32 peer 192.168.200.2 dev tun0
arp -sD 192.168.200.2 eth0 pub
iptables -t nat -A POSTROUTING -s 192.168.200.2 -o eth0 -j MASQUERADE