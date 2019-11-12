#!/bin/bash
# Demyx
# https://demyx.sh

if [[ ! -d /var/www/html/wp-admin ]]; then
    echo "WordPress is missing, installing now."
    cp -r /usr/src/wordpress/* /var/www/html

    if [[ "$WORDPRESS_DB_NAME" && "$WORDPRESS_DB_USER" && "$WORDPRESS_DB_PASSWORD" && "$WORDPRESS_DB_HOST" ]]; then
        mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
        sed -i "s/database_name_here/$WORDPRESS_DB_NAME/g" /var/www/html/wp-config.php
        sed -i "s/username_here/$WORDPRESS_DB_USER/g" /var/www/html/wp-config.php
        sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/g" /var/www/html/wp-config.php
        sed -i "s/localhost/$WORDPRESS_DB_HOST/g" /var/www/html/wp-config.php 
        SALT=$(curl -sL https://api.wordpress.org/secret-key/1.1/salt/)
        printf '%s\n' "g/put your unique phrase here/d" a "$SALT" . w | ed -s /var/www/html/wp-config.php
        sed -i "s/$table_prefix = 'wp_';/$table_prefix = 'wp_';\n\n\/\/ If we're behind a proxy server and using HTTPS, we need to alert Wordpress of that fact\n\/\/ see also http:\/\/codex.wordpress.org\/Administration_Over_SSL#Using_a_Reverse_Proxy\nif (isset($\_SERVER['HTTP_X_FORWARDED_PROTO']) \&\& $\_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {\n\t$\_SERVER['HTTPS'] = 'on';\n}\n/g" /var/www/html/wp-config.php
    else
        echo "One or more environment variables are missing! Exiting ... "
        exit 1
    fi
fi

# Set permissions and ownership
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;
chown -R demyx:demyx /var/www/html

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

php-fpm -F
