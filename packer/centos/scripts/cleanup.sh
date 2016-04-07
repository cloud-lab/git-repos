yum -y erase gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts
yum -y clean all
sudo rm -rf /tmp/rubygems-*

rm /var/lib/dhcp/*
rm -rfv /usr/src/linux-headers*

yum -y update

echo ..
echo ..
sleep 30s

