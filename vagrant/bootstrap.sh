#!/usr/bin/env bash

# Install programs
yum -y install php mariadb-server mariadb php-mysql php-xml php-mbcrypt mod_ssl openssl git npm java6 gcc php-gd php-devel php-pear ImageMagick ImageMagick-devel gcc-c++ autoconf automake

# Starts database
systemctl start mariadb.service
systemctl enable mariadb.service

# Install ImageMagick PHP Extension
if ! [ -e /etc/php.d/imagick.ini ]; then
    pecl install imagick
    echo "extension=imagick.so" > /etc/php.d/imagick.ini
fi

# Install Xdebug
if ! [ -e /etc/php.d/xdebug.ini ]; then
	pecl install Xdebug
	echo "zend_extension=/usr/lib64/php/modules/xdebug.so" > /etc/php.d/xdebug.ini
	echo "xdebug.idekey=phpstorm_idekey" >> /etc/php.d/xdebug.ini
	echo "xdebug.remote_host=192.168.33.1" >> /etc/php.d/xdebug.ini
	echo "xdebug.remote_port=9000" >> /etc/php.d/xdebug.ini
	echo "xdebug.remote_enable=1" >> /etc/php.d/xdebug.ini
fi

# Install gulp
command -v gulp >/dev/null 2>&1 || {
	
    curl -sL https://rpm.nodesource.com/setup | bash -
    yum install -y nodejs
    npm install -g gulp@3.8.11
}

# Setup apache config
if ! [ -e /etc/httpd/conf.d/php-proj.conf ]; then
    cp /php-env/vagrant/php-proj.conf /etc/httpd/conf.d/
fi

firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload

umount /php-env
mount -t vboxsf -o uid=`id -u apache`,gid=`getent group apache | cut -d: -f3` php-env /php-env
mount -t vboxsf -o uid=`id -u apache`,gid=`id -g apache` php-env /php-env

setenforce 0

sed -i '/<Directory \/>/,/<\/Directory>/ s/AllowOverride none/AllowOverride all/' /etc/httpd/conf/httpd.conf
sed -i '/<Directory \/>/,/<\/Directory>/ s/Require all denied/Options FollowSymLinks/' /etc/httpd/conf/httpd.conf
sed -i 's/EnableSendfile on/EnableSendfile off/' /etc/httpd/conf/httpd.conf
sed -i 's/short_open_tag = .*/short_open_tag = On/' /etc/php.ini
sed -i 's/;date\.timezone =.*/date\.timezone = EST/' /etc/php.ini

service httpd stop
service httpd start