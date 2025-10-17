#!/bin/zsh
# Script to install a systemd service for OpenVPN iptables rules

# Create the openvpn-iptables.sh script
cat <<EOSH | tee $SCRIPT_FILE
#!/bin/bash

sleep 10

# Enable IP forwarding (if not already done)
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl -w net.ipv4.ip_forward=1

# Set up NAT for VPN subnet
iptables -t nat -A POSTROUTING -s $OVPN_SUBNET_CIDR -o $LAN_IFACE -j MASQUERADE

# Allow forwarding between VPN and LAN
iptables -A FORWARD -i tun0 -o $LAN_IFACE -j ACCEPT
iptables -A FORWARD -i $LAN_IFACE -o tun0 -j ACCEPT
EOSH

chmod +x $SCRIPT_FILE

# Create the systemd service file
cat <<EOF | tee $SERVICE_FILE
[Unit]
Description=OpenVPN custom iptables rules
After=network-online.target openvpn-server@server.service
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=$SCRIPT_FILE
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable and start the service
systemctl daemon-reload
systemctl enable --now openvpn-iptables.service

echo "Systemd service openvpn-iptables.service installed and started."
