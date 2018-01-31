sudo yum -y update
sudo yum -y install net-tools
sudo yum -y install epel-release
sudo yum -y install nginx

sudo systemctl start nginx
sudo systemctl enable nginx

sudo yum -y install mariadb-server mariadb

sudo systemctl start mariadb
sudo systemctl enable mariadb

cd ~
curl 'https://setup.ius.io/' -o setup-ius.sh
sudo bash setup-ius.sh
sudo yum -y install git php71u-fpm-nginx php71u-cli php71u-mysqlnd php71u-json php71u-common php71u-gd php71u-xml php71u-mbstring php71u-mcrypt php71u-opcache php71u-pdo 

sudo sed -i '39c listen = /run/php-fpm/www.sock' /etc/php-fpm.d/www.conf
sudo sed -i '58c listen.acl_users = nginx' /etc/php-fpm.d/www.conf 
sudo sed -i '5,6c #server 127.0.0.1:9000; \
                  server unix:/run/php-fpm/www.sock;' /etc/nginx/conf.d/php-fpm.conf 
                  
sudo systemctl start php-fpm
sudo systemctl enable php-fpm
sudo systemctl restart nginx

sudo touch /usr/share/nginx/html/info.php
sudo echo "<?php phpinfo();" | sudo tee --append /usr/share/nginx/html/info.php

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

curl -I http://127.0.0.1/info.php