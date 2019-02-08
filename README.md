# Typical LAMP project based on CentOS official Vagrant box

## Features
### Server Stuff

* CentOS 7
* Remi repo
* PHP 7.2
* Apache 2.4
* MariaDB
* Disabled SELinux
* Logging Vagrant provision scripts
* Colored prompt
* Colored nano
* sudo
* net-tools, unzip, zip, mc, wget, nano, git

### PHP stuff 

* phpinfo
* Composer (last actual version from getcomposer.org)
* xdebug 2.6.1
* php-cli
* php-myqlnd
* php-gd
* php-mbstring
* php-xml
* php-curl
* php-xmlrpc
* php-bcmath
* php-zip

## MySQL stuff

* Adminer 4.6.3 (multilingual)

MySQL user: root
MySQL password: root

### SSH Stuff

* Disabling private key method authentication
* User: vagrant
* Password: vagrant

## Requirements

* Vagrant > 2.0
* VirtualBox > 5.2
* Vagrant plugins:
  * vagrant-vbguest
  * vagrant-reload
  * vagrant-winnfsd, if we will use Windows based host machine

## Getting started

1. Create new folder for your project. Clone or download this repository into that folder.
2. Rename `vagrant.example.yaml` to `vagrant.yaml`.
3. Edit `vagrant.yaml` for your requirements.
4. Edit your `hosts` file. For example, if you host machine based on Windows, open `C:\Windows\System32\drivers\etc` and add in end of this file this line: `10.10.60.10 vagrant-centos.local`. These values should coincide with those used in the previous step. 
5. Go to the your new project folder and run `vagrant up`.
6. Visit [http://vagrant-centos.local/](http://vagrant-centos.local/) or another address if you changed the name of the box in the config.
7. Run our playbook:
````bash
sudo ansible-playbook -i /var/www/box-playbook/hosts /var/www/box-playbook/box.yml
````

### Starting individual tasks from the playbook

If we need to run any tasks from the playbook separately from the others, we can use this command:

````bash
sudo ansible-playbook -i /var/www/box-playbook/hosts /var/www/box-playbook/box.yml --tags %tag%
````

or vice versa, skipping tasks:

````bash
sudo ansible-playbook -i /var/www/box-playbook/hosts /var/www/box-playbook/box.yml --skip-tags %tag%
````

replacing `% tag%` with the task tag we need. Following tags are currently available:

* php
* xdebug
* mariadb
* apache
* adminer

## Links
[CentOS official Vagrant box ver. 7](https://app.vagrantup.com/centos/boxes/7)