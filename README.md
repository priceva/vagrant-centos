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

1. Rename `vagrant.example.yaml` to `vagrant.yaml`.
2. Edit `vagrant.yaml` for your requirements.
3. Edit your `hosts` file. For example, if you host machine based on Windows, open `C:\Windows\System32\drivers\etc` and add in and of this file this line: `10.10.60.10 vagrant-centos.local`. These values should coincide with those used in the previous step. 
4. `vagrant up`.

## Links
[CentOS official Vagrant box ver. 7](https://app.vagrantup.com/centos/boxes/7)