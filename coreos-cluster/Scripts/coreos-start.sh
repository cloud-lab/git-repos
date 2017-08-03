#!/bin/bash

read -p "How many nodes in cluster: " size
read -p "Enter IP address of first node (/24): " ipaddr

subnet=$(echo $ipaddr | cut --complement -d. -f4)
node=$(echo $ipaddr | cut -d. -f4)
token=$(curl -sS https://discovery.etcd.io/new?size=$size)

echo
echo "You have entered IP address as" $ipaddr
echo "The first hostname is coreos-"$node "with" $size "nodes in cluster"
echo "The token is" $token
echo
echo -------- WARNINING -------
echo This script will delete all existing VMs and their associated
echo yaml file with same vm-name in XenServer.
echo Press a key to proceed or ctrl-c to stop the script.
echo

read -s -n 1

for (( i=$node; i < $(expr $node + $size) ; i++ ))
do
  printf "\n1> Delete existing VM with same hostname as coreos-$i\n"
    xe vm-shutdown force=true vm="CoreOS-$i"
    xe vm-uninstall force=true vm="CoreOS-$i"

  printf "\n2> Use template to create VM coreos-$i. Please wait ....\n"
    xe vm-install template="CoreOS-base" new-name-label="CoreOS-$i"
    xe vm-start vm="CoreOS-$i"
  echo VM coreos-$i is starting ...

  printf "\n3> Prepare CoreOS yaml file for VM coreos-$i\n"
    rm -f coreos-$(echo $i).yaml
    cp _core-tmpl.yaml coreos-$(echo $i).yaml
    sed -i -e "s|@token|$token|g" \
           -e "s|@hostn|coreos-$i|g" \
           -e "s|@ipaddr|$subnet.$i|g" \
           -e "s|@ipgw|$subnet.1|g" \
           coreos-$(echo $i).yaml

  printf "\n4> Copy yaml file to VM coreos-$i. Please wait .....\n"
#    while ! ping -c1 10.1.82.40 &>/dev/null; do echo .; done
#    scp coreos-$(echo $i).yaml core@10.1.82.40:/home/core/
#    ssh -o StrictHostKeyChecking=no core@10.1.82.40 "sudo mv /home/core/coreos-$(echo $i).yaml /var/lib/coreos-install/user_data"

  printf "\n5> Reboot VM CoreOS-$i\n"
#    xe vm-reboot force=true vm="CoreOS-$i"
#  echo Node coreos-$i is restarting ...
#  while ping -c1 10.1.82.40 &>/dev/null; do echo . ; done

done

