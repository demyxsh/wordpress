FROM alpine

LABEL sh.demyx.image demyx/wordpress:cli
LABEL sh.demyx.maintainer Demyx <info@demyx.sh>
LABEL sh.demyx.url https://demyx.sh
LABEL sh.demyx.github https://github.com/demyxco
LABEL sh.demyx.registry https://hub.docker.com/u/demyx

# Install required packages
RUN set -ex; \
    apk add --no-cache --update php7 php7-phar php7-json php7-mysqli php7-mbstring mysql-client

# Create demyx user
RUN set -ex; \
    addgroup -g 1000 -S demyx; \
    adduser -u 1000 -D -S -G demyx demyx

# Install wp-cli
RUN set -ex; \
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -qO /usr/local/bin/wp; \
    chmod +x /usr/local/bin/wp

WORKDIR /var/www/html

USER demyx

ENTRYPOINT ["wp"]
