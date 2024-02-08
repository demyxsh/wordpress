FROM alpine:3.18

LABEL sh.demyx.image                    demyx/wordpress
LABEL sh.demyx.maintainer               Demyx <info@demyx.sh>
LABEL sh.demyx.url                      https://demyx.sh
LABEL sh.demyx.github                   https://github.com/demyxsh
LABEL sh.demyx.registry                 https://hub.docker.com/u/demyx

# Set default variables
ENV DEMYX                               /demyx
ENV DEMYX_BEDROCK                       false
ENV DEMYX_CONFIG                        /etc/demyx
ENV DEMYX_CRON                          true
ENV DEMYX_CRON_LOGROTATE_INTERVAL       "0 0 * * *"
ENV DEMYX_CRON_WP_INTERVAL              "*/5 * * * *"
ENV DEMYX_DB_HOST                       localhost
ENV DEMYX_DB_NAME                       demyx
ENV DEMYX_DB_PASSWORD                   demyx
ENV DEMYX_DB_USERNAME                   demyx
ENV DEMYX_DOMAIN                        domain.tld
ENV DEMYX_EMERGENCY_RESTART_INTERVAL    1m
ENV DEMYX_EMERGENCY_RESTART_THRESHOLD   5
ENV DEMYX_LOG                           /var/log/demyx
ENV DEMYX_LOGROTATE                     daily
ENV DEMYX_LOGROTATE_INTERVAL            7
ENV DEMYX_LOGROTATE_SIZE                10M
ENV DEMYX_MAX_EXECUTION_TIME            300
ENV DEMYX_MEMORY                        256M
ENV DEMYX_OPCACHE                       true
ENV DEMYX_OPCACHE_ENABLE                1
ENV DEMYX_OPCACHE_ENABLE_CLI            1
ENV DEMYX_PHP                           8.1
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
    apk add --no-cache \
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
    apk add --no-cache \
    \
    php"${DEMYX_PHP//./}" \
    php"${DEMYX_PHP//./}"-bcmath \
    php"${DEMYX_PHP//./}"-ctype \
    php"${DEMYX_PHP//./}"-curl \
    php"${DEMYX_PHP//./}"-dom \
    php"${DEMYX_PHP//./}"-exif \
    php"${DEMYX_PHP//./}"-fileinfo \
    php"${DEMYX_PHP//./}"-fpm \
    php"${DEMYX_PHP//./}"-ftp \
    php"${DEMYX_PHP//./}"-gd \
    php"${DEMYX_PHP//./}"-iconv \
    php"${DEMYX_PHP//./}"-intl \
    php"${DEMYX_PHP//./}"-json \
    php"${DEMYX_PHP//./}"-mbstring \
    php"${DEMYX_PHP//./}"-mysqli \
    php"${DEMYX_PHP//./}"-opcache \
    php"${DEMYX_PHP//./}"-openssl \
    php"${DEMYX_PHP//./}"-pdo \
    php"${DEMYX_PHP//./}"-pdo_mysql \
    php"${DEMYX_PHP//./}"-pecl-imagick \
    php"${DEMYX_PHP//./}"-pecl-ssh2 \
    php"${DEMYX_PHP//./}"-phar \
    php"${DEMYX_PHP//./}"-posix \
    php"${DEMYX_PHP//./}"-session \
    php"${DEMYX_PHP//./}"-simplexml \
    php"${DEMYX_PHP//./}"-soap \
    php"${DEMYX_PHP//./}"-sodium \
    php"${DEMYX_PHP//./}"-sockets \
    php"${DEMYX_PHP//./}"-tokenizer \
    php"${DEMYX_PHP//./}"-xml \
    php"${DEMYX_PHP//./}"-xmlreader \
    php"${DEMYX_PHP//./}"-xmlwriter \
    php"${DEMYX_PHP//./}"-zip \
    php"${DEMYX_PHP//./}"-zlib \
    \
    php82 \
    php82-bcmath \
    php82-ctype \
    php82-curl \
    php82-dom \
    php82-exif \
    php82-fileinfo \
    php82-fpm \
    php82-ftp \
    php82-gd \
    php82-iconv \
    php82-intl \
    php82-json \
    php82-mbstring \
    php82-mysqli \
    php82-opcache \
    php82-openssl \
    php82-pdo \
    php82-pdo_mysql \
    php82-pecl-imagick \
    php82-pecl-ssh2 \
    php82-phar \
    php82-posix \
    php82-session \
    php82-simplexml \
    php82-soap \
    php82-sodium \
    php82-sockets \
    php82-tokenizer \
    php82-xml \
    php82-xmlreader \
    php82-xmlwriter \
    php82-zip \
    php82-zlib

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
    chmod +x /usr/local/bin/wp; \
    \
    su -c "wp package install aaemnnosttv/wp-cli-login-command; \
        wget https://raw.githubusercontent.com/aaemnnosttv/wp-cli-login-command/master/plugin/wp-cli-login-server.php -qO ${DEMYX_CONFIG}/wp-cli-login-server.php" -s /bin/sh demyx

# Imports
COPY bin /usr/local/bin

# Finalize
RUN set -ex; \
    # Configure PHP8*
    ln -sf "$DEMYX_CONFIG"/php.ini /etc/php"${DEMYX_PHP//./}"/php.ini; \
    ln -sf "$DEMYX_CONFIG"/www.conf /etc/php"${DEMYX_PHP//./}"/php-fpm.d/www.conf; \
    ln -sf "$DEMYX_CONFIG"/docker.conf /etc/php"${DEMYX_PHP//./}"/php-fpm.d/docker.conf; \
    ln -sf "$DEMYX_CONFIG"/php.ini /etc/php82/php.ini; \
    ln -sf "$DEMYX_CONFIG"/www.conf /etc/php82/php-fpm.d/www.conf; \
    ln -sf "$DEMYX_CONFIG"/docker.conf /etc/php82/php-fpm.d/docker.conf; \
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
