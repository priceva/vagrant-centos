# Typical LAMP project based on CentOS official Vagrant box

## Features
### Server Stuff

* CentOS 7
* Remi repo
* PHP 7.2
* Apache 2.4
* Disabled SELinux
* Logging Vagrant provision scripts
* Colored prompt
* sudo
* unzip, zip, mc, wget, nano, git

### PHP stuff 

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

## Start

0. Create new folder for your project. Clone or download this repository into that folder.
1. Rename `vagrant.example.yaml` to `vagrant.yaml`.
2. Edit `vagrant.yaml` for your requirements.
3. Edit your `hosts` file. For example, if you host machine based on Windows, open `C:\Windows\System32\drivers\etc` and add in end of this file this line: `10.10.60.10 vagrant-centos.local`. These values should coincide with those used in the previous step. 
4. Go to the your new project folder and run `vagrant up`.
5. Visit [http://vagrant-centos.local/](http://vagrant-centos.local/) or another address if you changed the name of the box in the config.

## Links
[CentOS official Vagrant box ver. 7](https://app.vagrantup.com/centos/boxes/7)