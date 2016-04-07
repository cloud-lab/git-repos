apt-get update
apt-get -y upgrade
apt-get -y install linux-headers-$(uname -r)

echo "UseDNS no" >> /etc/ssh/sshd_config
date > /home/vagrant/vagrant_box_build_time