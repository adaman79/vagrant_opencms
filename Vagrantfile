VAGRANTFILE_API_VERSION = "2"

Vagrant.configure("2") do |config|

  # os image
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  # server
  config.vm.define "opencms" do |opencms|

        # hostname
        opencms.vm.hostname = "opencms.cc.de"
        # public network
	opencms.vm.network "public_network", :bridge => "wlan0"
        # private network
	# opencms.vm.network "private_network", ip: "10.0.1.111"
        opencms.vm.provider "opencms" do |opencms|
                opencms.customize ["modifyvm", :id, "--memory", "1024"]
        end

        # Set the Timezone
        config.vm.provision :shell, :inline => "echo \"Europe/Berlin\" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"

        # upgrade puppet
        opencms.vm.provision :shell, :path => "upgrade-puppet.sh"

        # provisioning with puppet
        opencms.vm.provision "puppet" do |puppet|
                puppet.manifests_path = "manifests"
                puppet.manifest_file = "init.pp"
                puppet.module_path = "modules"
#		puppet.options = "--hiera_config /vagrant/files/hiera.yaml"
        end
  end
end
