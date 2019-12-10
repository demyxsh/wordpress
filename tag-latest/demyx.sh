#!/bin/sh
# Demyx
# https://demyx.sh
set -euo pipefail

# Compatibility with old directory
[[ -d /var/www/html ]] && WORDPRESS_ROOT=/var/www/html

# Install WordPress
demyx-install

# Generate configs
demyx-config

# Run php-fpm in the foreground
php-fpm -F
