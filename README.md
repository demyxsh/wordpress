# wordpress
[![Build Status](https://img.shields.io/travis/demyxco/wordpress?style=flat)](https://travis-ci.org/demyxco/wordpress)
[![Docker Pulls](https://img.shields.io/docker/pulls/demyx/wordpress?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![Architecture](https://img.shields.io/badge/linux-amd64-important?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![Alpine](https://img.shields.io/badge/alpine-3.13.5-informational?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![PHP](https://img.shields.io/badge/php-7.4.19-informational?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![WordPress](https://img.shields.io/badge/wordpress-5.7.2-informational?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![Bedrock](https://img.shields.io/badge/bedrock--informational?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![wp-cli](https://img.shields.io/badge/wp--cli-2.5.0-informational?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![Buy Me A Coffee](https://img.shields.io/badge/buy_me_coffee-$5-informational?style=flat&color=blue)](https://www.buymeacoffee.com/VXqkQK5tb)
[![Become a Patron!](https://img.shields.io/badge/become%20a%20patron-$5-informational?style=flat&color=blue)](https://www.patreon.com/bePatron?u=23406156)

Non-root Docker image running Alpine Linux, PHP, and WordPress.

DEMYX | WORDPRESS
--- | ---
TAGS | latest bedrock cli
PORT | 9000
USER | demyx
WORKDIR | /demyx
CONFIG | /etc/demyx
ENTRYPOINT | /usr/local/bin/demyx-entrypoint
TIMEZONE | America/Los_Angeles

## Usage
- Configured for remote VPS
- Ports 80 and 443 must be open when using Traefik
- TLS/SSL enabled by default
- Install the [Nginx Helper](https://wordpress.org/plugins/nginx-helper/) plugin if DEMYX_CACHE is true
- To generate htpasswd: `docker run -it --rm demyx/utilities htpasswd -nb demyx demyx`
- DEMYX_BASIC_AUTH must have double dollar signs ($$)
- Set DEMYX_WORDPRESS env to true to use a WordPress nginx.conf
- DEMYX_WORDPRESS_CONTAINER env must match the container name in your docker-compose.yml

```
# Demyx
# https://demyx.sh
#
# This docker-compose.yml is designed for VPS use with SSL/TLS first.
# Traefik requires no additional configurations and is ready to go.
# Be sure to change all the domain.tld domains and credentials before running docker-compose up -d.
#
networks:
  demyx:
    name: demyx
  demyx_socket:
    name: demyx_socket
services:
  demyx_db:
    container_name: demyx_db
    depends_on:
      - demyx_traefik
    environment:
      - DEMYX=/demyx
      - DEMYX_CHARACTER_SET_SERVER=utf8
      - DEMYX_COLLATION_SERVER=utf8_general_ci
      - DEMYX_CONFIG=/etc/demyx
      - DEMYX_DATABASE=demyx
      - DEMYX_DEFAULT_CHARACTER_SET=utf8
      - DEMYX_DOMAIN=domain.tld
      - DEMYX_INNODB_BUFFER_POOL_SIZE=16M
      - DEMYX_INNODB_DATA_FILE_PATH=ibdata1:10M:autoextend
      - DEMYX_INNODB_FILE_PER_TABLE=1
      - DEMYX_INNODB_FLUSH_LOG_AT_TRX_COMMIT=1
      - DEMYX_INNODB_LOCK_WAIT_TIMEOUT=50
      - DEMYX_INNODB_LOG_BUFFER_SIZE=8M
      - DEMYX_INNODB_LOG_FILE_SIZE=5M
      - DEMYX_INNODB_USE_NATIVE_AIO=1
      - DEMYX_KEY_BUFFER_SIZE=20M
      - DEMYX_LOG=/var/log/demyx
      - DEMYX_MAX_ALLOWED_PACKET=16M
      - DEMYX_MAX_CONNECTIONS=1000
      - DEMYX_MYISAM_SORT_BUFFER_SIZE=8M
      - DEMYX_NET_BUFFER_SIZE=8K
      - DEMYX_PASSWORD=demyx
      - DEMYX_READ_BUFFER=2M
      - DEMYX_READ_BUFFER_SIZE=256K
      - DEMYX_READ_RND_BUFFER_SIZE=512K
      - DEMYX_ROOT_PASSWORD=demyx_root  # Mandatory
      - DEMYX_SERVER_ID=1
      - DEMYX_SORT_BUFFER_SIZE=20M
      - DEMYX_TABLE_OPEN_CACHE=64
      - DEMYX_USERNAME=demyx
      - DEMYX_WRITE_BUFFER=2M
      - TZ=America/Los_Angeles
    image: demyx/mariadb
    networks:
      - demyx
    restart: unless-stopped
    volumes:
      - demyx_db:/demyx
      - demyx_log:/var/log/demyx
  demyx_nx:
    container_name: demyx_nx
    depends_on:
      - demyx_wp
    environment:
      - DEMYX=/demyx
      - DEMYX_BASIC_AUTH=false
      - DEMYX_BASIC_AUTH_HTPASSWD=false
      - DEMYX_BEDROCK=false
      - DEMYX_CACHE=false
      - DEMYX_CONFIG=/etc/demyx
      - DEMYX_DOMAIN=domain.tld
      - DEMYX_LOG=/var/log/demyx
      - DEMYX_RATE_LIMIT=false
      - DEMYX_UPLOAD_LIMIT=128M
      - DEMYX_WHITELIST=false
      - DEMYX_WHITELIST_IP=false
      - DEMYX_WHITELIST_TYPE=false
      - DEMYX_WORDPRESS=true
      - DEMYX_WORDPRESS_CONTAINER=demyx_wp
      - DEMYX_WORDPRESS_CONTAINER_PORT=9000
      - DEMYX_XMLRPC=false
      - TZ=America/Los_Angeles
    image: demyx/nginx
    labels:
      - "traefik.enable=true"
      - "traefik.http.middlewares.demyx-nx-redirect.redirectregex.permanent=true"
      - "traefik.http.middlewares.demyx-nx-redirect.redirectregex.regex=^https?:\/\/(?:www\\.)?(.+)"
      - "traefik.http.middlewares.demyx-nx-redirect.redirectregex.replacement=https://$${1}"
      - "traefik.http.routers.demyx-nx-http.entrypoints=http"
      - "traefik.http.routers.demyx-nx-http.middlewares=demyx-nx-redirect"
      - "traefik.http.routers.demyx-nx-http.rule=Host(`domain.tld`) || Host(`www.domain.tld`)"
      - "traefik.http.routers.demyx-nx-http.service=demyx-nx-http-port"
      - "traefik.http.routers.demyx-nx-https.entrypoints=https"
      - "traefik.http.routers.demyx-nx-https.rule=Host(`domain.tld`) || Host(`www.domain.tld`)" # WordPress https://domain.tld
      - "traefik.http.routers.demyx-nx-https.service=demyx-nx-https-port"
      - "traefik.http.routers.demyx-nx-https.tls.certresolver=demyx"
      - "traefik.http.services.demyx-nx-http-port.loadbalancer.server.port=80"
      - "traefik.http.services.demyx-nx-https-port.loadbalancer.server.port=80"
    networks:
      - demyx
    restart: unless-stopped
    volumes:
      - demyx_log:/var/log/demyx
      - demyx_wp:/demyx
  demyx_socket:
    container_name: demyx_socket
    environment:
      - CONTAINERS=1
    image: demyx/docker-socket-proxy
    networks:
      - demyx_socket
    # Uncomment below if your host OS is CentOS/RHEL/Fedora
    #privileged: true
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
  demyx_traefik:
    container_name: demyx_traefik
    depends_on:
      - demyx_socket
    environment:
      # Uncomment below for Cloudflare DNS challenge
      #- CF_API_EMAIL=info@domain.tld
      #- CF_API_KEY=123456
      - DEMYX_ACME_EMAIL=info@domain.tld
      - DEMYX_TRAEFIK_LOG=INFO
      - TRAEFIK_PROVIDERS_DOCKER_ENDPOINT=tcp://demyx_socket:2375
    image: demyx/traefik
    labels:
      - "traefik.enable=true"
      - "traefik.http.middlewares.demyx-traefik-auth.basicauth.users=demyx:$$apr1$$L91z3CIR$$m/BKZcnQGBP.Uo2cJm8I0/" # Basic auth password: demyx
      - "traefik.http.middlewares.demyx-traefik-redirect.redirectscheme.scheme=https"
      - "traefik.http.routers.demyx-traefik-http.entrypoints=http"
      - "traefik.http.routers.demyx-traefik-http.middlewares=demyx-traefik-redirect"
      - "traefik.http.routers.demyx-traefik-http.rule=Host(`traefik.domain.tld`)"
      - "traefik.http.routers.demyx-traefik-http.service=demyx-traefik-http-port"
      - "traefik.http.routers.demyx-traefik-https.entrypoints=https"
      - "traefik.http.routers.demyx-traefik-https.middlewares=demyx-traefik-auth"
      - "traefik.http.routers.demyx-traefik-https.rule=Host(`traefik.domain.tld`)" # Traefik dashboard https://traefik.domain.tld
      - "traefik.http.routers.demyx-traefik-https.service=api@internal"
      - "traefik.http.routers.demyx-traefik-https.service=demyx-traefik-https-port"
      - "traefik.http.routers.demyx-traefik-https.tls.certresolver=demyx"
      - "traefik.http.services.demyx-traefik-http-port.loadbalancer.server.port=8080"
      - "traefik.http.services.demyx-traefik-https-port.loadbalancer.server.port=8080"
    networks:
      - demyx
      - demyx_socket
    ports:
      - 80:8081
      - 443:8082
    restart: unless-stopped
    volumes:
      - demyx_log:/var/log/demyx
      - demyx_traefik:/demyx
  demyx_wp:
    container_name: demyx_wp
    depends_on:
      - demyx_db
    environment:
      - DEMYX=/demyx
      - DEMYX_CONFIG=/etc/demyx
      - DEMYX_DB_HOST=demyx_db
      - DEMYX_DB_NAME=demyx
      - DEMYX_DB_PASSWORD=demyx
      - DEMYX_DB_USER=demyx
      - DEMYX_DOMAIN=domain.tld
      - DEMYX_EMERGENCY_RESTART_INTERVAL=1m
      - DEMYX_EMERGENCY_RESTART_THRESHOLD=5
      - DEMYX_LOG=/var/log/demyx
      - DEMYX_MAX_EXECUTION_TIME=300
      - DEMYX_MEMORY=256M
      - DEMYX_OPCACHE=true
      - DEMYX_PM=ondemand
      - DEMYX_PM_MAX_CHILDREN=25
      - DEMYX_PM_MAX_REQUESTS=25000
      - DEMYX_PM_MAX_SPARE_SERVERS=20
      - DEMYX_PM_MIN_SPARE_SERVERS=5
      - DEMYX_PM_PROCESS_IDLE_TIMEOUT=3s
      - DEMYX_PM_START_SERVERS=5
      - DEMYX_PROCESS_CONTROL_TIMEOUT=10s
      - DEMYX_UPLOAD_LIMIT=128M
      - DEMYX_WP_CONFIG=/demyx/wp-config.php
      - TZ=America/Los_Angeles
    image: demyx/wordpress
    networks:
      - demyx
    restart: unless-stopped
    volumes:
      - demyx_log:/var/log/demyx
      - demyx_wp:/demyx
version: "2.4"
volumes:
  demyx_db:
    name: demyx_db
  demyx_log:
    name: demyx_log
  demyx_traefik:
    name: demyx_traefik
  demyx_wp:
    name: demyx_wp
```

## Extensions
*A few php extensions added based on the recommendations from [johnbillion/ext](https://github.com/johnbillion/ext). For automatic setup, see my repo: [github.com/demyxco](https://github.com/demyxco/demyx).

Extension | Installed
------------- | -------------
ssh2 | 1
curl | 1
date | 1
dom | 1
exif | 1
filter | 1
ftp | 1
gd | 1
hash | 1
iconv | 1
imagick | 1
json | 1
libxml | 1
mbstring | 1
mysqli | 1
openssl | 1
pcre | 1
posix | 1
SimpleXML | 1
sockets | 1
SPL | 1    
tokenizer | 1
xml | 1    
xmlreader | 1
zlib | 1

## Updates & Support
[![Code Size](https://img.shields.io/github/languages/code-size/demyxco/wordpress?style=flat&color=blue)](https://github.com/demyxco/wordpress)
[![Repository Size](https://img.shields.io/github/repo-size/demyxco/wordpress?style=flat&color=blue)](https://github.com/demyxco/wordpress)
[![Watches](https://img.shields.io/github/watchers/demyxco/wordpress?style=flat&color=blue)](https://github.com/demyxco/wordpress)
[![Stars](https://img.shields.io/github/stars/demyxco/wordpress?style=flat&color=blue)](https://github.com/demyxco/wordpress)
[![Forks](https://img.shields.io/github/forks/demyxco/wordpress?style=flat&color=blue)](https://github.com/demyxco/wordpress)

- Auto built weekly on Saturdays (America/Los_Angeles)
- Rolling release updates
- For support: [#demyx](https://webchat.freenode.net/?channel=#demyx)
