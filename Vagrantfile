Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.hostname = "consul-server"

  serverIp = "192.168.5.25"
  config.vm.network "private_network", ip: serverIp
  config.vm.provision "shell", path: "provision.sh"

  serverInit = %(
  	{
  		"server" : true,
  		"ui" : true,
  		"advertise_addr" : "#{serverIp}",
  		"client_addr" : "#{serverIp}",
  		"data_dir" : "/tmp/consul",
  		"bootstrap_expect" : 1
  	}
  )

  config.vm.provision "shell", inline: "echo '#{serverInit}' > /etc/systemd/system/consul.d/init.json"
  config.vm.provision "shell", inline: "sudo systemctl enable consul"
  config.vm.provision "shell", inline: "sudo systemctl start consul"

end
