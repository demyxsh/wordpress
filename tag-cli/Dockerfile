FROM alpine

LABEL sh.demyx.image        demyx/wordpress:cli
LABEL sh.demyx.maintainer   Demyx <info@demyx.sh>
LABEL sh.demyx.url          https://demyx.sh
LABEL sh.demyx.github       https://github.com/demyxsh
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
    apk add --no-cache \
        bash \
        mysql-client \
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
    php8-zlib

# Install wp-cli
RUN set -ex; \
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -qO /usr/local/bin/wp; \
    chmod +x /usr/local/bin/wp

WORKDIR "$DEMYX"

USER demyx

ENTRYPOINT ["wp"]
