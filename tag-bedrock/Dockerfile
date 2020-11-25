FROM demyx/wordpress

LABEL sh.demyx.image            demyx/wordpress:bedrock
LABEL sh.demyx.maintainer       Demyx <info@demyx.sh>
LABEL sh.demyx.url              https://demyx.sh
LABEL sh.demyx.github           https://github.com/demyxco
LABEL sh.demyx.registry         https://hub.docker.com/u/demyx

USER root

# Default bedrock to production
ENV DEMYX_BEDROCK_MODE          production
ENV DEMYX_SSL                   false
# Support for old variables
ENV WORDPRESS_BEDROCK_MODE      "$DEMYX_BEDROCK_MODE"

# Packages
RUN set -ex; \
    /sbin/apk add --update --no-cache \
        git

# Composer
RUN set -ex; \
    /usr/bin/curl -sL https://getcomposer.org/installer -o /tmp/composer-setup.php; \
    /usr/local/bin/php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
    \
    /bin/rm -rf /tmp/*

# Bedrock
RUN set -ex; \
    # Remove WordPress
    /bin/rm -rf "$DEMYX_CONFIG"/wordpress; \
    /bin/rm -rf "$DEMYX"/*; \
    \
    /bin/su -c "/usr/local/bin/composer create-project roots/bedrock ${DEMYX_CONFIG}/bedrock" -s /bin/sh demyx; \
    \
    # Upgrade WordPress to latest version
    /bin/sed -i 's|"roots/wordpress": .*|"roots/wordpress": ">5",|g' "$DEMYX_CONFIG"/bedrock/composer.json; \
    \
    /bin/su -c "cd ${DEMYX_CONFIG}/bedrock && /usr/local/bin/composer update; \
    \
    /usr/local/bin/composer clearcache" -s /bin/sh demyx; \
    \
    /bin/cp -r "$DEMYX_CONFIG"/bedrock/. "$DEMYX"; \
    /bin/chown -R demyx:demyx "$DEMYX"

# Override WordPress installer
COPY install.sh /usr/local/bin/demyx-install

# Finalize
RUN set -ex; \
    /bin/chmod +x /usr/local/bin/demyx-install; \
    \
    # Reset permissions
    /bin/chown -R root:root /usr/local/bin

USER demyx
