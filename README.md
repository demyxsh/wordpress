# wordpress
[![demyxsh/wordpress](https://github.com/demyxsh/wordpress/actions/workflows/main.yml/badge.svg)](https://github.com/demyxsh/wordpress/actions/workflows/main.yml)
[![Code Size](https://img.shields.io/github/languages/code-size/demyxsh/wordpress?style=flat&color=blue)](https://github.com/demyxsh/wordpress)
[![Repository Size](https://img.shields.io/github/repo-size/demyxsh/wordpress?style=flat&color=blue)](https://github.com/demyxsh/wordpress)
[![Watches](https://img.shields.io/github/watchers/demyxsh/wordpress?style=flat&color=blue)](https://github.com/demyxsh/wordpress)
[![Stars](https://img.shields.io/github/stars/demyxsh/wordpress?style=flat&color=blue)](https://github.com/demyxsh/wordpress)
[![Forks](https://img.shields.io/github/forks/demyxsh/wordpress?style=flat&color=blue)](https://github.com/demyxsh/wordpress)
[![Docker Pulls](https://img.shields.io/docker/pulls/demyx/wordpress?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![Architecture](https://img.shields.io/badge/linux-amd64-important?style=flat&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![Alpine](https://img.shields.io/badge/dynamic/json?url=https://github.com/demyxsh/wordpress/raw/master/version.json&label=alpine&query=$.alpine&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![WordPress](https://img.shields.io/badge/dynamic/json?url=https://github.com/demyxsh/wordpress/raw/master/version.json&label=wordpress&query=$.wordpress&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![Bedrock](https://img.shields.io/badge/dynamic/json?url=https://github.com/demyxsh/wordpress/raw/master/version.json&label=bedrock&query=$.bedrock&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![wp-cli](https://img.shields.io/badge/dynamic/json?url=https://github.com/demyxsh/wordpress/raw/master/version.json&label=wp-cli&query=$.wp_cli&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![PHP](https://img.shields.io/badge/dynamic/json?url=https://github.com/demyxsh/wordpress/raw/master/version.json&label=php&query=$.php&color=blue)](https://hub.docker.com/r/demyx/wordpress)
[![Buy Me A Coffee](https://img.shields.io/badge/buy_me_coffee-$5-informational?style=flat&color=blue)](https://www.buymeacoffee.com/VXqkQK5tb)
[![Become a Patron!](https://img.shields.io/badge/become%20a%20patron-$5-informational?style=flat&color=blue)](https://www.patreon.com/bePatron?u=23406156)

Non-root Docker image running Alpine Linux, PHP, and WordPress.

To properly utilize this image, please use [Demyx](https://demyx.sh/readme).
- Repository - [demyxsh/demyx](https://github.com/demyxsh/demyx)
- Homepage - [demyx.sh](https://demyx.sh)

[![Demyx Discord](https://discordapp.com/api/guilds/1152828583446859818/widget.png?style=banner2)](https://demyx.sh/discord)

Join us on Discord for latest news, faster support, or just chill.

<a href="https://demyx.sh/sponsor-buymeacoffee" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

Support this project by buying coffee (please).

## PHP Security

This update addresses [CVE-2026-109618](https://github.com/php/php-src/security/advisories/GHSA-w8hw-w9fx-j79w) and [CVE-2026-109619](https://github.com/php/php-src/security/advisories/GHSA-6wmf-4rv5-p3rp) ([PHP advisory](https://www.php.net/archive/2026.php#2026-10-21-5)). The image uses Alpine 3.24.2, which provides PHP 8.4.27 and PHP 8.3.36. Both branches remain installed; `DEMYX_PHP` selects 8.4 (`8.4` or `84`) or 8.3 (`8.3` or `83`) and defaults to 8.4. Builds require these fixed package versions and fail if the APK indexes do not meet the minimums.

The `latest`, versioned, and `v1` images and the Bedrock variant inherit the patch when rebuilt. Existing images and running workers are not patched by this repository change. With current Demyx, set `DEMYX_APP_PHP=8.4` for this image because new-site configuration defaults to PHP 8.5. Build `tag-latest` first with `--pull --no-cache`, tagging every image reference used by your Compose configuration. Set `WORDPRESS_VERSION` to the version referenced by Compose; a versioned deployment will not use a latest-only build. Then build Bedrock with `--no-cache` only so its `FROM demyx/wordpress` uses the freshly built local parent. Recreate containers after both builds:

```sh
WORDPRESS_VERSION=1.11.0
docker build --pull --no-cache \
  -t demyx/wordpress:latest \
  -t "demyx/wordpress:${WORDPRESS_VERSION}" \
  -t demyx/wordpress:v1 \
  tag-latest
docker build --no-cache \
  -t demyx/wordpress:bedrock \
  -t "demyx/wordpress:${WORDPRESS_VERSION}-bedrock" \
  -t demyx/wordpress:v1-bedrock \
  tag-bedrock
docker compose up -d --force-recreate
```

The Bedrock build must resolve the freshly built `demyx/wordpress:latest` parent locally. These commands assume a builder using Docker's local image store; with the `docker-container` Buildx driver, `--load` alone does not guarantee that the child builder can see the new parent.

Run the PHP security smoke test locally with `bash tests/php-security.sh demyx/wordpress:latest demyx/wordpress:bedrock`.

The legacy `tag-cli` and `tag-7.4` definitions are not built or published by the current workflow and remain outside this update. Other environment variables, public tags and variants, entrypoint and command interfaces, port 9000, compose paths, the non-root `demyx` UID 1000, and volume assumptions remain unchanged.
