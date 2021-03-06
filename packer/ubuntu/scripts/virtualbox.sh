echo "Installing Virtualbobox guest additions"
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
cd /tmp
mount -o loop /home/vagrant/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm -rf /home/vagrant/VBoxGuestAdditions_*.iso
rm -rfv /usr/src/vboxguest* /usr/src/virtualbox-ose-guest*

echo ..
echo ..
sleep 20s

