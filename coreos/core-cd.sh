#!/bin/bash

# Prequisite:
# Boot CoreOS with LiveCD in VirtualBox or VMware.
# Use console access to create user for ssh access, e.g. Putty
# > sudo useradd -U -m icoadmin -G sudo
# > sudo passwd icoadmin
# ssh login with new user
# paste this file content and save as core-cd.sh
# chmod +x core-cd.sh
# execute core-cd.sh

echo && echo
read -p "Please enter CoreOS user name: " user
read -s -p "Password: " pass

if [ -z $pass ]; then
        echo -e "$(tput setaf 1)!! Exit -- No password !!$(tput sgr0)"
        exit 1; fi

echo
read -s -p "Enter password again: " password
if ! [ "$pass" == "$password" ]; then
        echo -e "$(tput setaf 1)!! Exit -- password does not match!!$(tput sgr0)"
        exit 1; fi

# hash password
password=`echo -n $pass | mkpasswd --method=SHA-512 --rounds=4096 -s`

# get discovery url
discoveryUrl=`curl https://discovery.etcd.io/new\?size=3`

echo
read -p "Please enter CoreOS node number: " new

if ! [ $new -eq $new ] 2>/dev/null ; then
        echo -e "$(tput setaf 1)!! Exit -- Sorry, integer only !!$(tput sgr0)"
        exit 1; fi
if [ -z $new ] || [ $new -lt 1 ] || [ $new -gt 254 ] ; then
        echo -e "$(tput setaf 1)!! Exit -- node number out of range !!$(tput sgr0)"
        exit 1; fi
new=$(echo $new | sed 's/^0*//')
old=##
subnet=192.168.100.

cd ~
# write config.yml
cat <<EOF_core > config.yml
#cloud-config

users:
  - name: $user
    passwd: $password
    groups: [ sudo, docker ]

hostname: core$new

coreos:
  etcd2:
    name: core$new
    discovery: $discoveryUrl
    advertise-client-urls: http://$subnet$new:2379,http://$subnet$new:4001
    initial-advertise-peer-urls: http://$subnet$new:2380
    listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
    listen-peer-urls: http://$subnet$new:2380

  units:
    - name: etcd2.service
      command: start

EOF_core

echo
echo
echo -e "$(tput setaf 6) !! core$new installation will start in 10 seconds !! $(tput sgr0)"

sleep 10
sudo mv netw /etc/systemd/network/static.network

# run installation
sudo chmod 755 /usr/bin/coreos-install
sudo /usr/bin/coreos-install -d /dev/sda -c config.yml -C alpha
echo -e "$(tput setaf 6)Installation finishes, please remove CoreOS live CD and reboot VM.$(tput sgr0)"

