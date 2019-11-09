# wordpress
[![Build Status](https://img.shields.io/travis/demyxco/wordpress?style=flat)](https://travis-ci.org/demyxco/wordpress)
[![Docker Pulls](https://img.shields.io/docker/pulls/demyx/wordpress?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![Architecture](https://img.shields.io/badge/linux-amd64-important?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![Alpine](https://img.shields.io/badge/alpine-3.10.3-informational?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![PHP](https://img.shields.io/badge/php-7.3.11-informational?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![WordPress](https://img.shields.io/badge/wordpress-5.2.4-informational?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![wp-cli](https://img.shields.io/badge/wp--cli-2.3.0-informational?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![Buy Me A Coffee](https://img.shields.io/badge/buy_me_coffee-$5-informational?style=flat&color=blue)](https://www.buymeacoffee.com/VXqkQK5tb)

WordPress is open source software you can use to create a beautiful website, blog, or app.

TITLE | DESCRIPTION
--- | ---
TAGS | latest cli
USER<br />GROUP | demyx (1000)<br />demyx (1000)
WORKDIR | /var/www/html
PORT | 9000
ENTRYPOINT | ["dumb-init", "demyx"]
TIMEZONE | America/Los_Angeles
PHP | /demyx/php.ini<br />/demyx/php-fpm.conf<br />/demyx/docker.conf<br />/demyx/www.conf

## Updates & Support
[![Code Size](https://img.shields.io/github/languages/code-size/demyxco/wordpress?style=flat&color=blue)](https://github.com/demyxco/wordpress)
[![Repository Size](https://img.shields.io/github/repo-size/demyxco/wordpress?style=flat&color=blue)](https://github.com/demyxco/wordpress)
[![Watches](https://img.shields.io/github/watchers/demyxco/wordpress?style=flat&color=blue)](https://github.com/demyxco/wordpress)
[![Stars](https://img.shields.io/github/stars/demyxco/wordpress?style=flat&color=blue)](https://github.com/demyxco/wordpress)
[![Forks](https://img.shields.io/github/forks/demyxco/wordpress?style=flat&color=blue)](https://github.com/demyxco/wordpress)

* Auto built weekly on Sundays (America/Los_Angeles)
* Rolling release updates
* For support: [#demyx](https://webchat.freenode.net/?channel=#demyx)

## WordPress Container
ENVIRONMENT | VARIABLE
--- | ---
WORDPRESS_DB_HOST | db
WORDPRESS_DB_NAME | demyx_db
WORDPRESS_DB_USER | demyx_user
WORDPRESS_DB_PASSWORD | demyx_password
WORDPRESS_DOMAIN | domain.tld
WORDPRESS_UPLOAD_LIMIT | 128M
WORDPRESS_PHP_MEMORY | 256M
WORDPRESS_PHP_MAX_EXECUTION_TIME | 300
WORDPRESS_PHP_OPCACHE | true
TZ | America/Los_Angeles

## NGINX Container
* Install the helper plugin [Nginx Helper](https://wordpress.org/plugins/nginx-helper/) if DEMYX_NGINX_CACHE is "on"
* To generate htpasswd: `docker run -it --rm demyx/utilities "htpasswd -nb demyx demyx"`
* NGINX_BASIC_AUTH must have double dollar signs ($$)
* Set WORDPRESS env to true to use a WordPress nginx.conf
* WORDPRESS_SERVICE env must match service name in your docker-compose.yml

ENVIRONMENT | VARIABLE
--- | ---
WORDPRESS | true
WORDPRESS_CONTAINER | wp
NGINX_DOMAIN | domain.tld
NGINX_UPLOAD_LIMIT | 128M
NGINX_CACHE | false
NGINX_RATE_LIMIT | false
NGINX_BASIC_AUTH | demyx:$$apr1$$EqJj89Yw$$WLsBIjCILtBGjHppQ76YT1<br />(demyx:demyx)
TZ | America/Los_Angeles

## Usage
* Requires no config file for Traefik and is ready to go when running: `docker-compose up -d`
* For SSL/TLS, just remove the comments (#)
* Upgrading from Traefik v1 to v2? You will need to convert your [acme.json](https://github.com/containous/traefik-migration-tool)

```
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
      #- 443:443
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - demyx_traefik:/demyx
    environment:
      - TRAEFIK_API=true
      - TRAEFIK_PROVIDERS_DOCKER=true
      - TRAEFIK_PROVIDERS_DOCKER_EXPOSEDBYDEFAULT=false
      - TRAEFIK_ENTRYPOINTS_HTTP_ADDRESS=:80
      #- TRAEFIK_ENTRYPOINTS_HTTPS_ADDRESS=:443
      ## Only one ACME challenge must be activated at a time
      #- TRAEFIK_CERTIFICATESRESOLVERS_DEMYX_ACME_HTTPCHALLENGE=true
      #- TRAEFIK_CERTIFICATESRESOLVERS_DEMYX_ACME_HTTPCHALLENGE_ENTRYPOINT=http
      #- TRAEFIK_CERTIFICATESRESOLVERS_DEMYX_ACME_DNSCHALLENGE=true
      #- TRAEFIK_CERTIFICATESRESOLVERS_DEMYX_ACME_DNSCHALLENGE_PROVIDER=cloudflare
      #- TRAEFIK_CERTIFICATESRESOLVERS_DEMYX_ACME_DNSCHALLENGE_DELAYBEFORECHECK=0
      #- TRAEFIK_CERTIFICATESRESOLVERS_DEMYX_ACME_DNSCHALLENGE_RESOLVERS=1.1.1.1
      #- CF_API_EMAIL=
      #- CF_API_KEY=
      #- TRAEFIK_CERTIFICATESRESOLVERS_DEMYX_ACME_HTTPCHALLENGE=true
      #- TRAEFIK_CERTIFICATESRESOLVERS_DEMYX_ACME_HTTPCHALLENGE_ENTRYPOINT=http
      #- TRAEFIK_CERTIFICATESRESOLVERS_DEMYX_ACME_EMAIL=info@domain.tld
      #- TRAEFIK_CERTIFICATESRESOLVERS_DEMYX_ACME_STORAGE=/demyx/acme.json
      - TRAEFIK_LOG=true
      - TRAEFIK_LOG_LEVEL=INFO
      - TRAEFIK_LOG_FILEPATH=/demyx/error.log
      - TRAEFIK_ACCESSLOG=true
      - TRAEFIK_ACCESSLOG_FILEPATH=/demyx/access.log
      - TZ=America/Los_Angeles
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.traefik-http.rule=Host(`traefik.domain.tld`)"
      - "traefik.http.routers.traefik-http.service=api@internal"
      - "traefik.http.routers.traefik-http.entrypoints=http"
      #- "traefik.http.routers.traefik-http.middlewares=traefik-redirect"
      #- "traefik.http.routers.traefik-https.rule=Host(`traefik.domain.tld`)"
      #- "traefik.http.routers.traefik-https.entrypoints=https"
      #- "traefik.http.routers.traefik-https.service=api@internal"
      #- "traefik.http.routers.traefik-https.tls.certresolver=demyx"
      #- "traefik.http.routers.traefik-https.middlewares=traefik-auth"
      #- "traefik.http.middlewares.traefik-auth.basicauth.users=demyx:$$apr1$$EqJj89Yw$$WLsBIjCILtBGjHppQ76YT1"
      #- "traefik.http.middlewares.traefik-redirect.redirectscheme.scheme=https"
  db:
    container_name: demyx_db
    image: demyx/mariadb
    restart: unless-stopped
    networks:
      - demyx
    volumes:
      - demyx_db:/var/lib/mysql
    environment:
      - MARIADB_DATABASE=demyx_db
      - MARIADB_USERNAME=demyx_user
      - MARIADB_PASSWORD=demyx_password
      - MARIADB_ROOT_PASSWORD=demyx_root_password # mandatory
      - MARIADB_BINLOG_FORMAT=mixed
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
      - MARIADB_LOG_BIN=mysql-bin
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
  nx:
    container_name: demyx_nginx
    image: demyx/nginx
    restart: unless-stopped
    networks:
      - demyx
    volumes:
      - demyx_wp:/var/www/html
      - demyx_wp_log:/var/log/demyx
    environment:
      - WORDPRESS=true
      - WORDPRESS_CONTAINER=wp
      - WORDPRESS_DOMAIN=domain.tld
      - WORDPRESS_UPLOAD_LIMIT=128M
      - WORDPRESS_CACHE=false
      - WORDPRESS_NGINX_RATE_LIMIT=false
      - WORDPRESS_NGINX_BASIC_AUTH=demyx:$$apr1$$EqJj89Yw$$WLsBIjCILtBGjHppQ76YT1
      - TZ=America/Los_Angeles
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.domaintld-http.rule=Host(`domain.tld`) || Host(`www.domain.tld`)"
      - "traefik.http.routers.domaintld-http.entrypoints=http"
      #- "traefik.http.routers.domaintld-http.middlewares=domaintld-redirect"
      #- "traefik.http.routers.domaintld-https.rule=Host(`domain.tld`) || Host(`www.domain.tld`)"
      #- "traefik.http.routers.domaintld-https.entrypoints=https"
      #- "traefik.http.routers.domaintld-https.tls.certresolver=demyx"
      #- "traefik.http.middlewares.domaintld-redirect.redirectscheme.scheme=https"
  wp:
    container_name: demyx_wp
    image: demyx/wordpress
    restart: unless-stopped
    networks:
      - demyx
    depends_on:
      - db
    volumes:
      - demyx_wp:/var/www/html
      - demyx_wp_log:/var/log/demyx
    environment:
      - WORDPRESS_DB_HOST=db
      - WORDPRESS_DB_NAME=demyx_db
      - WORDPRESS_DB_USER=demyx_user
      - WORDPRESS_DB_PASSWORD=demyx_password
      - WORDPRESS_DOMAIN=domain.tld
      - WORDPRESS_UPLOAD_LIMIT=128M
      - WORDPRESS_PHP_MEMORY=256M
      - WORDPRESS_PHP_MAX_EXECUTION_TIME=300
      - WORDPRESS_PHP_OPCACHE=true
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
