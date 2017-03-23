#!/bin/bash

# Update & install software
sudo apt-get update
sudo apt-get install -y hostapd isc-dhcp-server iptables-persistent

# Configure dhcp server
sudo sed -i '/option domain-name "example.org";/c\
#option domain-name "example.org";' /etc/dhcp/dhcpd.conf

sudo sed -i '/option domain-name-servers ns1.example.org, ns2.example.org;/c\
#option domain-name-servers ns1.example.org, ns2.example.org' /etc/dhcp/dhcpd.conf

sudo sed -i '/#authoritative;/c\
authoritative;' /etc/dhcp/dhcpd.conf

sudo cat dhcpd.demo >> /etc/dhcp/dhcpd.conf

sudo sed -i '/INTERFACES=""/c\
INTERFACES="wlan1"' /etc/default/isc-dhcp-server

# Disable wlan1 for configuration
sudo ifdown wlan1

# Set up interfaces file for wlan1
sudo sed -i '/wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf/c\
#wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf' /etc/network/interfaces

sudo sed -i '/iface wlan1 inet/c\
iface wlan1 inet static' /etc/network/interfaces

sudo sed -i '/iface wlan1 inet static/a\
  address 192.168.42.1\
  netmask 255.255.255.0
' /etc/network/interfaces

sudo sed -i '/iface wlan0 inet/a\
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
' /etc/network/interfaces

sudo ifconfig wlan1 192.168.42.1

# Configure hostapd.conf; edit values in hostapd.demo if desired
cat hostapd.demo >> /etc/hostapd/hostapd.conf

sed -i '/#DAEMON_CONF=""/c\
DAEMON_CONF="/etc/hostapd/hostapd.conf"' /etc/default/hostapd

sed -i '/DAEMON_CONF=/c\
DAEMON_CONF=/etc/hostapd/hostapd.conf' /etc/init.d/hostapd

# Enable ipv4 forwarding
sed -i '/#net.ipv4.ip_forward=1/c\
net.ipv4.ip_forward=1' /etc/sysctl.conf

sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

# Update iptables rules
sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
sudo iptables -A FORWARD -i wlan0 -o wlan1 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan1 -o wlan0 -j ACCEPT

sudo sh -c "iptables-save > /etc/iptables/rules.v4"

# Start hostapd and isc-dhcp-server and enable them on boot
sudo service hostapd start
sudo service isc-dhcp-server start

sudo update-rc.d hostapd enable
sudo update-rc.d isc-dhcp-server enable