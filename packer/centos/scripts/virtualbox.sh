# Install dependencies for Virtualbox guest additions installation

echo "Installing dependencies for guest additions"
yum -y install gcc gcc-c++ kernel-devel-`uname -r`

echo "Installing Virtualbobox guest additions"
ls -al /home/vagrant
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
cd /tmp
mount -o loop /home/vagrant/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm -rf /home/vagrant/VBoxGuestAdditions_*.iso
rm -rfv /usr/src/vboxguest* /usr/src/virtualbox-ose-guest*

echo ..
echo ..
sleep 30s

# yum -y erase gcc gcc-c++ kernel-devel-`uname -r` 

echo ..
echo ..
sleep 30s
