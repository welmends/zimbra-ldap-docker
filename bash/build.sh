#!/bin/bash

### load config files

touch /tmp/config_entry
cat <<EOF > /tmp/config_entry
AVDOMAIN="zimbra.example.com"
AVUSER="admin@zimbra.example.com"
CREATEADMIN="admin@zimbra.example.com"
CREATEDOMAIN="zimbra.example.com"
DOCREATEADMIN="yes"
DOCREATEDOMAIN="yes"
DOTRAINSA="yes"
EXPANDMENU="no"
HOSTNAME="zimbra.example.com"
HTTPPORT="8080"
HTTPPROXY="TRUE"
HTTPPROXYPORT="80"
HTTPSPORT="8443"
HTTPSPROXYPORT="443"
IMAPPORT="7143"
IMAPPROXYPORT="143"
IMAPSSLPORT="7993"
IMAPSSLPROXYPORT="993"
INSTALL_WEBAPPS="service zimlet zimbra zimbraAdmin"
JAVAHOME="/opt/zimbra/common/lib/jvm/java"
LDAPBESSEARCHSET="set"
LDAPHOST="zimbra.example.com"
LDAPPORT="389"
LDAPREPLICATIONTYPE="master"
LDAPSERVERID="2"
MAILBOXDMEMORY="6389"
MAILPROXY="TRUE"
MODE="https"
MYSQLMEMORYPERCENT="30"
POPPORT="7110"
POPPROXYPORT="110"
POPSSLPORT="7995"
POPSSLPROXYPORT="995"
PROXYMODE="https"
REMOVE="no"
RUNARCHIVING="no"
RUNAV="yes"
RUNCBPOLICYD="no"
RUNDKIM="yes"
RUNSA="yes"
RUNVMHA="no"
SERVICEWEBAPP="yes"
SMTPDEST="admin@zimbra.example.com"
SMTPHOST="zimbra.example.com"
SMTPNOTIFY="yes"
SMTPSOURCE="admin@zimbra.example.com"
SNMPNOTIFY="yes"
SNMPTRAPHOST="zimbra.example.com"
SPELLURL="http://zimbra.example.com:7780/aspell.php"
STARTSERVERS="yes"
STRICTSERVERNAMEENABLED="TRUE"
SYSTEMMEMORY="31.2"
TRAINSAHAM="ham.v_ps7qbur@zimbra.example.com"
TRAINSASPAM="spam.pvduymf54@zimbra.example.com"
UIWEBAPPS="yes"
UPGRADE="yes"
USEEPHEMERALSTORE="no"
USESPELL="yes"
VERSIONUPDATECHECKS="TRUE"
VIRUSQUARANTINE="virus-quarantine.cnxunpmapa@zimbra.example.com"
ZIMBRA_REQ_SECURITY="yes"
ldap_bes_searcher_password="123456"
ldap_dit_base_dn_config="cn=zimbra"
ldap_nginx_password="123456"
mailboxd_directory="/opt/zimbra/mailboxd"
mailboxd_keystore="/opt/zimbra/mailboxd/etc/keystore"
mailboxd_keystore_password="123456"
mailboxd_server="jetty"
mailboxd_truststore="/opt/zimbra/common/lib/jvm/java/lib/security/cacerts"
mailboxd_truststore_password="changeit"
postfix_mail_owner="postfix"
postfix_setgid_group="postdrop"
ssl_default_digest="sha256"
zimbraDNSMasterIP="131.161.224.10 131.161.224.11"
zimbraDNSTCPUpstream="no"
zimbraDNSUseTCP="yes"
zimbraDNSUseUDP="yes"
zimbraFeatureBriefcasesEnabled="Enabled"
zimbraFeatureTasksEnabled="Enabled"
zimbraIPMode="ipv4"
zimbraMailProxy="TRUE"
zimbraMtaMyNetworks="127.0.0.0/8 [::1]/128 "
zimbraPrefTimeZoneId="UTC"
zimbraReverseProxyLookupTarget="TRUE"
zimbraVersionCheckNotificationEmail="admin@zimbra.example.com"
zimbraVersionCheckNotificationEmailFrom="admin@zimbra.example.com"
zimbraVersionCheckSendNotifications="TRUE"
zimbraWebProxy="TRUE"
zimbra_ldap_userdn="uid=zimbra,cn=admins,cn=zimbra"
zimbra_require_interprocess_security="1"
INSTALL_PACKAGES="zimbra-core zimbra-ldap zimbra-logger zimbra-mta zimbra-dnscache zimbra-snmp zimbra-store zimbra-apache zimbra-spell zimbra-memcached zimbra-proxy "
EOF

touch /tmp/key_entry
cat <<EOF > /tmp/key_entry
Y
Y
Y
Y
Y
N
Y
Y
Y
Y
Y
Y
Y
N
Y
Y
EOF

touch /tmp/data.ldif
cat <<EOF > /tmp/data.ldif
dn: uid=user.test,ou=people,dc=zimbra,dc=example,dc=com
objectClass: inetOrgPerson
objectClass: amavisAccount
objectClass: zimbraAccount
ou: people
cn: user
sn: test
zimbraAccountStatus: active
zimbraId: t45t4t45-t4t4-5t4t-45t4-t45t4t45t4t4
mail: user.test@example.com
userPassword: 123456
EOF

mv /etc/dnsmasq.conf /etc/dnsmasq.conf.old
touch /etc/dnsmasq.conf
cat <<EOF >>/etc/dnsmasq.conf
server=8.8.8.8
listen-address=127.0.0.1
domain=example.com
mx-host=example.com,zimbra.example.com,0
address=/zimbra.example.com/$(hostname -i)
EOF

### run build commands

# P.S.: NO PRIVILEGES ON DOCKERFILE (MOVED TO DOCKER-COMPOSE)
# echo ">>> START DNSMASQ SERVICE"
# service dnsmasq restart

echo ">>> INSTALL ZIMBRA"
cd /zcs* && ./install.sh -s < /tmp/key_entry

echo ">>> SETUP ZIMBRA"
/opt/zimbra/libexec/zmsetup.pl -c /tmp/config_entry

echo ">>> RESTART ZIMBRA SERVICES"
su - zimbra -c 'zmcontrol restart'

echo ">>> UPDATE ZIMBRA ADMIN PASSWORD"
su - zimbra -c 'zmprov sp admin@zimbra.example.com 123456'

echo ">>> UPDATE ZIMBRA LDAP PASSWORD"
su - zimbra -c 'zmldappasswd 123456'

echo ">>> CAT ZIMBRA LDAP PASSWORD"
su - zimbra -c 'zmlocalconfig -s zimbra_ldap_password ldap_master_url'

echo ">>> ADD LDAP USER TEST"
su - zimbra -c 'ldapadd -x -D "uid=zimbra,cn=admins,cn=zimbra" -w 123456 -H ldap://zimbra.example.com:389 -f /tmp/data.ldif'

echo ">>> FINISH ZIMBRA DEPLOYMENT"