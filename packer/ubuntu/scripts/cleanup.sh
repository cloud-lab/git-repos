# Reducing the final size of the image to help Packer build a less big box.
# Credits to Vinicius Massuchetto and his helpful post in GitHub:
# http://vmassuchetto.github.io/2013/08/14/reducing-a-vagrant-box-size/

echo "cleaning up APT packages"
apt-get -y --purge remove linux-headers-$(uname -r) build-essential
apt-get -y autoremove
apt-get -y clean

echo "Linux headers"
rm -rfv /usr/src/linux-headers*

echo "Cleaning up dhcp leases"
rm /var/lib/dhcp/*

echo "Whiteouting /"
count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`;
count=$((count -= 1))
dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count;
rm /tmp/whitespace;
 
echo "Whiteouting /boot"
count=`df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}'`;
count=$((count -= 1))
dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count;
rm /boot/whitespace;

echo "Whiteouting swap"
swappart=`cat /proc/swaps | tail -n1 | awk -F ' ' '{print $1}'`
swapoff $swappart;
dd if=/dev/zero of=$swappart;
mkswap $swappart;
swapon $swappart;

echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
echo "pre-up sleep 2" >> /etc/network/interfaces
