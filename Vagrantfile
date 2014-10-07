# -*- mode: ruby -*-
# vi: set ft=ruby :

boxes = [
  { :name => :elastic,:ip => '192.168.33.111',:forward => 9200,:cpus => 2,:mem => 1024,:provision => 'build_elastic.bash' },
  { :name => :ngix,:ip => '192.168.33.112',:forward => 80,:cpus => 1,:mem => 256 },
  { :name => :suricata,:ip => '192.168.33.113',:cpus => 1, :mem => 512,:provision => 'build_suricata.bash'},
  { :name => :bro,:ip => '192.168.33.114',:cpus => 1,:mem => 512,:provision => 'build_bro.bash' },
  { :name => :moloch,:ip => '192.168.33.115',:forward => 8005,:cpus => 2,:mem => 768,:provision => 'build_moloch.bash' },
  ]

$update_script = <<SCRIPT
date > /etc/vagrant_provisioned_at
sudo apt-get -qq update
sudo apt-get -y -qq upgrade
SCRIPT

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    boxes.each do |opts|
        config.vm.define opts[:name] do |config|
            config.vm.box       = "robwc/minitrusty64"
            config.vm.network  "private_network", ip: opts[:ip]
            config.vm.network  "forwarded_port", guest: opts[:forward], host: opts[:forward] if opts[:forward]
            config.vm.hostname = "%s.vagrant" % opts[:name].to_s
            config.vm.provider "virtualbox" do |vb|
                vb.customize ["modifyvm", :id, "--cpus", opts[:cpus] ] if opts[:cpus]
                vb.customize ["modifyvm", :id, "--memory", opts[:mem] ] if opts[:mem]
            end
            config.vm.provision "shell", inline: $update_script
            config.vm.provision "shell", path: opts[:provision] if opts[:provision]
       end
    end
end
