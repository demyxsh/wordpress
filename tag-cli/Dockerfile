FROM php:fpm-alpine

LABEL sh.demyx.image        demyx/wordpress:cli
LABEL sh.demyx.maintainer   Demyx <info@demyx.sh>
LABEL sh.demyx.url          https://demyx.sh
LABEL sh.demyx.github       https://github.com/demyxco
LABEL sh.demyx.registry     https://hub.docker.com/u/demyx

# Set default variables
ENV WORDPRESS_ROOT          /demyx
ENV WORDPRESS_CONFIG        /etc/demyx
ENV WORDPRESS_LOG           /var/log/demyx
ENV TZ                      America/Los_Angeles

# Configure Demyx
RUN set -ex; \
    addgroup -g 1000 -S demyx; \
    adduser -u 1000 -D -S -G demyx demyx; \
    \
    install -d -m 0755 -o demyx -g demyx "$WORDPRESS_ROOT"; \
    install -d -m 0755 -o demyx -g demyx "$WORDPRESS_CONFIG"; \
    install -d -m 0755 -o demyx -g demyx "$WORDPRESS_LOG"

# Install package(s) and php extensions
RUN set -ex; \
    wget https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions -qO /usr/local/bin/install-php-extensions; \
    chmod uga+x /usr/local/bin/install-php-extensions; \
    sync; \
    install-php-extensions exif gd imagick mysqli opcache pdo_mysql ssh2 sockets zip; \
    \
    apk add --no-cache tzdata

# Install wp-cli
RUN set -ex; \
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -qO /usr/local/bin/wp; \
    chmod +x /usr/local/bin/wp

WORKDIR "$WORDPRESS_ROOT"

USER demyx

ENTRYPOINT ["wp"]
