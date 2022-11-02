FROM alpine

LABEL sh.demyx.image                    demyx/wordpress
LABEL sh.demyx.maintainer               Demyx <info@demyx.sh>
LABEL sh.demyx.url                      https://demyx.sh
LABEL sh.demyx.github                   https://github.com/demyxsh
LABEL sh.demyx.registry                 https://hub.docker.com/u/demyx

# Set default variables
ENV DEMYX                               /demyx
ENV DEMYX_CONFIG                        /etc/demyx
ENV DEMYX_CRON                          true
ENV DEMYX_CRON_WP_INTERVAL              "*/15 * * * *"
ENV DEMYX_CRON_LOGROTATE_INTERVAL       "0 0 * * 0"
ENV DEMYX_DB_HOST                       localhost
ENV DEMYX_DB_NAME                       demyx
ENV DEMYX_DB_PASSWORD                   demyx
ENV DEMYX_DB_USERNAME                   demyx
ENV DEMYX_DOMAIN                        domain.tld
ENV DEMYX_EMERGENCY_RESTART_INTERVAL    1m
ENV DEMYX_EMERGENCY_RESTART_THRESHOLD   5
ENV DEMYX_LOG                           /var/log/demyx
ENV DEMYX_LOGROTATE                     weekly
ENV DEMYX_LOGROTATE_INTERVAL            52
ENV DEMYX_MAX_EXECUTION_TIME            300
ENV DEMYX_MEMORY                        256M
ENV DEMYX_OPCACHE                       true
ENV DEMYX_OPCACHE_ENABLE                1
ENV DEMYX_OPCACHE_ENABLE_CLI            1
ENV DEMYX_PHP                           8.0
ENV DEMYX_PM                            ondemand
ENV DEMYX_PM_MAX_CHILDREN               25
ENV DEMYX_PM_MAX_REQUESTS               25000
ENV DEMYX_PM_MAX_SPARE_SERVERS          20
ENV DEMYX_PM_MIN_SPARE_SERVERS          5
ENV DEMYX_PM_PROCESS_IDLE_TIMEOUT       3s
ENV DEMYX_PM_START_SERVERS              5
ENV DEMYX_PROCESS_CONTROL_TIMEOUT       10s
ENV DEMYX_PROTO                         http
ENV DEMYX_UPLOAD_LIMIT                  128M
ENV DEMYX_WP_CONFIG                     "${DEMYX}/wp-config.php"
ENV DEMYX_WP_EMAIL                      info@domain.tld
ENV DEMYX_WP_PASSWORD                   demyx
ENV DEMYX_WP_USERNAME                   demyx
ENV TZ                                  America/Los_Angeles
# Support for old variables
ENV WORDPRESS_ROOT                      "$DEMYX"
ENV WORDPRESS_CONFIG                    "$DEMYX_CONFIG"
ENV WORDPRESS_LOG                       "$DEMYX_LOG"

# Packages
RUN set -ex; \
    apk add --update --no-cache \
    \
    bash \
    logrotate \
    mariadb-client \
    sed \
    sudo \
    tzdata

# Configure Demyx
RUN set -ex; \
    # Create demyx user
    addgroup -g 1000 -S demyx; \
    adduser -u 1000 -D -S -G demyx demyx; \
    \
    # Create demyx directories
    install -d -m 0755 -o demyx -g demyx "$DEMYX"; \
    install -d -m 0755 -o demyx -g demyx "$DEMYX_CONFIG"; \
    install -d -m 0755 -o demyx -g demyx "$DEMYX_LOG"; \
    \
    # Update .bashrc
    echo 'PS1="$(whoami)@\h:\w \$ "' > /home/demyx/.bashrc; \
    echo 'PS1="$(whoami)@\h:\w \$ "' > /root/.bashrc

# Install PHP and friends
RUN set -ex; \
    apk add --no-cache --update \
    \
    php8 \
    php8-bcmath \
    php8-ctype \
    php8-curl \
    php8-dom \
    php8-exif \
    php8-fileinfo \
    php8-fpm \
    php8-ftp \
    php8-gd \
    php8-iconv \
    php8-json \
    php8-mbstring \
    php8-mysqli \
    php8-opcache \
    php8-openssl \
    php8-pecl-imagick \
    php8-pecl-ssh2 \
    php8-phar \
    php8-posix \
    php8-session \
    php8-simplexml \
    php8-soap \
    php8-sodium \
    php8-sockets \
    php8-tokenizer \
    php8-xml \
    php8-xmlreader \
    php8-xmlwriter \
    php8-zip \
    php8-zlib \
    \
    php81 \
    php81-bcmath \
    php81-ctype \
    php81-curl \
    php81-dom \
    php81-exif \
    php81-fileinfo \
    php81-fpm \
    php81-ftp \
    php81-gd \
    php81-iconv \
    php81-json \
    php81-mbstring \
    php81-mysqli \
    php81-opcache \
    php81-openssl \
    php81-pecl-imagick \
    php81-pecl-ssh2 \
    php81-phar \
    php81-posix \
    php81-session \
    php81-simplexml \
    php81-soap \
    php81-sodium \
    php81-sockets \
    php81-tokenizer \
    php81-xml \
    php81-xmlreader \
    php81-xmlwriter \
    php81-zip \
    php81-zlib

# WordPress
RUN set -ex; \
    su -c "wget https://wordpress.org/latest.tar.gz -qO /tmp/latest.tar.gz; \
    \
    tar -xzf /tmp/latest.tar.gz -C /tmp; \
    \
    mv /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php; \
    \
    cp -r /tmp/wordpress/* ${DEMYX}; \
    \
    tar -czf ${DEMYX_CONFIG}/wordpress.tgz -C /tmp/wordpress ." -s /bin/sh demyx; \
    \
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -qO /usr/local/bin/wp; \
    chmod +x /usr/local/bin/wp

# Imports
COPY bin /usr/local/bin

# Finalize
RUN set -ex; \
    # Configure PHP8*
    ln -sf "$DEMYX_CONFIG"/php.ini /etc/php8/php.ini; \
    ln -sf "$DEMYX_CONFIG"/www.conf /etc/php8/php-fpm.d/www.conf; \
    ln -sf "$DEMYX_CONFIG"/docker.conf /etc/php8/php-fpm.d/docker.conf; \
    ln -sf "$DEMYX_CONFIG"/php.ini /etc/php81/php.ini; \
    ln -sf "$DEMYX_CONFIG"/www.conf /etc/php81/php-fpm.d/www.conf; \
    ln -sf "$DEMYX_CONFIG"/docker.conf /etc/php81/php-fpm.d/docker.conf; \
    \
    # Configure sudo
    echo "demyx ALL=(ALL) NOPASSWD:SETENV: /usr/local/bin/demyx-sudo" > /etc/sudoers.d/demyx; \
    \
    # Set ownership
    chown -R root:root /usr/local/bin; \
    \
    # Clear /tmp
    rm -rf /tmp/*

EXPOSE 9000

WORKDIR "$DEMYX"

USER demyx

ENTRYPOINT ["demyx-entrypoint"]
