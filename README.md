# Zimbra with LDAP in Docker (ubuntu bionic)

## Load zimbra-docker image from zimbra-docker.tar
```shell
docker load < zimbra_docker.tar
```

## Deploy
```shell
docker-compose up -d
```

## Run container
```shell
docker run -p 80:80 -p 10389:389 -p 7071:7071 -h zimbra.example.com --name zimbra --privileged -it zimbra-docker
```

## Access container
```shell
sudo docker exec -it zimbra bash
```

## Zimbra authentication

- Access https://localhost:7071
- Login: admin
- Password: 123456

## LDAP authentication (simple authentication)

- Access Apache DS
- hostname: localhost
- port: 10389
- bind DN: uid=zimbra,cn=admins,cn=zimbra
- password: 123456