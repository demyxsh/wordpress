FROM demyx/wordpress

LABEL sh.demyx.image            demyx/wordpress:bedrock
LABEL sh.demyx.maintainer       Demyx <info@demyx.sh>
LABEL sh.demyx.url              https://demyx.sh
LABEL sh.demyx.github           https://github.com/demyxsh
LABEL sh.demyx.registry         https://hub.docker.com/u/demyx

USER root

# Default bedrock to production
ENV DEMYX_BEDROCK_MODE          production
ENV DEMYX_SSL                   false
# Support for old variables
ENV WORDPRESS_BEDROCK_MODE      "$DEMYX_BEDROCK_MODE"

# Packages
RUN set -ex; \
    apk add --update --no-cache git

# Composer
RUN set -ex; \
    su -c "wget https://getcomposer.org/installer -qO /tmp/composer-setup.php" -s /bin/sh demyx; \
    php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Bedrock
RUN set -ex; \
    # Remove WordPress
    rm -f "$DEMYX_CONFIG"/wordpress.tgz; \
    rm -rf "$DEMYX"/*; \
    \
    # Configure Bedrock
    su -c "composer create-project roots/bedrock /tmp/bedrock; \
        \
        sed -i 's|\"roots/wordpress\": .*|\"roots/wordpress\": \">1\",|g' /tmp/bedrock/composer.json; \
        \
        cd /tmp/bedrock && composer update; \
        \
        composer clearcache; \
        \
        cp -r /tmp/bedrock/. ${DEMYX}; \
        \
        tar -czf ${DEMYX_CONFIG}/bedrock.tgz -C /tmp/bedrock ." -s /bin/sh demyx

# Override WordPress installer
COPY bin /usr/local/bin

# Finalize
RUN set -ex; \
    # Reset permissions
    chown -R root:root /usr/local/bin; \
    \
    # Clear /tmp
    rm -rf /tmp/*

USER demyx
