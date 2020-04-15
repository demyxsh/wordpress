#!/usr/bin/dumb-init /bin/sh
# Demyx
# https://demyx.sh
set -euo pipefail

# Install WordPress
demyx-install

# Generate configs
demyx-config

# Run php-fpm in the foreground
php-fpm -F
