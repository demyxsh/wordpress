#!/bin/sh
# Demyx
# https://demyx.sh
# https://github.com/peter-evans/dockerhub-description/blob/master/entrypoint.sh
IFS=$'\n\t'

# Get versions
DEMYX_WORDPRESS_ALPINE_VERSION="$(docker exec "$DEMYX_REPOSITORY" cat /etc/os-release | grep VERSION_ID | cut -c 12- | sed -e 's/\r//g')"
DEMYX_WORDPRESS_PHP_VERSION="$(docker exec "$DEMYX_REPOSITORY" php -v | grep cli | awk -F '[ ]' '{print $2}' | sed -e 's/\r//g')"
DEMYX_WORDPRESS_VERSION="$(docker run --rm --volumes-from="$DEMYX_REPOSITORY" --network container:"$DEMYX_REPOSITORY" demyx/"$DEMYX_REPOSITORY":cli core version | sed -e 's/\r//g')"
DEMYX_WORDPRESS_BEDROCK_VERSION="$(curl -sL https://api.github.com/repos/roots/bedrock/releases/latest | grep '"tag_name"' | head -n1 | awk -F '[:]' '{print $2}' | sed -e 's/"//g' | sed -e 's/,//g' | sed -e 's/ //g' | sed -e 's/\r//g')"
DEMYX_WORDPRESS_CLI_VERSION="$(docker run --rm demyx/"$DEMYX_REPOSITORY":cli --version | awk -F '[ ]' '{print $2}' | sed -e 's/\r//g')"

# Replace versions
sed -i "s|alpine-.*.-informational|alpine-${DEMYX_WORDPRESS_ALPINE_VERSION}-informational|g" README.md
sed -i "s|php-.*.-informational|php-${DEMYX_WORDPRESS_PHP_VERSION}-informational|g" README.md
sed -i "s|wordpress-.*.-informational|wordpress-${DEMYX_WORDPRESS_VERSION}-informational|g" README.md
sed -i "s|bedrock-.*.-informational|bedrock-${DEMYX_WORDPRESS_BEDROCK_VERSION}-informational|g" README.md
sed -i "s|wp--cli-.*.-informational|wp--cli-${DEMYX_WORDPRESS_CLI_VERSION}-informational|g" README.md

# Echo version to file
echo "DEMYX_WORDPRESS_ALPINE_VERSION=$DEMYX_WORDPRESS_ALPINE_VERSION
DEMYX_WORDPRESS_PHP_VERSION=$DEMYX_WORDPRESS_PHP_VERSION
DEMYX_WORDPRESS_VERSION=$DEMYX_WORDPRESS_VERSION
DEMYX_WORDPRESS_BEDROCK_VERSION=$DEMYX_WORDPRESS_BEDROCK_VERSION
DEMYX_WORDPRESS_CLI_VERSION=$DEMYX_WORDPRESS_CLI_VERSION" > VERSION

# Push back to GitHub
git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"
git remote set-url origin https://${DEMYX_GITHUB_TOKEN}@github.com/demyxco/"$DEMYX_REPOSITORY".git
# Commit VERSION first
git add VERSION
git commit -m "DEMYX_WORDPRESS_ALPINE_VERSION $DEMYX_WORDPRESS_ALPINE_VERSION, DEMYX_WORDPRESS_PHP_VERSION $DEMYX_WORDPRESS_PHP_VERSION, DEMYX_WORDPRESS_VERSION $DEMYX_WORDPRESS_VERSION, DEMYX_WORDPRESS_BEDROCK_VERSION $DEMYX_WORDPRESS_BEDROCK_VERSION, DEMYX_WORDPRESS_CLI_VERSION $DEMYX_WORDPRESS_CLI_VERSION"
git push origin HEAD:master
# Commit the rest
git add .
git commit -m "Travis Build $TRAVIS_BUILD_NUMBER"
git push origin HEAD:master

# Set the default path to README.md
README_FILEPATH="./README.md"

# Acquire a token for the Docker Hub API
echo "Acquiring token"
TOKEN="$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'$DEMYX_USERNAME'", "password": "'$DEMYX_PASSWORD'"}' https://hub.docker.com/v2/users/login/ | jq -r .token)"

# Send a PATCH request to update the description of the repository
echo "Sending PATCH request"
REPO_URL="https://hub.docker.com/v2/repositories/${DEMYX_USERNAME}/${DEMYX_REPOSITORY}/"
RESPONSE_CODE=$(curl -s --write-out %{response_code} --output /dev/null -H "Authorization: JWT ${TOKEN}" -X PATCH --data-urlencode full_description@${README_FILEPATH} ${REPO_URL})
echo "Received response code: $RESPONSE_CODE"

if [ $RESPONSE_CODE -eq 200 ]; then
  exit 0
else
  exit 1
fi
