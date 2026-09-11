#!/bin/bash 

sudo xbps-install -Sy ufw gufw

# enable ufw service
sudo ln -sf /etc/sv/ufw/ /var/service/

sudo sv status ufw

# setup default rules
sudo ufw default deny incoming
sudo ufw default allow outgoing
#enable inbound ssh traffic.
sudo ufw allow ssh

# enable firewall 
sudo ufw enable
