Vagrant.configure(2) do |config|
  config.vm.box = "vStone/centos-7.x-puppet.3.x"
  
  config.vm.provider :virtualbox do |vb|
    vb.gui = false
    vb.memory = 512
    vb.cpus = 1
  end

  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provision :shell, path: "vagrant/bootstrap.sh"
  config.vm.synced_folder ".", "/php-env"
end
