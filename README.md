# wordpress
[![Build Status](https://img.shields.io/travis/demyxco/wordpress?style=flat)](https://travis-ci.org/demyxco/wordpress)
[![Docker Pulls](https://img.shields.io/docker/pulls/demyx/wordpress?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![Architecture](https://img.shields.io/badge/linux-amd64-important?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![Alpine](https://img.shields.io/badge/alpine-3.10.3-informational?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![PHP](https://img.shields.io/badge/php-7.3.11-informational?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![WordPress](https://img.shields.io/badge/wordpress-5.3-informational?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![Bedrock](https://img.shields.io/badge/bedrock-1.12.8-informational?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![wp-cli](https://img.shields.io/badge/wp--cli-2.4.0-informational?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
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
ENTRYPOINT | ["dumb-init", "demyx"]
TIMEZONE | America/Los_Angeles

## Updates & Support
[![Code Size](https://img.shields.io/github/languages/code-size/demyxco/wordpress?style=flat&color=blue)](https://github.com/demyxco/wordpress)
[![Repository Size](https://img.shields.io/github/repo-size/demyxco/wordpress?style=flat&color=blue)](https://github.com/demyxco/wordpress)
[![Watches](https://img.shields.io/github/watchers/demyxco/wordpress?style=flat&color=blue)](https://github.com/demyxco/wordpress)
[![Stars](https://img.shields.io/github/stars/demyxco/wordpress?style=flat&color=blue)](https://github.com/demyxco/wordpress)
[![Forks](https://img.shields.io/github/forks/demyxco/wordpress?style=flat&color=blue)](https://github.com/demyxco/wordpress)

- Auto built weekly on Sundays (America/Los_Angeles)
- Rolling release updates
- For support: [#demyx](https://webchat.freenode.net/?channel=#demyx)

## Environment Variables
```
# wordpress

- WORDPRESS_DB_HOST=demyx_db
- WORDPRESS_DB_NAME=demyx
- WORDPRESS_DB_USER=demyx
- WORDPRESS_DB_PASSWORD=demyx
- WORDPRESS_ROOT=/demyx
- WORDPRESS_CONFIG=/etc/demyx
- WORDPRESS_LOG=/var/log/demyx
- WORDPRESS_DOMAIN=domain.tld
- WORDPRESS_UPLOAD_LIMIT=128M
- WORDPRESS_PHP_MEMORY=256M
- WORDPRESS_PHP_MAX_EXECUTION_TIME=300
- WORDPRESS_PHP_OPCACHE=true
- WORDPRESS_PHP_PM=ondemand
- WORDPRESS_PHP_PM_MAX_CHILDREN=100
- WORDPRESS_PHP_PM_START_SERVERS=10
- WORDPRESS_PHP_PM_MIN_SPARE_SERVERS=5
- WORDPRESS_PHP_PM_MAX_SPARE_SERVERS=25
- WORDPRESS_PHP_PM_PROCESS_IDLE_TIMEOUT=5s
- WORDPRESS_PHP_PM_MAX_REQUESTS=500
- TZ=America/Los_Angeles
```
```
# nginx

- WORDPRESS=true
- WORDPRESS_CONTAINER=demyx_wp
- NGINX_ROOT=/demyx
- NGINX_CONFIG=/etc/demyx
- NGINX_LOG=/var/log/demyx
- NGINX_DOMAIN=domain.tld
- NGINX_UPLOAD_LIMIT=128M
- NGINX_CACHE=false
- NGINX_RATE_LIMIT=false
- NGINX_XMLRPC=false
- NGINX_BASIC_AUTH=demyx:$$apr1$$EqJj89Yw$$WLsBIjCILtBGjHppQ76YT1
- TZ=America/Los_Angeles
```

- Install the [Nginx Helper](https://wordpress.org/plugins/nginx-helper/) plugin if NGINX_CACHE is true
- To generate htpasswd: `docker run -it --rm demyx/utilities "htpasswd -nb demyx demyx"`
- NGINX_BASIC_AUTH must have double dollar signs ($$)
- Set WORDPRESS env to true to use a WordPress nginx.conf
- WORDPRESS_CONTAINER env must match the container name in your docker-compose.yml

```
# mariadb

- MARIADB_DATABASE=demyx
- MARIADB_USERNAME=demyx
- MARIADB_PASSWORD=demyx
- MARIADB_ROOT_PASSWORD=demyx # mandatory
- MARIADB_ROOT=/demyx
- MARIADB_CONFIG=/etc/demyx
- MARIADB_LOG=/var/log/demyx
- MARIADB_CHARACTER_SET_SERVER=utf8
- MARIADB_COLLATION_SERVER=utf8_general_ci
- MARIADB_DEFAULT_CHARACTER_SET=utf8
- MARIADB_INNODB_BUFFER_POOL_SIZE=16M
- MARIADB_INNODB_DATA_FILE_PATH=ibdata1:10M:autoextend
- MARIADB_INNODB_FLUSH_LOG_AT_TRX_COMMIT=1
- MARIADB_INNODB_LOCK_WAIT_TIMEOUT=50
- MARIADB_INNODB_LOG_BUFFER_SIZE=8M
- MARIADB_INNODB_LOG_FILE_SIZE=5M
- MARIADB_INNODB_USE_NATIVE_AIO=1
- MARIADB_KEY_BUFFER_SIZE=20M
- MARIADB_MAX_ALLOWED_PACKET=16M
- MARIADB_MAX_CONNECTIONS=151
- MARIADB_MYISAM_SORT_BUFFER_SIZE=8M
- MARIADB_NET_BUFFER_SIZE=8K
- MARIADB_READ_BUFFER=2M
- MARIADB_READ_BUFFER_SIZE=256K
- MARIADB_READ_RND_BUFFER_SIZE=512K
- MARIADB_SERVER_ID=1
- MARIADB_SORT_BUFFER_SIZE=20M
- MARIADB_TABLE_OPEN_CACHE=64
- MARIADB_WRITE_BUFFER=2M
- TZ=America/Los_Angeles
```

## Usage
- Configured for remote VPS
- Ports 80 and 443 must be open when using Traefik
- TLS/SSL enabled by default

```
# Demyx
# https://demyx.sh
#
# Be sure to change all the domain.tld domains and credentials
#
version: "3.7"
services:
  traefik:
    image: traefik
    container_name: demyx_traefik
    restart: unless-stopped
    networks:
      - demyx
    ports:
      - 80:80
      - 443:443
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - demyx_traefik:/demyx
    environment:
      - TRAEFIK_API=true
      - TRAEFIK_PROVIDERS_DOCKER=true
      - TRAEFIK_PROVIDERS_DOCKER_EXPOSEDBYDEFAULT=false
      - TRAEFIK_ENTRYPOINTS_HTTP_ADDRESS=:80
      - TRAEFIK_ENTRYPOINTS_HTTPS_ADDRESS=:443
      - TRAEFIK_CERTIFICATESRESOLVERS_DEMYX_ACME_HTTPCHALLENGE=true
      - TRAEFIK_CERTIFICATESRESOLVERS_DEMYX_ACME_HTTPCHALLENGE_ENTRYPOINT=http
      - TRAEFIK_CERTIFICATESRESOLVERS_DEMYX_ACME_EMAIL=info@domain.tld
      - TRAEFIK_CERTIFICATESRESOLVERS_DEMYX_ACME_STORAGE=/demyx/acme.json
      - TRAEFIK_LOG=true
      - TRAEFIK_LOG_LEVEL=INFO
      - TRAEFIK_LOG_FILEPATH=/demyx/error.log
      - TRAEFIK_ACCESSLOG=true
      - TRAEFIK_ACCESSLOG_FILEPATH=/demyx/access.log
      - TZ=America/Los_Angeles
    labels:
      # traefik https://traefik.domain.tld
      - "traefik.enable=true"
      - "traefik.http.routers.traefik-http.rule=Host(`traefik.domain.tld`)"
      - "traefik.http.routers.traefik-http.service=api@internal"
      - "traefik.http.routers.traefik-http.entrypoints=http"
      - "traefik.http.routers.traefik-http.middlewares=traefik-redirect"
      - "traefik.http.middlewares.traefik-redirect.redirectscheme.scheme=https"
      - "traefik.http.routers.traefik-https.rule=Host(`traefik.domain.tld`)"
      - "traefik.http.routers.traefik-https.entrypoints=https"
      - "traefik.http.routers.traefik-https.service=api@internal"
      - "traefik.http.routers.traefik-https.tls.certresolver=demyx"
      - "traefik.http.routers.traefik-https.middlewares=traefik-auth"
      - "traefik.http.middlewares.traefik-auth.basicauth.users=demyx:$$apr1$$EqJj89Yw$$WLsBIjCILtBGjHppQ76YT1" # Password: demyx
  demyx_db:
    container_name: demyx_db
    image: demyx/mariadb:edge
    restart: unless-stopped
    networks:
      - demyx
    volumes:
      - demyx_db:/demyx
    environment:
      - MARIADB_DATABASE=demyx
      - MARIADB_USERNAME=demyx
      - MARIADB_PASSWORD=demyx
      - MARIADB_ROOT_PASSWORD=demyx # mandatory
      - MARIADB_ROOT=/demyx
      - MARIADB_CONFIG=/etc/demyx
      - MARIADB_LOG=/var/log/demyx
      - MARIADB_CHARACTER_SET_SERVER=utf8
      - MARIADB_COLLATION_SERVER=utf8_general_ci
      - MARIADB_DEFAULT_CHARACTER_SET=utf8
      - MARIADB_INNODB_BUFFER_POOL_SIZE=16M
      - MARIADB_INNODB_DATA_FILE_PATH=ibdata1:10M:autoextend
      - MARIADB_INNODB_FLUSH_LOG_AT_TRX_COMMIT=1
      - MARIADB_INNODB_LOCK_WAIT_TIMEOUT=50
      - MARIADB_INNODB_LOG_BUFFER_SIZE=8M
      - MARIADB_INNODB_LOG_FILE_SIZE=5M
      - MARIADB_INNODB_USE_NATIVE_AIO=1
      - MARIADB_KEY_BUFFER_SIZE=20M
      - MARIADB_MAX_ALLOWED_PACKET=16M
      - MARIADB_MAX_CONNECTIONS=151
      - MARIADB_MYISAM_SORT_BUFFER_SIZE=8M
      - MARIADB_NET_BUFFER_SIZE=8K
      - MARIADB_READ_BUFFER=2M
      - MARIADB_READ_BUFFER_SIZE=256K
      - MARIADB_READ_RND_BUFFER_SIZE=512K
      - MARIADB_SERVER_ID=1
      - MARIADB_SORT_BUFFER_SIZE=20M
      - MARIADB_TABLE_OPEN_CACHE=64
      - MARIADB_WRITE_BUFFER=2M
      - TZ=America/Los_Angeles
  demyx_nginx:
    container_name: demyx_nginx
    image: demyx/nginx
    restart: unless-stopped
    networks:
      - demyx
    volumes:
      - demyx_wp:/demyx
      - demyx_wp_log:/var/log/demyx
    environment:
      - WORDPRESS=true
      - WORDPRESS_CONTAINER=demyx_wp
      - NGINX_ROOT=/demyx
      - NGINX_CONFIG=/etc/demyx
      - NGINX_LOG=/var/log/demyx
      - NGINX_DOMAIN=domain.tld
      - NGINX_UPLOAD_LIMIT=128M
      - NGINX_CACHE=false
      - NGINX_RATE_LIMIT=false
      - NGINX_XMLRPC=false
      - NGINX_BASIC_AUTH=demyx:$$apr1$$EqJj89Yw$$WLsBIjCILtBGjHppQ76YT1
      - TZ=America/Los_Angeles
    labels:
      # wordpress https://domain.tld
      - "traefik.enable=true"
      - "traefik.http.routers.domaintld-http.rule=Host(`domain.tld`) || Host(`www.domain.tld`)"
      - "traefik.http.routers.domaintld-http.entrypoints=http"
      - "traefik.http.routers.domaintld-http.middlewares=domaintld-redirect"
      - "traefik.http.middlewares.domaintld-redirect.redirectscheme.scheme=https"
      - "traefik.http.routers.domaintld-https.rule=Host(`domain.tld`) || Host(`www.domain.tld`)"
      - "traefik.http.routers.domaintld-https.entrypoints=https"
      - "traefik.http.routers.domaintld-https.tls.certresolver=demyx"
  demyx_wp:
    container_name: demyx_wp
    image: demyx/wordpress
    restart: unless-stopped
    networks:
      - demyx
    depends_on:
      - demyx_db
    volumes:
      - demyx_wp:/demyx
      - demyx_wp_log:/var/log/demyx
    environment:
      - WORDPRESS_DB_HOST=demyx_db
      - WORDPRESS_DB_NAME=demyx
      - WORDPRESS_DB_USER=demyx
      - WORDPRESS_DB_PASSWORD=demyx
      - WORDPRESS_ROOT=/demyx
      - WORDPRESS_CONFIG=/etc/demyx
      - WORDPRESS_LOG=/var/log/demyx
      - WORDPRESS_DOMAIN=domain.tld
      - WORDPRESS_UPLOAD_LIMIT=128M
      - WORDPRESS_PHP_MEMORY=256M
      - WORDPRESS_PHP_MAX_EXECUTION_TIME=300
      - WORDPRESS_PHP_OPCACHE=true
      - WORDPRESS_PHP_PM=ondemand
      - WORDPRESS_PHP_PM_MAX_CHILDREN=100
      - WORDPRESS_PHP_PM_START_SERVERS=10
      - WORDPRESS_PHP_PM_MIN_SPARE_SERVERS=5
      - WORDPRESS_PHP_PM_MAX_SPARE_SERVERS=25
      - WORDPRESS_PHP_PM_PROCESS_IDLE_TIMEOUT=5s
      - WORDPRESS_PHP_PM_MAX_REQUESTS=500
      - TZ=America/Los_Angeles
volumes:
  demyx_wp:
    name: demyx_wp
  demyx_wp_log:
    name: demyx_wp_log
  demyx_db:
    name: demyx_db
  demyx_traefik:
    name: demyx_traefik
networks:
  demyx:
    name: demyx
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
