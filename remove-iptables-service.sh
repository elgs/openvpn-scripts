#!/bin/zsh
# Script to remove the OpenVPN iptables systemd service and script

# Stop and disable the systemd service if it exists
if systemctl is-enabled --quiet openvpn-iptables.service; then
  systemctl disable --now openvpn-iptables.service
fi

# Remove the systemd service file
if [ -f "$SERVICE_FILE" ]; then
  rm -f "$SERVICE_FILE"
fi

# Remove the iptables script
if [ -f "$SCRIPT_FILE" ]; then
  rm -f "$SCRIPT_FILE"
fi

# Reload systemd
systemctl daemon-reload

echo "OpenVPN iptables systemd service and script have been removed."
