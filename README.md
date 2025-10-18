# OpenVPN Automation Scripts

This repository provides scripts to automate the setup, configuration, and management of an OpenVPN server using EasyRSA and systemd on Linux.

## Scripts Overview

- **gen-server.sh**: Automates PKI initialization, certificate/key generation, server.conf creation, and starts the OpenVPN server service.
- **gen-client.sh**: Generates a client configuration file (`client.ovpn`) with embedded certificates and keys for easy import into OpenVPN clients.
- **iptables-add.sh**: Adds iptables rules for OpenVPN traffic.
- **iptables-remove.sh**: Removes iptables rules for OpenVPN traffic.

## Environment Configuration

All scripts use environment variables defined in `.envrc`. Edit this file to match your network and server settings:

```sh
export OVPN_PORT=443
export OVPN_PROTO=udp
export OVPN_SUBNET="10.0.0.0 255.255.255.0"
export OVPN_SUBNET_CIDR="10.0.0.0/24"
export LAN_SUBNET="192.168.1.0 255.255.255.0"
export LAN_IFACE=eth0
export EASYRSA_DIR="/tmp/openvpn-ca"
export OVPN_SERVER_DIR="/etc/openvpn/server"
export SERVER_ADDR="your.server.address"
export CLIENT_NAME="myclient"
export SERVICE_FILE="/etc/systemd/system/openvpn-iptables.service"
export SCRIPT_FILE="/etc/openvpn/server/openvpn-iptables.sh"
```

## Usage

1. **Edit `.envrc`**
   - Set all variables to match your environment.

2. **Generate and start OpenVPN server:**
   ```sh
   source .envrc
   sudo ./gen-server.sh
   ```

3. **Generate client configuration:**
   ```sh
   source .envrc
   ./gen-client.sh
   # The file client.ovpn will be created
   ```

4. **Add OpenVPN iptables rules:**
   ```sh
   source .envrc
   sudo ./iptables-add.sh
   ```

5. **Remove OpenVPN iptables rules:**
   ```sh
   source .envrc
   sudo ./iptables-remove.sh
   ```

## Notes
- All scripts assume you have EasyRSA and OpenVPN installed.
- Run scripts as root or with sudo where required (especially for systemd and iptables changes).
- The client configuration (`client.ovpn`) will have all necessary certificates and keys embedded for easy import.
- The iptables rules are set up for NAT and forwarding between the VPN and LAN interfaces.

## Troubleshooting
- If you see errors about missing files, ensure you have run the certificate generation scripts and that your `.envrc` paths are correct.
- If you get iptables errors, check that your `LAN_IFACE` is correct and not quoted in `.envrc`.
- For OpenVPN service issues, check logs with `journalctl -u openvpn-server@server.service`.

## License
MIT

---

*This project was bootstrapped and improved with the help of AI assistance (GitHub Copilot).*
