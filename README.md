onionpi-setup
=============

This is a script to configure a Raspberry Pi as a wifi-to-wifi Tor middlebox, which will connect to a wifi network and broadcast its own wifi through which network traffic will be anonymized.

Prerequisites
-------------

You will need a Raspberry Pi model 3B, 2B, or B+ running Raspbian and all necessary peripherals, including interface device(s) for initial setup (monitor, HDMI cable, & keyboard or a USB to Serial cable). You will also need one wifi adapter if using a Raspberry Pi 3, or two dongles otherwise.

Preparation
------------

Before you use the script, you must have wifi configured on your Raspberry Pi. If using a Raspberry Pi 2 or an older model, it is recommended that you only plug in one wifi adapter at first to configure wifi. After wlan0 is configured, turn off the Pi, plug in your second wifi adapter, and boot it back up.

After booting up, log into your Pi using the terminal, SSH, or a serial connection.

To download the script, you will need  git on your Pi. If you don't already have it, install it:

```shell
sudo apt-get install -y git
```

Download the script from Github:

```shell
git clone https://github.com/StarshipEngineer/onionpi-setup.git
```

Before proceeding, you may want to upgrade packages:

```shell
sudo apt-get update && sudo apt-get -y upgrade
```

#Using the Script

