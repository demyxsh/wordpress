FROM alpine

LABEL sh.demyx.image demyx/wordpress
LABEL sh.demyx.maintainer Demyx <info@demyx.sh>
LABEL sh.demyx.url https://demyx.sh
LABEL sh.demyx.github https://github.com/demyxco
LABEL sh.demyx.registry https://hub.docker.com/u/demyx

# Set default variables
ENV WORDPRESS_ROOT=/demyx
ENV WORDPRESS_CONFIG=/etc/demyx
ENV WORDPRESS_LOG=/var/log/demyx
ENV TZ=America/Los_Angeles

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
    apk add --no-cache ed dumb-init tzdata libsodium; \
    \
    addgroup -g 1000 -S demyx; \
    adduser -u 1000 -D -S -G demyx demyx

# Download latest WordPress
RUN set -ex; \
    install -d -m 0755 -o demyx -g demyx "$WORDPRESS_ROOT"; \
    \
    wget https://wordpress.org/latest.tar.gz -qO /latest.tar.gz; \
    tar -xzf /latest.tar.gz -C /tmp; \
    rm -f /latest.tar.gz; \
    chown -R demyx:demyx /tmp/wordpress

# Copy files
COPY --chown=demyx:demyx demyx "$WORDPRESS_CONFIG"
COPY demyx.sh /usr/local/bin/demyx

# Finalize
RUN set -ex; \
    install -d -m 0755 -o demyx -g demyx "$WORDPRESS_LOG"; \
    \
    ln -sf "$WORDPRESS_CONFIG"/php.ini /etc/php7/php.ini; \
    ln -sf "$WORDPRESS_CONFIG"/www.conf /etc/php7/php-fpm.d/www.conf; \
    ln -s "$WORDPRESS_CONFIG"/docker.conf /etc/php7/php-fpm.d/docker.conf; \
    \
    chown -R demyx:demyx "$WORDPRESS_ROOT"; \
    \
    mv "$WORDPRESS_CONFIG"/config.sh /usr/local/bin/demyx-config && chmod +x /usr/local/bin/demyx-config; \
    mv "$WORDPRESS_CONFIG"/install.sh /usr/local/bin/demyx-install && chmod +x /usr/local/bin/demyx-install; \
    \
    chmod +x /usr/local/bin/demyx; \
    chown -R root:root /usr/local/bin

EXPOSE 9000

WORKDIR "$WORDPRESS_ROOT"

USER demyx

ENTRYPOINT ["dumb-init", "demyx"]
