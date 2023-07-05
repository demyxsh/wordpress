# wordpress
[![demyxsh/wordpress](https://github.com/demyxsh/wordpress/actions/workflows/main.yml/badge.svg)](https://github.com/demyxsh/wordpress/actions/workflows/main.yml)
[![Code Size](https://img.shields.io/github/languages/code-size/demyxsh/wordpress?style=flat&color=blue)](https://github.com/demyxsh/wordpress)
[![Repository Size](https://img.shields.io/github/repo-size/demyxsh/wordpress?style=flat&color=blue)](https://github.com/demyxsh/wordpress)
[![Watches](https://img.shields.io/github/watchers/demyxsh/wordpress?style=flat&color=blue)](https://github.com/demyxsh/wordpress)
[![Stars](https://img.shields.io/github/stars/demyxsh/wordpress?style=flat&color=blue)](https://github.com/demyxsh/wordpress)
[![Forks](https://img.shields.io/github/forks/demyxsh/wordpress?style=flat&color=blue)](https://github.com/demyxsh/wordpress)
[![Docker Pulls](https://img.shields.io/docker/pulls/demyx/wordpress?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![Architecture](https://img.shields.io/badge/linux-amd64-important?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![Alpine](https://img.shields.io/badge/dynamic/json?url=https://github.com/demyxsh/wordpress/raw/master/version.json&label=alpine&query=$.alpine&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![WordPress](https://img.shields.io/badge/dynamic/json?url=https://github.com/demyxsh/wordpress/raw/master/version.json&label=wordpress&query=$.wordpress&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![Bedrock](https://img.shields.io/badge/dynamic/json?url=https://github.com/demyxsh/wordpress/raw/master/version.json&label=bedrock&query=$.bedrock&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![wp-cli](https://img.shields.io/badge/dynamic/json?url=https://github.com/demyxsh/wordpress/raw/master/version.json&label=wp-cli&query=$.wp_cli&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![PHP](https://img.shields.io/badge/dynamic/json?url=https://github.com/demyxsh/wordpress/raw/master/version.json&label=php&query=$.php&color=blue)](https://hub.docker.com/r/demyx/wordpress)
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

## NOTICE
This repository has been moved to the organization [demyxsh](https://github.com/demyxsh); please update the remote URL.
```
git remote set-url origin git@github.com:demyxsh/wordpress.git
```

## Usage
- Configured for remote VPS
- Ports 80 and 443 must be open when using Traefik
- Install the [Nginx Helper](https://wordpress.org/plugins/nginx-helper/) plugin if DEMYX_CACHE is true
- To generate htpasswd: `docker run -it --rm demyx/utilities htpasswd -nb demyx demyx`
- DEMYX_BASIC_AUTH must have double dollar signs ($$)
- Set DEMYX_WORDPRESS env to true to use a WordPress nginx.conf
- DEMYX_WORDPRESS_CONTAINER env must match the container name in your docker-compose.yml

```
# Demyx
# https://demyx.sh
#
# Be sure to change all the domain.tld domains and credentials before running docker-compose up -d.
# For SSL: have a remote server, uncomment all the labels, and set DEMYX_PROTO=https.
# Give it at least 5-10 seconds for Lets Encrypt to provision SSL certificates.
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
      - demyx_db
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
      #- "traefik.http.middlewares.demyx-nx-redirect.redirectregex.permanent=true"
      #- "traefik.http.middlewares.demyx-nx-redirect.redirectregex.regex=^https?:\/\/(?:www\\.)?(.+)"
      #- "traefik.http.middlewares.demyx-nx-redirect.redirectregex.replacement=https://$${1}"
      - "traefik.http.routers.demyx-nx-http.entrypoints=http"
      #- "traefik.http.routers.demyx-nx-http.middlewares=demyx-nx-redirect"
      - "traefik.http.routers.demyx-nx-http.rule=Host(`domain.tld`) || Host(`www.domain.tld`)"
      - "traefik.http.routers.demyx-nx-http.service=demyx-nx-http-port"
      #- "traefik.http.routers.demyx-nx-https.entrypoints=https"
      #- "traefik.http.routers.demyx-nx-https.rule=Host(`domain.tld`) || Host(`www.domain.tld`)" # WordPress https://domain.tld
      #- "traefik.http.routers.demyx-nx-https.service=demyx-nx-https-port"
      #- "traefik.http.routers.demyx-nx-https.tls.certresolver=demyx"
      - "traefik.http.services.demyx-nx-http-port.loadbalancer.server.port=80"
      #- "traefik.http.services.demyx-nx-https-port.loadbalancer.server.port=80"
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
      - "traefik.http.middlewares.traefik-auth.basicauth.users=demyx:$$apr1$$L91z3CIR$$m/BKZcnQGBP.Uo2cJm8I0/" # Password: demyx
      #- "traefik.http.middlewares.traefik-auth-https.basicauth.users=demyx:$$apr1$$L91z3CIR$$m/BKZcnQGBP.Uo2cJm8I0/" # Password: demyx
      #- "traefik.http.middlewares.traefik-redirect.redirectscheme.scheme=https"
      - "traefik.http.routers.traefik-http.entrypoints=http"
      #- "traefik.http.routers.traefik-http.middlewares=traefik-redirect"
      - "traefik.http.routers.traefik-http.middlewares=traefik-auth"
      - "traefik.http.routers.traefik-http.rule=Host(`traefik.domain.tld`)"
      - "traefik.http.routers.traefik-http.service=api@internal"
      - "traefik.http.routers.traefik-http.service=traefik-http-port"
      #- "traefik.http.routers.traefik-https.entrypoints=https"
      #- "traefik.http.routers.traefik-https.middlewares=traefik-auth-https"
      #- "traefik.http.routers.traefik-https.rule=Host(`traefik.domain.tld`)" # https://traefik.domain.tld
      #- "traefik.http.routers.traefik-https.service=api@internal"
      #- "traefik.http.routers.traefik-https.service=traefik-https-port"
      #- "traefik.http.routers.traefik-https.tls.certresolver=demyx"
      - "traefik.http.services.traefik-http-port.loadbalancer.server.port=8080"
      #- "traefik.http.services.traefik-https-port.loadbalancer.server.port=8080"
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
      - demyx_nx
    environment:
      - DEMYX=/demyx
      - DEMYX_CONFIG=/etc/demyx
      - DEMYX_CRON=true
      - DEMYX_CRON_WP_INTERVAL="*/5 * * * *"
      - DEMYX_CRON_LOGROTATE_INTERVAL="0 0 * * *"
      - DEMYX_DB_HOST=demyx_db
      - DEMYX_DB_NAME=demyx
      - DEMYX_DB_PASSWORD=demyx
      - DEMYX_DB_USER=demyx
      - DEMYX_DOMAIN=domain.tld
      - DEMYX_EMERGENCY_RESTART_INTERVAL=1m
      - DEMYX_EMERGENCY_RESTART_THRESHOLD=5
      - DEMYX_LOG=/var/log/demyx
      - DEMYX_LOGROTATE=weekly
      - DEMYX_LOGROTATE_INTERVAL=52
      - DEMYX_MAX_EXECUTION_TIME=300
      - DEMYX_MEMORY=256M
      - DEMYX_OPCACHE=true
      - DEMYX_OPCACHE_ENABLE=1
      - DEMYX_OPCACHE_ENABLE_CLI=1
      - DEMYX_PHP=8.0
      - DEMYX_PM=ondemand
      - DEMYX_PM_MAX_CHILDREN=25
      - DEMYX_PM_MAX_REQUESTS=25000
      - DEMYX_PM_MAX_SPARE_SERVERS=20
      - DEMYX_PM_MIN_SPARE_SERVERS=5
      - DEMYX_PM_PROCESS_IDLE_TIMEOUT=3s
      - DEMYX_PM_START_SERVERS=5
      - DEMYX_PROCESS_CONTROL_TIMEOUT=10s
      - DEMYX_PROTO=http
      - DEMYX_UPLOAD_LIMIT=128M
      - DEMYX_WP_CONFIG=/demyx/wp-config.php
      - DEMYX_WP_EMAIL=info@domain.tld
      - DEMYX_WP_PASSWORD=demyx
      - DEMYX_WP_USERNAME=demyx
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
*A few php extensions added based on the recommendations from [johnbillion/ext](https://github.com/johnbillion/ext). For automatic setup, see my repo: [github.com/demyxsh](https://github.com/demyxsh/demyx).

Extension | Installed
------------- | -------------
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
ssh2 | 1
tokenizer | 1
xml | 1
xmlreader | 1
zlib | 1

## Updates & Support
- Auto built weekly on Saturdays (America/Los_Angeles)
- Rolling release updates
- For support: [#demyx](https://web.libera.chat/?channel=#demyx)
