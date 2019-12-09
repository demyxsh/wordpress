FROM demyx/wordpress

LABEL sh.demyx.image demyx/wordpress:bedrock
LABEL sh.demyx.maintainer Demyx <info@demyx.sh>
LABEL sh.demyx.url https://demyx.sh
LABEL sh.demyx.github https://github.com/demyxco
LABEL sh.demyx.registry https://hub.docker.com/u/demyx

USER root

# Default bedrock to production
ENV WORDPRESS_BEDROCK_MODE=production

# Packages
RUN set -ex; \
    apk add --update --no-cache composer git

# Install Bedrock
RUN set -ex; \
    rm -rf /tmp/*; \
    su -c 'composer create-project roots/bedrock /tmp/bedrock; composer clearcache' -s /bin/sh demyx; \
    tar -czf /tmp/bedrock.tgz -C /tmp bedrock; \
    rm -rf /tmp/bedrock

# Override WordPress installer
COPY install.sh /usr/local/bin/demyx-install

# Finalize
RUN set -ex; \
    chmod +x /usr/local/bin/demyx-install

USER demyx
