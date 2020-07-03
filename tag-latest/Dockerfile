FROM php:fpm-alpine

LABEL sh.demyx.image        demyx/wordpress
LABEL sh.demyx.maintainer   Demyx <info@demyx.sh>
LABEL sh.demyx.url          https://demyx.sh
LABEL sh.demyx.github       https://github.com/demyxco
LABEL sh.demyx.registry     https://hub.docker.com/u/demyx

# Set default variables
ENV WORDPRESS_ROOT                              /demyx
ENV WORDPRESS_CONFIG                            /etc/demyx
ENV WORDPRESS_LOG                               /var/log/demyx
ENV WORDPRESS_DOMAIN                            localhost
ENV WORDPRESS_UPLOAD_LIMIT                      128M
ENV WORDPRESS_PHP_MEMORY                        256M
ENV WORDPRESS_PHP_MAX_EXECUTION_TIME            300
ENV WORDPRESS_PHP_OPCACHE                       true
ENV WORDPRESS_PHP_PM                            ondemand
ENV WORDPRESS_PHP_PM_MAX_CHILDREN               25
ENV WORDPRESS_PHP_PM_START_SERVERS              5
ENV WORDPRESS_PHP_PM_MIN_SPARE_SERVERS          5
ENV WORDPRESS_PHP_PM_MAX_SPARE_SERVERS          20
ENV WORDPRESS_PHP_PM_PROCESS_IDLE_TIMEOUT       3s
ENV WORDPRESS_PHP_PM_MAX_REQUESTS               25000
ENV WORDPRESS_PHP_EMERGENCY_RESTART_THRESHOLD   5
ENV WORDPRESS_PHP_EMERGENCY_RESTART_INTERVAL    1m
ENV WORDPRESS_PHP_PROCESS_CONTROL_TIMEOUT       10s
ENV TZ                                          America/Los_Angeles

# Configure Demyx
RUN set -ex; \
    addgroup -g 1000 -S demyx; \
    adduser -u 1000 -D -S -G demyx demyx; \
    \
    install -d -m 0755 -o demyx -g demyx "$WORDPRESS_ROOT"; \
    install -d -m 0755 -o demyx -g demyx "$WORDPRESS_CONFIG"; \
    install -d -m 0755 -o demyx -g demyx "$WORDPRESS_LOG"

# Install php extensions
RUN set -ex; \
    wget https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions -qO /usr/local/bin/install-php-extensions; \
    chmod uga+x /usr/local/bin/install-php-extensions; \
    sync; \
    install-php-extensions exif gd imagick mysqli opcache pdo_mysql ssh2 sockets zip 

# Main packages
RUN set -ex; \
    apk add --no-cache ed dumb-init tzdata

# Download latest WordPress
RUN set -ex; \
    wget https://wordpress.org/latest.tar.gz -qO /latest.tar.gz; \
    tar -xzf /latest.tar.gz -C "$WORDPRESS_CONFIG"; \
    cp -r "$WORDPRESS_CONFIG"/wordpress/* "$WORDPRESS_ROOT"; \
    rm -f /latest.tar.gz; \
    chown -R demyx:demyx "$WORDPRESS_CONFIG"; \
    chown -R demyx:demyx "$WORDPRESS_ROOT"

# Copy source
COPY --chown=demyx:demyx src "$WORDPRESS_CONFIG"

# Finalize
RUN set -ex; \
    # Remove php-fpm configs
    rm -f /usr/local/etc/php-fpm.d/*; \
    \
    # Use our php-fpm configs
    ln -s "$WORDPRESS_CONFIG"/php.ini /usr/local/etc/php/php.ini; \
    ln -s "$WORDPRESS_CONFIG"/www.conf /usr/local/etc/php-fpm.d/www.conf; \
    ln -s "$WORDPRESS_CONFIG"/docker.conf /usr/local/etc/php-fpm.d/docker.conf; \
    \
    # demyx-config
    chmod +x "$WORDPRESS_CONFIG"/config.sh; \
    mv "$WORDPRESS_CONFIG"/config.sh /usr/local/bin/demyx-config; \
    \
    # demyx-install
    chmod +x "$WORDPRESS_CONFIG"/install.sh; \
    mv "$WORDPRESS_CONFIG"/install.sh /usr/local/bin/demyx-install; \
    \
    # demyx-entrypoint
    chmod +x "$WORDPRESS_CONFIG"/entrypoint.sh; \
    mv "$WORDPRESS_CONFIG"/entrypoint.sh /usr/local/bin/demyx-entrypoint; \
    \
    # Reset permissions
    chown -R root:root /usr/local/bin

EXPOSE 9000

WORKDIR "$WORDPRESS_ROOT"

USER demyx

ENTRYPOINT ["demyx-entrypoint"]
