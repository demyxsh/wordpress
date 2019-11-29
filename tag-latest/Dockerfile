FROM alpine

LABEL sh.demyx.image demyx/wordpress
LABEL sh.demyx.maintainer Demyx <info@demyx.sh>
LABEL sh.demyx.url https://demyx.sh
LABEL sh.demyx.github https://github.com/demyxco
LABEL sh.demyx.registry https://hub.docker.com/u/demyx

# Set default timezone
ENV TZ America/Los_Angeles

# Install php and friends
RUN set -ex; \
    apk add --no-cache php7 \
    php7-bcmath \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-exif \
    php7-fileinfo \
    php7-fpm \
    php7-ftp \
    php7-gd \
    php7-iconv \
    php7-imagick \
    php7-json \
    php7-mbstring \
    php7-mysqli \
    php7-opcache \
    php7-openssl \
    php7-pecl-ssh2 \
    php7-phar \
    php7-posix \
    php7-session \
    php7-simplexml \
    php7-soap \
    php7-sodium \
    php7-sockets \
    php7-tokenizer \
    php7-xml \
    php7-xmlreader \
    php7-xmlwriter \
    php7-zip \
    php7-zlib; \
    \
    ln -s /usr/sbin/php-fpm7 /usr/local/bin/php-fpm

# Install additional packages and create demyx user
RUN set -ex; \
    apk add --no-cache ed dumb-init bash tzdata libsodium curl; \
    addgroup -g 1000 -S demyx; \
    adduser -u 1000 -D -S -G demyx demyx

# Download latest WordPress
RUN set -ex; \
    mkdir -p /usr/src; \
    mkdir -p /var/www/html; \
    wget https://wordpress.org/latest.tar.gz -qO /usr/src/latest.tar.gz; \
    tar -xzf /usr/src/latest.tar.gz -C /usr/src; \
    rm /usr/src/latest.tar.gz; \
    chown -R demyx:demyx /usr/src/wordpress; \
    chown -R demyx:demyx /var/www/html

# Copy core files
COPY demyx /demyx
COPY demyx.sh /usr/local/bin/demyx

# Finalize
RUN set -ex; \
    mkdir -p /var/log/demyx; \
    ln -sf /demyx/php.ini /etc/php7/php.ini; \
    ln -sf /demyx/www.conf /etc/php7/php-fpm.d/www.conf; \
    ln -s /demyx/docker.conf /etc/php7/php-fpm.d/docker.conf; \
    chown demyx:demyx /var/log/demyx; \
    chown -R demyx:demyx /demyx; \
    mv /demyx/config.sh /usr/local/bin/demyx-config && chmod +x /usr/local/bin/demyx-config; \
    mv /demyx/install.sh /usr/local/bin/demyx-install && chmod +x /usr/local/bin/demyx-install; \
    chmod +x /usr/local/bin/demyx

EXPOSE 9000

WORKDIR /var/www/html

USER demyx

ENTRYPOINT ["dumb-init", "demyx"]
