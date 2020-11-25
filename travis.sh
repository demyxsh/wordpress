#!/bin/bash
# Demyx
# https://demyx.sh

# Get versions
DEMYX_WORDPRESS_ALPINE_VERSION="$(/usr/bin/docker exec "$DEMYX_REPOSITORY" /bin/cat /etc/os-release | /bin/grep VERSION_ID | /usr/bin/cut -c 12- | /bin/sed 's/\r//g')"
DEMYX_WORDPRESS_PHP_VERSION="$(/usr/bin/docker exec "$DEMYX_REPOSITORY" /usr/local/bin/php -v | /bin/grep cli | /usr/bin/awk -F '[ ]' '{print $2}' | /bin/sed 's/\r//g')"
DEMYX_WORDPRESS_VERSION="$(/usr/bin/docker run --rm --volumes-from="$DEMYX_REPOSITORY" --network container:"$DEMYX_REPOSITORY" demyx/"$DEMYX_REPOSITORY":cli core version | /bin/sed 's/\r//g')"
DEMYX_WORDPRESS_BEDROCK_VERSION="$(curl -sL https://api.github.com/repos/roots/bedrock/releases/latest | /bin/grep '"tag_name"' | /usr/bin/head -n1 | /usr/bin/awk -F '[:]' '{print $2}' | /bin/sed 's/"//g' | /bin/sed 's/,//g' | /bin/sed 's/ //g' | /bin/sed 's/\r//g')"
DEMYX_WORDPRESS_CLI_VERSION="$(/usr/bin/docker run --rm demyx/"$DEMYX_REPOSITORY":cli --version | /usr/bin/awk -F '[ ]' '{print $2}' | /bin/sed 's/\r//g')"

# Replace versions
/bin/sed -i "s|alpine-.*.-informational|alpine-${DEMYX_WORDPRESS_ALPINE_VERSION}-informational|g" README.md
/bin/sed -i "s|php-.*.-informational|php-${DEMYX_WORDPRESS_PHP_VERSION}-informational|g" README.md
/bin/sed -i "s|wordpress-.*.-informational|wordpress-${DEMYX_WORDPRESS_VERSION}-informational|g" README.md
/bin/sed -i "s|bedrock-.*.-informational|bedrock-${DEMYX_WORDPRESS_BEDROCK_VERSION}-informational|g" README.md
/bin/sed -i "s|wp--cli-.*.-informational|wp--cli-${DEMYX_WORDPRESS_CLI_VERSION}-informational|g" README.md

# Echo version to file
/bin/echo "DEMYX_WORDPRESS_ALPINE_VERSION=$DEMYX_WORDPRESS_ALPINE_VERSION
DEMYX_WORDPRESS_PHP_VERSION=$DEMYX_WORDPRESS_PHP_VERSION
DEMYX_WORDPRESS_VERSION=$DEMYX_WORDPRESS_VERSION
DEMYX_WORDPRESS_BEDROCK_VERSION=$DEMYX_WORDPRESS_BEDROCK_VERSION
DEMYX_WORDPRESS_CLI_VERSION=$DEMYX_WORDPRESS_CLI_VERSION" > VERSION

# Push back to GitHub
/usr/bin/git config --global user.email "travis@travis-ci.com"
/usr/bin/git config --global user.name "Travis CI"
/usr/bin/git remote set-url origin https://"$DEMYX_GITHUB_TOKEN"@github.com/demyxco/"$DEMYX_REPOSITORY".git
# Commit VERSION first
/usr/bin/git add VERSION
/usr/bin/git commit -m "DEMYX_WORDPRESS_ALPINE_VERSION $DEMYX_WORDPRESS_ALPINE_VERSION, DEMYX_WORDPRESS_PHP_VERSION $DEMYX_WORDPRESS_PHP_VERSION, DEMYX_WORDPRESS_VERSION $DEMYX_WORDPRESS_VERSION, DEMYX_WORDPRESS_BEDROCK_VERSION $DEMYX_WORDPRESS_BEDROCK_VERSION, DEMYX_WORDPRESS_CLI_VERSION $DEMYX_WORDPRESS_CLI_VERSION"
/usr/bin/git push origin HEAD:master
# Commit the rest
/usr/bin/git add .
/usr/bin/git commit -m "Travis Build $TRAVIS_BUILD_NUMBER"
/usr/bin/git push origin HEAD:master

# Send a PATCH request to update the description of the repository
/bin/echo "Sending PATCH request"
DEMYX_DOCKER_TOKEN="$(/usr/bin/curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'"$DEMYX_USERNAME"'", "password": "'"$DEMYX_PASSWORD"'"}' "https://hub.docker.com/v2/users/login/" | /usr/local/bin/jq -r .token)"
DEMYX_RESPONSE_CODE="$(/usr/bin/curl -s --write-out "%{response_code}" --output /dev/null -H "Authorization: JWT ${DEMYX_DOCKER_TOKEN}" -X PATCH --data-urlencode full_description@"README.md" "https://hub.docker.com/v2/repositories/${DEMYX_USERNAME}/${DEMYX_REPOSITORY}/")"
/bin/echo "Received response code: $DEMYX_RESPONSE_CODE"

# Return an exit 1 code if response isn't 200
[[ "$DEMYX_RESPONSE_CODE" != 200 ]] && exit 1
