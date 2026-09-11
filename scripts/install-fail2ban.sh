sudo xbps-install -Sy fail2ban socklog socklog-void daemontools

sudo ln -sf /etc/sv/fail2ban /var/service/
sudo ln -sf /etc/sv/socklog-unix /var/service/
sudo ln -sf /etc/sv/nanoklogd /var/service/

sudo sv status fail2ban
sudo sv status socklog-unix

sudo tee /etc/fail2ban/jail.local > /dev/null << 'EOF'
[DEFAULT]
# Ban time in seconds (1 hour)
bantime = 3600

# Time window to count failures (10 minutes)
findtime = 600

# Number of failures before ban
maxretry = 5

# Ignore your own trusted IPs/networks (add yours here)
ignoreip = 127.0.0.1/8 ::1

# Use nftables/iptables + UFW-friendly action
banaction = iptables-multiport

[sshd]
enabled = true
port = 2222
filter = sshd
logpath = /var/log/socklog/auth/current
maxretry = 3
bantime = 7200
EOF


# sudo sed -i 's|logpath = .*|logpath = /var/log/socklog/auth/current|' /etc/fail2ban/jail.local
