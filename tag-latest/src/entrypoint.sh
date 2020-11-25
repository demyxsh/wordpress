#!/bin/bash
# Demyx
# https://demyx.sh
set -euo pipefail

# Install WordPress
/usr/local/bin/demyx-install

# Generate configs
/usr/local/bin/demyx-config

# Run php-fpm in the foreground
/usr/local/sbin/php-fpm -F
