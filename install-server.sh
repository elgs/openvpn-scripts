#!/bin/zsh

# Clean up old PKI
rm -rf $EASYRSA_DIR
mkdir -p $EASYRSA_DIR
cd $EASYRSA_DIR
rm -rf $EASYRSA_DIR/pki

# Initialize PKI
easyrsa init-pki

# Build CA (no password)
echo | easyrsa build-ca nopass

# Build server cert/key
easyrsa --batch build-server-full myserver nopass

# Build client cert/key
easyrsa --batch build-client-full myclient nopass

# Generate Diffie-Hellman parameters
easyrsa gen-dh

# Copy required files to OpenVPN server directory
cp $EASYRSA_DIR/pki/ca.crt $OVPN_SERVER_DIR/
cp $EASYRSA_DIR/pki/issued/myserver.crt $OVPN_SERVER_DIR/
cp $EASYRSA_DIR/pki/private/myserver.key $OVPN_SERVER_DIR/
cp $EASYRSA_DIR/pki/dh.pem $OVPN_SERVER_DIR/
cp $EASYRSA_DIR/pki/issued/myclient.crt $OVPN_SERVER_DIR/
cp $EASYRSA_DIR/pki/private/myclient.key $OVPN_SERVER_DIR/

# Set permissions
chown openvpn:openvpn $OVPN_SERVER_DIR/*.crt $OVPN_SERVER_DIR/*.key $OVPN_SERVER_DIR/dh.pem
chmod 600 $OVPN_SERVER_DIR/*.key

# Inline server.conf creation using variables
cat > $OVPN_SERVER_DIR/server.conf <<EOF
port ${OVPN_PORT}
proto ${OVPN_PROTO}
dev tun
ca ca.crt
cert myserver.crt
key myserver.key
dh dh.pem
server ${OVPN_SUBNET}
topology subnet
ifconfig-pool-persist ipp.txt
push "dhcp-option DNS 8.8.8.8"
push "redirect-gateway def1 bypass-dhcp ipv6"
push "route ${LAN_SUBNET}"
keepalive 10 120
persist-key
persist-tun
verb 3
EOF

echo "All certificates, keys, and server.conf have been reset and copied."
echo "Update your client.ovpn as needed."

# Enable and start the OpenVPN server service
systemctl enable --now openvpn-server@server.service
echo "OpenVPN server service has been enabled and started."