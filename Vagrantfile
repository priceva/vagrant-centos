require 'yaml'

current_dir    = File.dirname(File.expand_path(__FILE__))
vagrant_config = YAML.load_file("#{current_dir}/vagrant.yaml")

NAME = vagrant_config['BOX']['NAME']
MEMORY = vagrant_config['BOX']['MEMORY']
CORE = vagrant_config['BOX']['CORE']
FS_TYPE = vagrant_config['BOX']['FS_TYPE']
SYNC_PATH = vagrant_config['BOX']['SYNC_PATH']
IP = vagrant_config['BOX']['IP']

if vagrant_config['DEBUG']
    LOG_PATH = "#{SYNC_PATH}/vagrant.log".gsub('//','/')
    LOG_ERROR_PATH = "#{SYNC_PATH}/vagrant_error.log".gsub('//','/')
  else
    LOG_PATH = "/dev/null"
    LOG_ERROR_PATH = "/dev/null"
end

Vagrant.configure("2") do |config|

  config.vm.box = "centos/7"
  config.vm.synced_folder '.', '/vagrant', disabled: true

  if FS_TYPE=='vboxsf'
    # TODO: не работает этот вариант, если включим дебаг и начнем логи писать в файлы - пишет что файл (лог) занят для записи
    if Vagrant.has_plugin? 'vagrant-vbguest'
      config.vm.synced_folder ".", SYNC_PATH,
        type: "virtualbox",
        mount_options: ["dmode=777", "fmode=666"]
    else
      puts 'ERROR: vagrant-vbguest plugin not found.'
      abort
    end
  elsif FS_TYPE=='nfs'
    if Vagrant.has_plugin? 'vagrant-winnfsd'
      config.vm.synced_folder ".", SYNC_PATH,
        type: "nfs"

      config.vbguest.auto_update = false
    else
      puts 'ERROR: vagrant-winnfs plugin not found.'
      abort
    end
  else
    puts 'ERROR: Wrong FS type.'
    abort
  end

  config.vm.provider "virtualbox" do |v|
    v.name = NAME
    v.memory = MEMORY
    v.cpus = CORE
  end

  config.vm.network "private_network", ip: IP
  config.vm.hostname = NAME

  config.vm.provision "Init", type: "shell" do |s|
    s.keep_color = true
    s.binary     = true
    s.privileged = true
    s.path       = "vagrant-bootstrap/init.sh"
    s.args       = "--log-path #{LOG_PATH} --log-error-path #{LOG_ERROR_PATH}"
  end

  if Vagrant.has_plugin? 'vagrant-reload'
    config.vm.provision :reload # SELinux disabling
  else
    puts 'ERROR: vagrant-reload plugin not found.'
    abort
  end

end