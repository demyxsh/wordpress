# CHANGELOG
Entries before tag-* affects all tags. 

## 2020-12-25
### Changed
- tag-cli
    - Missing bash package

## 2020-12-06
### Changed
- Missing user for su command
- Misc updates to docker-compose.yml
- tag-bedrock
    - Get composer as demyx user
    - Remove all content in DEMYX directory before installing Bedrock
- tag-latest
    - Change comment

## 2020-12-04
### Changed
- Put entrypoint back to an array
- Rename wp-config-sample.php before
- Misc update

## 2020-12-02
### Changed
- Misc changes
- Rearrange wp-cli RUN commands
- Update Bedrock RUN commands
- Update finalize RUN commands
- Update install.sh scripts

## 2020-11-30
### Changed
- Misc updates
- Rearrange RUN commands
- Update WordPress RUN commands
- Update if statement for the installer

## 2020-11-24
### Changed
- Alphabetized
- Fixed PHP version to 7.x
- Misc updates
- Rename variables and support old ones
- ShellCheck approved
- Update Dockerfile RUN commands
- Use -E flag for sudo to keep environment variables
- Use full paths to binaries/scripts

## 2020-07-05
### Added
- bash
### Changed
- Use cp instead of mv when creating wp-config.php
- Update logic when installing WordPress
- Various misc updates

## 2020-07-02
### Changed
- Populate /demyx directory with WordPress/Bedrock files

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
