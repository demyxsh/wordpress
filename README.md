# wordpress
[![Build Status](https://img.shields.io/travis/demyxco/wordpress?style=flat)](https://travis-ci.org/demyxco/wordpress)
[![Docker Pulls](https://img.shields.io/docker/pulls/demyx/wordpress?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![Architecture](https://img.shields.io/badge/linux-amd64-important?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![Alpine](https://img.shields.io/badge/alpine-3.10.2-informational?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![PHP](https://img.shields.io/badge/php-7.3.9-informational?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![WordPress](https://img.shields.io/badge/wordpress-5.2.3-informational?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![Buy Me A Coffee](https://img.shields.io/badge/buy_me_coffee-$5-informational?style=flat&color=blue)](https://www.buymeacoffee.com/VXqkQK5tb)

A few php extensions added based on the recommendations from [johnbillion/ext](https://github.com/johnbillion/ext). For automatic setup, see my repo: [github.com/demyxco](https://github.com/demyxco/demyx). 

TITLE | DESCRIPTION
--- | ---
USER<br />GROUP | www-data (82)<br />www-data (82)
WORKDIR | /var/www/html
PORT | 9000
TIMEZONE | America/Los_Angeles
PHP | /etc/php7/php.ini<br />/etc/php7/php-fpm.d/php-fpm.conf

## Updates
[![Code Size](https://img.shields.io/github/languages/code-size/demyxco/wordpress?style=flat&color=blue)](https://github.com/demyxco/wordpress)
[![Repository Size](https://img.shields.io/github/repo-size/demyxco/wordpress?style=flat&color=blue)](https://github.com/demyxco/wordpress)
[![Watches](https://img.shields.io/github/watchers/demyxco/wordpress?style=flat&color=blue)](https://github.com/demyxco/wordpress)
[![Stars](https://img.shields.io/github/stars/demyxco/wordpress?style=flat&color=blue)](https://github.com/demyxco/wordpress)
[![Forks](https://img.shields.io/github/forks/demyxco/wordpress?style=flat&color=blue)](https://github.com/demyxco/wordpress)

* Auto built weekly on Sundays (America/Los_Angeles)
* Rolling release updates

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
WORDPRESS_PHP_OPCACHE | "on"
TZ | America/Los_Angeles

## NGINX Container

* Install the helper plugin [Nginx Helper](https://wordpress.org/plugins/nginx-helper/) if DEMYX_NGINX_CACHE is "on"
* To generate htpasswd: `docker run -it --rm demyx/utilities "htpasswd -nb demyx demyx"`
* DEMYX_BASIC_AUTH must have double dollar signs ($$)
* Set WORDPRESS env to true to use a WordPress nginx.conf
* WORDPRESS_SERVICE env must match service name in your docker-compose.yml

ENVIRONMENT | VARIABLE
--- | ---
WORDPRESS | "true"
WORDPRESS_SERVICE | wp
NGINX_DOMAIN | domain.tld
NGINX_UPLOAD_LIMIT | 128M
NGINX_CACHE | "off"
NGINX_RATE_LIMIT | "off"
NGINX_BASIC_AUTH | demyx:$$apr1$$EqJj89Yw$$WLsBIjCILtBGjHppQ76YT1<br />(demyx:demyx)
TZ | America/Los_Angeles

## Usage
This config requires no .toml for Traefik and is ready to go when running: 
`docker-compose up -d`. If you want SSL, just remove the comments and make sure you have acme.json chmod to 600 (`touch acme.json; chmod 600 acme.json`) before mounting.

```
version: "3.7"

services:
  traefik:
    image: traefik
    container_name: demyx_traefik
    restart: unless-stopped
    command: 
      - --api
      - --api.statistics.recenterrors=100
      - --docker
      - --docker.watch=true
      - --docker.exposedbydefault=false
      - "--entrypoints=Name:http Address::80"
      #- "--entrypoints=Name:https Address::443 TLS"
      - --defaultentrypoints=http
      #- --defaultentrypoints=http,https
      #- --acme
      #- --acme.email=info@domain.tld
      #- --acme.storage=/etc/traefik/acme.json
      #- --acme.entrypoint=https
      #- --acme.onhostrule=true
      #- --acme.httpchallenge.entrypoint=http
      - --logLevel=INFO
      - --accessLog.filePath=/etc/traefik/access.log
      - --traefikLog.filePath=/etc/traefik/traefik.log
    networks:
      - demyx
    ports:
      - 80:80
      #- 443:443
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      #- ./acme.json:/etc/traefik/acme.json # chmod 600
    labels:
      - "traefik.enable=true"
      - "traefik.port=8080"
      - "traefik.frontend.rule=Host:traefik.domain.tld"
      #- "traefik.frontend.redirect.entryPoint=https"
      #- "traefik.frontend.auth.basic.users=${DEMYX_STACK_AUTH}"
      #- "traefik.frontend.headers.forceSTSHeader=true"
      #- "traefik.frontend.headers.STSSeconds=315360000"
      #- "traefik.frontend.headers.STSIncludeSubdomains=true"
      #- "traefik.frontend.headers.STSPreload=true"  
  db:
    container_name: demyx_db
    image: demyx/mariadb
    restart: unless-stopped
    networks:
      - demyx
    volumes:
      - demyx_db:/var/lib/mysql
    environment:
      MARIADB_DATABASE: demyx_db
      MARIADB_USERNAME: demyx_user
      MARIADB_PASSWORD: demyx_password
      MARIADB_ROOT_PASSWORD: demyx_root_password
  nginx:
    container_name: demyx_nginx
    image: demyx/nginx
    restart: unless-stopped
    networks:
      - demyx
    volumes:
      - demyx_wp:/var/www/html
    environment:
      WORDPRESS: "true"
      WORDPRESS_SERVICE: wp
      NGINX_DOMAIN: domain.tld
      NGINX_UPLOAD_LIMIT: 128M
      NGINX_CACHE: "off"
      NGINX_RATE_LIMIT: "off"
      NGINX_BASIC_AUTH: demyx:$$apr1$$EqJj89Yw$$WLsBIjCILtBGjHppQ76YT1
      TZ: America/Los_Angeles
    labels:
      - "traefik.enable=true"
      - "traefik.port=80"
      - "traefik.frontend.rule=Host:domain.tld"
      #- "traefik.frontend.redirect.entryPoint=https"
      #- "traefik.frontend.auth.basic.users=${DEMYX_STACK_AUTH}"
      #- "traefik.frontend.headers.forceSTSHeader=true"
      #- "traefik.frontend.headers.STSSeconds=315360000"
      #- "traefik.frontend.headers.STSIncludeSubdomains=true"
      #- "traefik.frontend.headers.STSPreload=true"
  wp:
    container_name: demyx_wp
    image: demyx/wordpress
    restart: unless-stopped
    networks:
      - demyx
    volumes:
      - demyx_wp:/var/www/html
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_NAME: demyx_db
      WORDPRESS_DB_USER: demyx_user
      WORDPRESS_DB_PASSWORD: demyx_password
      WORDPRESS_DOMAIN: domain.tld
      WORDPRESS_UPLOAD_LIMIT: 128M
      WORDPRESS_PHP_MEMORY: 256M
      WORDPRESS_PHP_MAX_EXECUTION_TIME: 300
      WORDPRESS_PHP_OPCACHE: "on"
      TZ: America/Los_Angeles
volumes:
  demyx_wp:
    name: demyx_wp
  demyx_db:
    name: demyx_db
networks:
  demyx:
    name: demyx
```

## Extensions
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
