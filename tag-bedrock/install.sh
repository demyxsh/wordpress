#!/bin/sh
# Demyx
# https://demyx.sh
set -euo pipefail

# Define variables
WORDPRESS_DOMAIN="${WORDPRESS_DOMAIN:-domain.tld}"
WORDPRESS_SSL="${WORDPRESS_SSL:-false}"
WORDPRESS_DB_NAME="${WORDPRESS_DB_NAME:-}"
WORDPRESS_DB_USER="${WORDPRESS_DB_USER:-}"
WORDPRESS_DB_PASSWORD="${WORDPRESS_DB_PASSWORD:-}"
WORDPRESS_DB_HOST="${WORDPRESS_DB_HOST:-}"
WORDPRESS_INSTALL_CHECK="$([[ -f "$WORDPRESS_ROOT"/.env ]] && grep example.com "$WORDPRESS_ROOT"/.env || true)"

if [[ -n "$WORDPRESS_INSTALL_CHECK" || ! -f "$WORDPRESS_ROOT"/.env ]]; then
    echo "[demyx] installing Bedrock..."
    
    if [[ ! -f "$WORDPRESS_ROOT"/.env ]]; then
        tar -xzf "$WORDPRESS_CONFIG"/bedrock.tgz -C "$WORDPRESS_CONFIG"
        cp -r "$WORDPRESS_CONFIG"/bedrock/. "$WORDPRESS_ROOT"
        rm -rf "$WORDPRESS_CONFIG"/bedrock
    fi

    if [[ -n "$WORDPRESS_DB_NAME" && -n "$WORDPRESS_DB_USER" && -n "$WORDPRESS_DB_PASSWORD" && -n "$WORDPRESS_DB_HOST" && -n "$WORDPRESS_DOMAIN" ]]; then
        WORDPRESS_PROTO="http://$WORDPRESS_DOMAIN"
        [[ "$WORDPRESS_SSL" = true ]] && WORDPRESS_PROTO="https://$WORDPRESS_DOMAIN"
        sed -i "s|WP_HOME=.*|WP_HOME=$WORDPRESS_PROTO|g" "$WORDPRESS_ROOT"/.env
        sed -i "s|database_name|$WORDPRESS_DB_NAME|g" "$WORDPRESS_ROOT"/.env
        sed -i "s|database_user|$WORDPRESS_DB_USER|g" "$WORDPRESS_ROOT"/.env
        sed -i "s|database_password|$WORDPRESS_DB_PASSWORD|g" "$WORDPRESS_ROOT"/.env
        sed -i "s|# DB_HOST='localhost'|DB_HOST='$WORDPRESS_DB_HOST'|g" "$WORDPRESS_ROOT"/.env
        SALT="$(wget -qO- https://api.wordpress.org/secret-key/1.1/salt/ | sed "s|define('||g" | sed "s|',|=|g" | sed "s| ||g" | sed "s|);||g")"
        printf '%s\n' "g/generateme/d" a "$SALT" . w | ed -s "$WORDPRESS_ROOT"/.env
        sed -i "s|WP_ENV=.*|WP_ENV=production|g" "$WORDPRESS_ROOT"/.env
    else
        echo "One or more environment variables are missing!"
        exit 1
    fi
fi
