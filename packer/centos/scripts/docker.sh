tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

yum -y update
yum install -y docker-engine
service docker start

gpasswd -a vagrant docker
usermod -aG docker vagrant

systemctl enable docker
docker version

echo ..
echo ..
sleep 10s
