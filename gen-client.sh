#!/bin/zsh

cat > client.ovpn <<EOF
client
dev tun
proto tcp
remote $SERVER_ADDR $OVPN_PORT
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
verb 3

<ca>
$(cat $OVPN_SERVER_DIR/ca.crt)
</ca>

<cert>
$(cat $OVPN_SERVER_DIR/${CLIENT_NAME}.crt)
</cert>

<key>
$(cat $OVPN_SERVER_DIR/${CLIENT_NAME}.key)
</key>
EOF

echo "client.ovpn generated with embedded certs and key."