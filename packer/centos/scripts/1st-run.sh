# Sudo is installed by kick-start
# vagrant is added during kick-start

yum install -y net-tools bin-utils perl bzip2
yum update
yum -y upgrade

# Disable UseDNS to speed up boot skipping DNS lookup
echo "UseDNS no" >> /etc/ssh/sshd_config

date > /home/vagrant/vagrant_box_build_time
