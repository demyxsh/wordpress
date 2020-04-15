FROM demyx/wordpress

LABEL sh.demyx.image        demyx/wordpress:bedrock
LABEL sh.demyx.maintainer   Demyx <info@demyx.sh>
LABEL sh.demyx.url          https://demyx.sh
LABEL sh.demyx.github       https://github.com/demyxco
LABEL sh.demyx.registry     https://hub.docker.com/u/demyx

USER root

# Default bedrock to production
ENV WORDPRESS_BEDROCK_MODE production

# Packages
RUN set -ex; \
    apk add --update --no-cache git

# Composer
RUN set -ex; \
    wget https://getcomposer.org/installer -qO /tmp/composer-setup.php; \
    php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Bedrock
RUN set -ex; \
    # Remove WordPress
    rm -rf "$WORDPRESS_CONFIG"/wordpress; \
    \
    su -c "composer create-project roots/bedrock ${WORDPRESS_CONFIG}/bedrock" -s /bin/sh demyx; \
    \
    # Upgrade WordPress to latest version
    sed -i 's|"roots/wordpress": .*|"roots/wordpress": ">5",|g' "$WORDPRESS_CONFIG"/bedrock/composer.json; \
    \
    su -c "cd ${WORDPRESS_CONFIG}/bedrock && composer update; \
    \
    composer clearcache; \
    \
    tar -czf ${WORDPRESS_CONFIG}/bedrock.tgz -C ${WORDPRESS_CONFIG} bedrock; \
    \
    rm -rf ${WORDPRESS_CONFIG}/bedrock" -s /bin/sh demyx

# Override WordPress installer
COPY install.sh /usr/local/bin/demyx-install

# Finalize
RUN set -ex; \
    chmod +x /usr/local/bin/demyx-install; \
    \
    # Reset permissions
    chown -R root:root /usr/local/bin

USER demyx
