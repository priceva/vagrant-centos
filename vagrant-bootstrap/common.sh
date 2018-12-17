#!/bin/bash

ARGUMENT_LIST=(
    "log-path"
    "log-error-path"
)

opts=$(getopt \
    --longoptions "$(printf "%s:," "${ARGUMENT_LIST[@]}")" \
    --name "$(basename "$0")" \
    --options "" \
    -- "$@"
)

eval set --${opts}

while true ; do
    case "$1" in
        --log-path)
            case "$2" in
                "") echo "ERROR: LOG_PATH not specified. Set up BOX:SYNC_PATH in config.yaml"; exit 1 ;;
                *) LOG_PATH=$2; echo "==> LOG_PATH: ${LOG_PATH}"; shift 2 ;;
            esac ;;
        --log-error-path)
            case "$2" in
                "") echo "ERROR: LOG_ERROR_PATH not specified. Set up BOX:SYNC_PATH in config.yaml"; exit 1 ;;
                *) LOG_ERROR_PATH=$2; echo "==> LOG_ERROR_PATH: ${LOG_ERROR_PATH}"; shift 2 ;;
            esac ;;
        *)
            break
            ;;
    esac
done

echo "==> Coloring nano"
cat << EOF > ~/.nanorc
include /usr/share/nano/html.nanorc
include /usr/share/nano/nanorc.nanorc
include /usr/share/nano/sh.nanorc
include /usr/share/nano/php.nanorc
EOF

cat << EOF > home/vagrant/.nanorc
include /usr/share/nano/html.nanorc
include /usr/share/nano/nanorc.nanorc
include /usr/share/nano/sh.nanorc
include /usr/share/nano/php.nanorc
EOF

echo "==> Installing php"
wget http://rpms.remirepo.net/enterprise/remi-release-7.rpm 1>>${LOG_PATH} 2>>${LOG_ERROR_PATH}
rpm -Uvh remi-release-7.rpm 1>>${LOG_PATH} 2>>${LOG_ERROR_PATH}
yum  -y --enablerepo=remi,remi-php72 install php php-cli php-myqlnd php-gd php-mbstring php-xml php-curl php-xmlrpc php-bcmath php-zip 1>>${LOG_PATH} 2>>${LOG_ERROR_PATH}

echo "==> Installing apache"
yum -y install httpd 1>>${LOG_PATH} 2>>${LOG_ERROR_PATH}
systemctl enable httpd 1>>${LOG_PATH} 2>>${LOG_ERROR_PATH}

echo "==> Installing composer"

EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('SHA384', 'composer-setup.php');")"

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid Composer installer signature'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet
RESULT=$?
rm composer-setup.php

if [ "$RESULT" != 0 ]
then
    exit ${RESULT}
fi

mv composer.phar /usr/local/bin/composer

echo "==> Installing xdebug"

echo "  ==> Downloading xdebug-2.6.1"
if ! [ -L xdebug-2.6.1.tgz ]; then
  rm -rf xdebug-2.6.1.tgz
fi
wget http://xdebug.org/files/xdebug-2.6.1.tgz -nv 1>>${LOG_PATH} 2>>${LOG_ERROR_PATH}

echo "  ==> Preparing files"
if ! [ -L xdebug-2.6.1 ]; then
  rm -rf xdebug-2.6.1
fi
tar -xvzf xdebug-2.6.1.tgz 1>>${LOG_PATH} 2>>${LOG_ERROR_PATH}
cd xdebug-2.6.1 1>>${LOG_PATH} 2>>${LOG_ERROR_PATH}
#
echo "  ==> Compiling xdebug"
wget http://rpms.remirepo.net/enterprise/remi-release-7.rpm -nv 1>>${LOG_PATH} 2>>${LOG_ERROR_PATH}
rpm -Uvh remi-release-7.rpm 1>>${LOG_PATH} 2>>${LOG_ERROR_PATH}
yum --enablerepo=remi,remi-php72 install php-devel gcc -y 1>>${LOG_PATH} 2>>${LOG_ERROR_PATH}
phpize 1>>${LOG_PATH} 2>>${LOG_ERROR_PATH}
./configure 1>>${LOG_PATH} 2>>${LOG_ERROR_PATH}
make 1>>${LOG_PATH} 2>>${LOG_ERROR_PATH}
cp modules/xdebug.so /usr/lib64/php/modules 1>>${LOG_PATH} 2>>${LOG_ERROR_PATH}

echo "zend_extension = /usr/lib64/php/modules/xdebug.so" >> /etc/php.ini

echo "==> Start web-server"
systemctl start httpd