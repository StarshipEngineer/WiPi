#!/bin/bash

# Update and install Tor
sudo apt-get update
sudo apt-get install -y tor

# Configure Tor

sed -i '/faq#torrc/a\
Log notice file /var/log/tor/notices.log
VirtualAddrNetwork 10.192.0.0/10
AutomapHostsSuffixes .onion,.exit
AutomapHostsOnResolve 1
TransPort 9040
TransListenAddress 192.168.42.1
DNSPort 53
DNSListenAddress 192.168.42.1
' /etc/tor/torrc


# Flush previous iptables rules
sudo iptables -F
sudo iptables -t nat -F

# Set new iptables rules

sudo iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 22 -j REDIRECT --to-ports 22

sudo iptables -t nat -A PREROUTING -i wlan0 -p udp --dport 53 -j REDIRECT --to-ports 53

sudo iptables -t nat -A PREROUTING -i wlan0 -p tcp --syn -j REDIRECT --to-ports 9040

sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

# Create a log file
sudo touch /var/log/tor/notices.log
sudo chown debian-tor /var/log/tor/notices.log
sudo chmod 644 /var/log/tor/notices.log

# Start Tor and enable it on boot
sudo service tor start
sudo update-rc.d tor enable