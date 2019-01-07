#!/bin/bash

# update and unzip
dpkg -s unzip &>/dev/null || {
	echo 'Installing unzip and doing the update dance.'
	apt-get -y update && apt-get install -y unzip
}


# install consul
if [ ! -f /home/vagrant/consul ]; then
	echo 'Consul was not previously installed.'
	cd /home/vagrant
	version='0.8.0'
	wget https://releases.hashicorp.com/consul/${version}/consul_${version}_linux_amd64.zip -O consul.zip
	unzip consul.zip
	rm consul.zip

	# make consul executable
	chmod +x consul
fi 

# copy over consul systemd servicefile, if consul.service isn't properly installed
if [ ! -f /etc/systemd/system/consul.service ]; then
	sudo chown vagrant:vagrant consul
	sudo cp consul /usr/local/bin/consul
	cp /vagrant/consul.service /etc/systemd/system/consul.service
	sudo chmod 777 /etc/systemd/system/consul.service
fi

if [ ! -d /etc/systemd/system/consul.d ]; then
	mkdir -p /etc/systemd/system/consul.d/
	mkdir -p /tmp/consul/
fi

echo 'All done!'