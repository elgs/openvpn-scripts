#!/bin/zsh

openvpn --tls-crypt-v2 $OVPN_SERVER_DIR/tls-crypt-v2-master.key --genkey tls-crypt-v2-client $OVPN_SERVER_DIR/${CLIENT_NAME}-tls-crypt-v2.key

cat > $OVPN_SERVER_DIR/client.ovpn <<EOF
client
dev tun
proto $OVPN_PROTO
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

<tls-crypt-v2>
$(cat $OVPN_SERVER_DIR/${CLIENT_NAME}-tls-crypt-v2.key)
</tls-crypt-v2>
EOF

echo "client.ovpn generated with embedded certs and key."
rm -f $OVPN_SERVER_DIR/${CLIENT_NAME}-tls-crypt-v2.key