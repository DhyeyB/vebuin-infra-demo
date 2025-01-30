#!/bin/bash
sudo apt -y update
sudo apt-get install -y nginx
sudo service apache2 stop
sudo systemctl disable apache2
sudo systemctl enable nginx
sudo service nginx restart
echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.nginx-debian.html
sudo systemctl restart nginx.service
sudo mkdir -p /home/ubuntu/.ssh
touch /home/ubuntu/.ssh/known_hosts
sudo echo ${ssh_public_key} >> /home/ubuntu/.ssh/authorized_keys
sudo adduser --disabled-password --gecos '' deploy
sudo passwd -d deploy
sudo usermod -aG sudo deploy
sudo su deploy
sudo mkdir -p /home/deploy/.ssh
touch /home/deploy/.ssh/known_hosts
sudo echo ${ssh_public_key} >> /home/deploy/.ssh/authorized_keys