FROM php:7-fpm-alpine

LABEL sh.demyx.image        demyx/wordpress:cli
LABEL sh.demyx.maintainer   Demyx <info@demyx.sh>
LABEL sh.demyx.url          https://demyx.sh
LABEL sh.demyx.github       https://github.com/demyxco
LABEL sh.demyx.registry     https://hub.docker.com/u/demyx

# Set default variables
ENV DEMYX                   /demyx
ENV DEMYX_CONFIG            /etc/demyx
ENV DEMYX_LOG               /var/log/demyx
ENV TZ                      America/Los_Angeles
# Support for old variables
ENV WORDPRESS_ROOT          "$DEMYX"
ENV WORDPRESS_CONFIG        "$DEMYX_CONFIG"
ENV WORDPRESS_LOG           "$DEMYX_LOG"

# Packages
RUN set -ex; \
    /sbin/apk add --update --no-cache \
        bash \
        mariadb-client \
        tzdata

# Configure Demyx
RUN set -ex; \
    # Create demyx user
    /usr/sbin/addgroup -g 1000 -S demyx; \
    /usr/sbin/adduser -u 1000 -D -S -G demyx demyx; \
    \
    # Create demyx directories
    /usr/bin/install -d -m 0755 -o demyx -g demyx "$DEMYX"; \
    /usr/bin/install -d -m 0755 -o demyx -g demyx "$DEMYX_CONFIG"; \
    /usr/bin/install -d -m 0755 -o demyx -g demyx "$DEMYX_LOG"; \
    \
    # Update .bashrc
    /bin/echo 'PS1="$(whoami)@\h:\w \$ "' > /home/demyx/.bashrc; \
    /bin/echo 'PS1="$(whoami)@\h:\w \$ "' > /root/.bashrc

# Install php extensions
RUN set -ex; \
    /usr/bin/wget https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions -qO /usr/local/bin/install-php-extensions; \
    /bin/chmod uga+x /usr/local/bin/install-php-extensions; \
    /bin/sync; \
    /usr/local/bin/install-php-extensions \
        exif \
        gd \
        imagick \
        mysqli \
        opcache \
        pdo_mysql \
        ssh2 \
        sockets \
        zip

# Install wp-cli
RUN set -ex; \
    /usr/bin/wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -qO /usr/local/bin/wp; \
    /bin/chmod +x /usr/local/bin/wp

WORKDIR "$DEMYX"

USER demyx

ENTRYPOINT ["/usr/local/bin/wp"]
