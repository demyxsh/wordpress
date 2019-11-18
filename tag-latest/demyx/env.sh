#!/bin/bash
# Demyx
# https://demyx.sh

# Domain replacement
if [[ -n "$WORDPRESS_DOMAIN" ]]; then
    sed -i "s|\[www\]|[$WORDPRESS_DOMAIN]|g" /demyx/www.conf
    sed -i "s|\[www\]|[$WORDPRESS_DOMAIN]|g" /demyx/docker.conf
fi

# PHP/NGINX Upload limit
if [[ -n "$WORDPRESS_UPLOAD_LIMIT" ]]; then
    sed -i "s|post_max_size = 128M|post_max_size = $WORDPRESS_UPLOAD_LIMIT|g" /demyx/php.ini
    sed -i "s|upload_max_filesize = 128M|upload_max_filesize = $WORDPRESS_UPLOAD_LIMIT|g" /demyx/php.ini
fi

# PHP max memory limit
if [[ -n "$WORDPRESS_PHP_MEMORY" ]]; then
    sed -i "s|memory_limit = 256M|memory_limit = $WORDPRESS_PHP_MEMORY|g" /demyx/php.ini
fi

# PHP max execution time
if [[ -n "$WORDPRESS_PHP_MAX_EXECUTION_TIME" ]]; then
    sed -i "s|max_execution_time = 300|max_execution_time = $WORDPRESS_PHP_MAX_EXECUTION_TIME|g" /demyx/php.ini
fi

# PHP opcache
if [[ "$WORDPRESS_PHP_OPCACHE" = off || "$WORDPRESS_PHP_OPCACHE" = false ]]; then
    sed -i "s|opcache.enable=1|opcache.enable=0|g" /demyx/php.ini
    sed -i "s|opcache.enable_cli=1|opcache.enable_cli=0|g" /demyx/php.ini
fi

# PHP process manager
if [[ -n "$WORDPRESS_PHP_PM" ]]; then
    sed -i "s|pm = ondemand|pm = $WORDPRESS_PHP_PM|g" /demyx/www.conf
fi

# PHP process manager max children
if [[ -n "$WORDPRESS_PHP_PM_MAX_CHILDREN" ]]; then
    sed -i "s|pm.max_children = 100|pm.max_children = $WORDPRESS_PHP_PM_MAX_CHILDREN|g" /demyx/www.conf
fi

# PHP process manager start servers
if [[ -n "$WORDPRESS_PHP_PM_START_SERVERS" ]]; then
    sed -i "s|pm.start_servers = 2|pm.start_servers = $WORDPRESS_PHP_PM_START_SERVERS|g" /demyx/www.conf
fi

# PHP process manager start servers
if [[ -n "$WORDPRESS_PHP_PM_MIN_SPARE_SERVERS" ]]; then
    sed -i "s|pm.min_spare_servers = 1|pm.min_spare_servers = $WORDPRESS_PHP_PM_MIN_SPARE_SERVERS|g" /demyx/www.conf
fi

# PHP process manager start servers
if [[ -n "$WORDPRESS_PHP_PM_MAX_SPARE_SERVERS" ]]; then
    sed -i "s|pm.max_spare_servers = 3|pm.max_spare_servers = $WORDPRESS_PHP_PM_MAX_SPARE_SERVERS|g" /demyx/www.conf
fi

# PHP process manager start servers
if [[ -n "$WORDPRESS_PHP_PM_PROCESS_IDLE_TIMEOUT" ]]; then
    sed -i "s|pm.process_idle_timeout = 10s|pm.process_idle_timeout = $WORDPRESS_PHP_PM_PROCESS_IDLE_TIMEOUT|g" /demyx/www.conf
fi

# PHP process manager start servers
if [[ -n "$WORDPRESS_PHP_PM_MAX_REQUESTS" ]]; then
    sed -i "s|pm.max_requests = 500|pm.max_requests = $WORDPRESS_PHP_PM_MAX_REQUESTS|g" /demyx/www.conf
fi

# Timezone
if [[ "$TZ" ]]; then
    sed -i "s|UTC|$TZ|g" /demyx/php.ini
fi
