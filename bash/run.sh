#!/bin/bash

mv /etc/dnsmasq.conf /etc/dnsmasq.conf.old
touch /etc/dnsmasq.conf
cat <<EOF >>/etc/dnsmasq.conf
server=8.8.8.8
listen-address=127.0.0.1
domain=example.com
mx-host=example.com,zimbra.example.com,0
address=/zimbra.example.com/$(hostname -i)
EOF

service dnsmasq restart
su - zimbra -c "zmcontrol restart"

while true; do
    echo "> Looping..."
sleep 5
done
