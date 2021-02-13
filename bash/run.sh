#!/bin/bash

service dnsmasq restart
su - zimbra -c "zmcontrol restart"

while true; do
    echo "> Looping..."
sleep 5
done