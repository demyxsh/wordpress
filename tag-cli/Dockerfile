FROM alpine

LABEL sh.demyx.image demyx/wordpress:cli
LABEL sh.demyx.maintainer Demyx <info@demyx.sh>
LABEL sh.demyx.url https://demyx.sh
LABEL sh.demyx.github https://github.com/demyxco
LABEL sh.demyx.registry https://hub.docker.com/u/demyx

# Set default variables
ENV WORDPRESS_ROOT=/demyx
ENV WORDPRESS_CONFIG=/etc/demyx
ENV WORDPRESS_LOG=/var/log/demyx
ENV TZ=America/Los_Angeles

# Configure Demyx
RUN set -ex; \
    addgroup -g 1000 -S demyx; \
    adduser -u 1000 -D -S -G demyx demyx; \
    \
    install -d -m 0755 -o demyx -g demyx "$WORDPRESS_ROOT"; \
    install -d -m 0755 -o demyx -g demyx "$WORDPRESS_CONFIG"; \
    install -d -m 0755 -o demyx -g demyx "$WORDPRESS_LOG"

# Install packages
RUN set -ex; \
    apk add --no-cache --update \
    mysql-client \
    php7 \
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
    php7-zlib \
    tzdata

# Install wp-cli
RUN set -ex; \
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -qO /usr/local/bin/wp; \
    chmod +x /usr/local/bin/wp

WORKDIR "$WORDPRESS_ROOT"

USER demyx

ENTRYPOINT ["wp"]
