Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/trusty64'

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '2048']
  end

  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :forwarded_port, guest: 35729, host: 35729
  config.vm.network "private_network", ip: "192.168.50.4"
  config.vm.synced_folder '.', '/vagrant', type: 'nfs'

  config.vm.provision :shell, path: '.vagrant-provision.sh', run: 'always'
end
