# CHANGELOG
Entries before tag-* affects all tags. 

## 2022-08-01
- Misc updates [e5db3aa](https://github.com/demyxsh/wordpress/commit/e5db3aa72191d376abfc3f4234d49e81355a7ab8)
- Build and push 7.4 tag [c14ec90](https://github.com/demyxsh/wordpress/commit/c14ec901326fe26e184297ef5b7c4f48cce2ad6a)
- Update symlink locations [58397c3](https://github.com/demyxsh/wordpress/commit/58397c3bc4332b2d9b0f89b2e102b7d06e705569)
- Add wp-cli executable [64570a2](https://github.com/demyxsh/wordpress/commit/64570a2a924cd66da6c0f887db3e1e510a89d4ef)
- Install php 8.0 and 8.1 through apk package manager [09a7008](https://github.com/demyxsh/wordpress/commit/09a70086e75bfa937d8c21c8a207d56e23566b9e)
- Add new package mysql-client [3b60d90](https://github.com/demyxsh/wordpress/commit/3b60d902d01008d57f9f49c621e4fa60708847f8)
- Add new variable DEMYX_PHP, default value is 8.0 [70475ec](https://github.com/demyxsh/wordpress/commit/70475ec64ba04809c21ec8dcfddaf0482309cd6c)
- Use upstream alpine [fdf0256](https://github.com/demyxsh/wordpress/commit/fdf0256e81b32142ee29e359f2d9cc243cbd6f50)
- Archive php7.4 files [ec1ab2a](https://github.com/demyxsh/wordpress/commit/ec1ab2ab23333c28d38fd9b311a186e7ea86b8ab)
- Rename scripts and make it executable [dc23f66](https://github.com/demyxsh/wordpress/commit/dc23f6692c13bd36782c5823ef3c365fb77a3992)

## 2021-07-14
- Use latest distro [c55d74d](https://github.com/demyxco/wordpress/commit/c55d74d7ed09fc958ccbf972b17d5c647b025480)

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
