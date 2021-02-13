# step-by-step installation of zimbra

## Installation

- Run container from ubuntu:bionic image
```shell
sudo docker run -h zimbra.example.com -p 25:25 -p 80:80 -p 389:389 -p 465:465 -p 587:587 -p 110:110 -p 143:143 -p 993:993 -p 995:995 -p 443:443 -p 8080:8080 -p 8443:8443 -p 7071:7071 -p 9071:9071 --name zimbra --privileged -it ubuntu:bionic
```

- Update and install packages:
```shell
apt update && apt -y upgrade && apt install -y nano wget net-tools dnsutils iputils-ping lsb-release gnupg2 dnsmasq
```

- Set /etc/dnsmasq.conf:
```shell
server=8.8.8.8
listen-address=127.0.0.1
domain=example.com
mx-host=example.com,zimbra.example.com,0
address=/zimbra.example.com/$(hostname -i)
```

- Restart dnsmasq service:
```shell
service dnsmasq restart
```

- DNS lookup:
```shell
dig A zimbra.example.com
dig MX example.com
```

- Download zimbra (zcs-8.8.15):
```shell
wget https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_3869.UBUNTU18_64.20190918004220.tgz
tar xvf zcs-8.8.15_GA_3869.UBUNTU18_64.20190918004220.tgz
```

- Install zimbra:
```shell
cd zcs* && ./install.sh
```

- If occurs an error, try again:
```shell
rm -rf /var/lib/dpkg/info/ && mkdir /var/lib/dpkg/info/ && touch /var/lib/dpkg/info/format-new && ./install.sh
```

- Finally, configure ldap password and finish installation.

## Util commands

- Verify zimbra services status
```shell
su - zimbra -c 'zmcontrol status'
```

- Verify ldap configuration:
```shell
su - zimbra -c 'ldapsearch -D "uid=zimbra,cn=admins,cn=zimbra" -x -H ldap://zimbra.example.com:389 -W'
```

- Verify zimbra ldap password
```shell
su - zimbra -c 'zmlocalconfig -s zimbra_ldap_password ldap_master_url'
```

## Alternative (from jorgedlcruz)

- Run container from jorgedlcruz/zimbra image
```shell
docker run -p 25:25 -p 80:80 -p 389:389 -p 465:465 -p 587:587 -p 110:110 -p 143:143 -p 993:993 -p 995:995 -p 443:443 -p 8080:8080 -p 8443:8443 -p 7071:7071 -p 9071:9071 -h zimbra.example.com --name=zimbra --dns 172.17.0.2 --dns 8.8.8.8 -i -t -e PASSWORD=123456 jorgedlcruz/zimbra
```

- Exec bash after the end of installation
```shell
docker exec -it zimbra /bin/bash
```

- Update system in bash
```shell
apt update && apt -y upgrade && exit
```

- Stop container
```shell
docker stop zimbra
```

- Start the container and wait for the end of installation
```shell
docker start zimbra ; docker logs -f zimbra
```

- Enjoy.