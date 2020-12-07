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
    /bin/su -c "/usr/bin/curl -sL https://getcomposer.org/installer -o /tmp/composer-setup.php" -s /bin/sh demyx; \
    /usr/local/bin/php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Bedrock
RUN set -ex; \
    # Remove WordPress
    /bin/rm -f "$DEMYX_CONFIG"/wordpress.tgz; \
    /bin/rm -rf "$DEMYX"/*; \
    \
    # Configure Bedrock
    /bin/su -c "/usr/local/bin/composer create-project roots/bedrock /tmp/bedrock; \
        \
        /bin/sed -i 's|\"roots/wordpress\": .*|\"roots/wordpress\": \">1\",|g' /tmp/bedrock/composer.json; \
        \
        cd /tmp/bedrock && /usr/local/bin/composer update; \
        \
        /usr/local/bin/composer clearcache; \
        \
        /bin/cp -r /tmp/bedrock/. ${DEMYX}; \
        \
        /usr/bin/tar -czf ${DEMYX_CONFIG}/bedrock.tgz -C /tmp/bedrock ." -s /bin/sh demyx

# Override WordPress installer
COPY install.sh /usr/local/bin/demyx-install

# Finalize
RUN set -ex; \
    # demyx-install
    /bin/chmod +x /usr/local/bin/demyx-install; \
    \
    # Reset permissions
    /bin/chown -R root:root /usr/local/bin; \
    \
    # Clear /tmp
    /bin/rm -rf /tmp/*

USER demyx
