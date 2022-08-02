FROM alpine

LABEL sh.demyx.image                    demyx/wordpress
LABEL sh.demyx.maintainer               Demyx <info@demyx.sh>
LABEL sh.demyx.url                      https://demyx.sh
LABEL sh.demyx.github                   https://github.com/demyxsh
LABEL sh.demyx.registry                 https://hub.docker.com/u/demyx

# Set default variables
ENV DEMYX                               /demyx
ENV DEMYX_CONFIG                        /etc/demyx
ENV DEMYX_DB_HOST                       localhost
ENV DEMYX_DB_NAME                       demyx
ENV DEMYX_DB_PASSWORD                   demyx
ENV DEMYX_DB_USER                       demyx
ENV DEMYX_DOMAIN                        localhost
ENV DEMYX_EMERGENCY_RESTART_INTERVAL    1m
ENV DEMYX_EMERGENCY_RESTART_THRESHOLD   5
ENV DEMYX_LOG                           /var/log/demyx
ENV DEMYX_MAX_EXECUTION_TIME            300
ENV DEMYX_MEMORY                        256M
ENV DEMYX_OPCACHE                       true
ENV DEMYX_PHP                           8.0
ENV DEMYX_PM                            ondemand
ENV DEMYX_PM_MAX_CHILDREN               25
ENV DEMYX_PM_MAX_REQUESTS               25000
ENV DEMYX_PM_MAX_SPARE_SERVERS          20
ENV DEMYX_PM_MIN_SPARE_SERVERS          5
ENV DEMYX_PM_PROCESS_IDLE_TIMEOUT       3s
ENV DEMYX_PM_START_SERVERS              5
ENV DEMYX_PROCESS_CONTROL_TIMEOUT       10s
ENV DEMYX_UPLOAD_LIMIT                  128M
ENV DEMYX_WP_CONFIG                     "$DEMYX"/wp-config.php
ENV TZ                                  America/Los_Angeles
# Support for old variables
ENV WORDPRESS_ROOT                      "$DEMYX"
ENV WORDPRESS_CONFIG                    "$DEMYX_CONFIG"
ENV WORDPRESS_LOG                       "$DEMYX_LOG"

# Packages
RUN set -ex; \
    /sbin/apk add --update --no-cache \
        bash \
        ed \
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

# WordPress
RUN set -ex; \
    /bin/su -c "/usr/bin/wget https://wordpress.org/latest.tar.gz -qO /tmp/latest.tar.gz; \
        \
        /usr/bin/tar -xzf /tmp/latest.tar.gz -C /tmp; \
        \
        /bin/mv /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php; \
        \
        /bin/cp -r /tmp/wordpress/* ${DEMYX}; \
        \
        /usr/bin/tar -czf ${DEMYX_CONFIG}/wordpress.tgz -C /tmp/wordpress ." -s /bin/sh demyx

# Imports
COPY --chown=demyx:demyx src "$DEMYX_CONFIG"

# Finalize
RUN set -ex; \
    # Remove php-fpm configs
    /bin/rm -f /usr/local/etc/php-fpm.d/*; \
    \
    # Use our php-fpm configs
    /bin/ln -s "$DEMYX_CONFIG"/php.ini /usr/local/etc/php/php.ini; \
    /bin/ln -s "$DEMYX_CONFIG"/www.conf /usr/local/etc/php-fpm.d/www.conf; \
    /bin/ln -s "$DEMYX_CONFIG"/docker.conf /usr/local/etc/php-fpm.d/docker.conf; \
    \
    # demyx-config
    /bin/cp "$DEMYX_CONFIG"/config.sh /usr/local/bin/demyx-config; \
    /bin/chmod +x /usr/local/bin/demyx-config; \
    \
    # demyx-install
    /bin/cp "$DEMYX_CONFIG"/install.sh /usr/local/bin/demyx-install; \
    /bin/chmod +x /usr/local/bin/demyx-install; \
    \
    # demyx-entrypoint
    /bin/cp "$DEMYX_CONFIG"/entrypoint.sh /usr/local/bin/demyx-entrypoint; \
    /bin/chmod +x /usr/local/bin/demyx-entrypoint; \
    \
    # Set ownership
    /bin/chown -R root:root /usr/local/bin; \
    \
    # Clear /tmp
    /bin/rm -rf /tmp/*

EXPOSE 9000

WORKDIR "$DEMYX"

USER demyx

ENTRYPOINT ["/usr/local/bin/demyx-entrypoint"]
