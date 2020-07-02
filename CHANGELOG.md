# CHANGELOG
Entries before tag-* affects all tags. 

## 2020-07-01
### Added
- 3 new environment variables: WORDPRESS_PHP_EMERGENCY_RESTART_THRESHOLD, WORDPRESS_PHP_EMERGENCY_RESTART_INTERVAL, WORDPRESS_PHP_PROCESS_CONTROL_TIMEOUT
### Changed
- Alphabetized keys in docker-compose.yml
- Updated README example

## 2020-05-18
### Added
- mariadb-client was added so wp-cli can use mysqldump

## 2020-04-15
### Added
- Created src directory for main file(s)
### Changed
- Format LABEL and ENV entries
- Switch base image to php:fpm-alpine
- Use third party script to install php extensions
- tag-bedrock
    - Install composer from upstream
    - Set dumb-init as the shebang in the entrypoint
    - Update finalize RUN commands
    - Update entrypoint
- tag-latest
    - Move default variables in config.sh to Dockerfile ENV
    - Set dumb-init as the shebang in the entrypoint
    - Update finalize RUN commands
    - Update entrypoint
