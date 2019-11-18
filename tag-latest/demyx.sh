#!/bin/bash
# Demyx
# https://demyx.sh

# Install WordPress
/demyx/install.sh

# Execute commands using environment variables
/demyx/env.sh

# Run php-fpm in the foreground
php-fpm -F
