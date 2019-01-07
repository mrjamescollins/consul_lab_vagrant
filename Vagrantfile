Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  # config.vm.hostname = "consul-server"

  def create_consul_host(config, hostname, ip, initJson)
    config.vm.define hostname do |host|

                host.vm.hostname = hostname
                host.vm.provision "shell", path: "provision.sh"

                host.vm.network "private_network", ip: ip
                host.vm.provision "shell", inline: "echo '#{initJson}' > /etc/systemd/system/consul.d/init.json"
                host.vm.provision "shell", inline: "sudo systemctl enable consul"
                host.vm.provision "shell", inline: "sudo systemctl start consul"
    end
  end

  serverIp = "192.168.5.25"
#  config.vm.network "private_network", ip: serverIp
#  config.vm.provision "shell", path: "provision.sh"
# really should clean this up for later revisions, leaving as breadcrumbs / old logic

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

  # config.vm.provision "shell", inline: "echo '#{serverInit}' > /etc/systemd/system/consul.d/init.json"
  # config.vm.provision "shell", inline: "sudo systemctl enable consul"
  # config.vm.provision "shell", inline: "sudo systemctl start consul"

  create_consul_host config, "consul-server", serverIp, serverInit

  for which_host in 1..7
    hostname="host-#{which_host}"
    ipAddr="192.168.6.10#{which_host}" # will need to rework this for more than 9 hosts, run out of decimal

    clientConfig = %(
            {
                      "advertise_addr": "#{ipAddr}",
                      "retry_join": ["#{serverIp}"],
                      "data_dir": "/tmp/consul/"
            }
    )

    create_consul_host config, hostname, ipAddr, clientConfig
  end

end
