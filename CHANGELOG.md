# Changelog

## 2026-05-27
### Added
- None.
### Changed
- Move `DEMYX_VERSION` to job-level `env` key set to `1.10.0` instead of resolving dynamically from remote `demyx` orchestrator via a workflow step.
- Add `v1` and `v1-bedrock` moving tags to build and push steps in GitHub Actions workflow.
- Pin demyx cross-repo images (`mariadb`, `nginx`) and self-image in test step `docker run` commands to `:${{ env.DEMYX_VERSION }}`.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2026-05-25
### Added
- Added cron environment defaults in `tag-latest/bin/demyx-sudo` (`SHELL`, `PATH`, `DEMYX*`) to stabilize non-interactive cron execution.
- Added `demyx_cron_env()` and log-file path fallback handling in `tag-latest/bin/demyx-cron`.
### Changed
- Updated GitHub Actions Docker workflow to publish existing moving image tag(s) plus versioned tag(s) derived from `DEMYX_VERSION` from the `demyx` orchestrator.
- Updated `tag-latest` WordPress cron job to run as `demyx` without sudo root elevation.
- Switched `tag-latest/bin/demyx-cron` WordPress execution to WP-CLI primary (`wp cron event run --due-now`) and removed `wget`/`wp-cron.php` trigger logic.
- Updated cron logging to include stderr by default (`2>&1 | tee -a ...`) and include executor/path context in log lines.
### Fixed
- Fixed cron failures caused by missing cron environment variables under strict shell mode.
- Fixed silent cron troubleshooting gaps by capturing WP-CLI stderr in cron logs.
### Removed
- Removed `wget` fallback and URL-based `wp-cron.php` execution path from `tag-latest/bin/demyx-cron`.
### Security
- Reduced privilege scope by avoiding root execution for the WordPress cron command.

## 2026-05-14
### Added
- Added a cache purger script for the Super Page Cache plugin.
### Changed
- Updated GitHub Actions actions to v4/v3.
- Simplified PHP version detection to use `DEMYX_PHP`.
- Removed obsolete CLI and PHP 7.4 build references from workflow logic.
- Scheduled build run.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2026-05-11
### Added
- None.
### Changed
- Forced `error_log = /proc/self/fd/2` in both `/etc/php83/php-fpm.conf` and `/etc/php84/php-fpm.conf`.
- Updated PHP switcher to create `/var/log/php83/error.log` and set `demyx:demyx` ownership for non-root startup compatibility.
- Scheduled build run.
### Fixed
- Prevented PHP-FPM startup failure on default Alpine log path when running non-root.
### Removed
- None.
### Security
- None.

## 2026-05-09
### Added
- Added resilient fallback flow for `wp-cli-login-command` installation and temporary SSH client cleanup.
- Added new `tag-latest/bin/demyx-db` helper with wp-cli export and `mariadb-dump --skip-ssl` fallback.
### Changed
- Updated `tag-latest` base image to Alpine 3.22.
- Bumped default PHP target to 8.4 across compose and Dockerfile paths.
- Updated fallback PHP package set from `php82*` to `php83*`.
- Improved PHP-FPM auto-sizing logic in `tag-latest/bin/demyx-config` using cgroup memory/CPU limits and PM-aware caps.
- Switched cron execution to `wp cron event run --due-now`.
- Updated PHP switcher defaults to support 8.4 and default to 8.3 fallback.
- Scheduled build run.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2025-07-28
### Added
- None.
### Changed
- Pushed users toward Demyx defaults/documentation.
- Updated Alpine base and upgraded PHP version.
- Renamed compose file.
- Refactored GitHub Actions workflow (sleep timing, version retrieval, unused build commands).
- Updated commit message format in scheduled builds to include run ID.
- Updated Dockerfiles, cron/sudo scripts, and memory-management behavior.
- Updated file/override layout (`demyx.php` generation unification, `demyx.ini` rename, case/variable logic cleanup).
### Fixed
- Addressed WordPress URL reachability failures.
- Included subshell checks.
### Removed
- Removed old/unused variables and unneeded lines.
- Removed logrotate function.
### Security
- None.

## 2024-12-19
### Added
- None.
### Changed
- Allowed overriding `FROM` in terminal-driven build flow.
### Fixed
- None.
### Removed
- Removed unused variables.
### Security
- None.

## 2024-10-31
### Added
- Added full-path handling updates.
### Changed
- Updated variable sets and opcache variable placement.
- Moved PHP switcher into sudo script for versionless symlink flow.
- Renamed cron file and updated case logic.
- Made php-fpm PID 1 and enabled restart when entrypoint reruns.
- Auto-populated PM values based on server RAM.
- Unified `demyx.php` generation for latest and bedrock.
- Renamed override file to `demyx.ini`.
- Renamed compose file.
### Fixed
- Used PHP binary for cron trigger.
- Included subshell checking.
### Removed
- Removed old variables, logrotate function, unnecessary line breaks, and other unneeded lines.
### Security
- None.

## 2024-02-28
### Added
- Allowed users to add custom cron.
- Included missing create rule.
- Added missing environment variable(s) and custom volume support.
- Added function to reset permissions at startup/hourly.
### Changed
- Updated PHP versions and defaulted to 8.1.
- Updated description/support text.
- Restored wp-cli as default cron path.
- Updated Alpine to 3.18.
### Fixed
- Fixed reboot container crash.
- Fixed wrong link.
- Doubled upload limit.
- Removed shorthand usage that caused issues.
### Removed
- Removed unused variables.
### Security
- None.

## 2023-11-14
### Added
- None.
### Changed
- Disabled installation of default themes/plugins during upgrade.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2023-09-20
### Added
- Added Redis constant definitions.
### Changed
- None.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2023-09-03
### Added
- Added `DEMYX_CRON_TYPE` variable.
### Changed
- None.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2023-08-28
### Added
- Added PHP 8.1 support.
### Changed
- Updated logrotate configuration.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2023-08-23
### Added
- Added wp-cli login package support.
- Added new environment variables.
- Added new executables and PHP extensions (`intl`, `pdo`).
- Added logrotate options/variables.
### Changed
- Updated test commands and variable behavior.
- Updated cron intervals.
- Switched variable order and brace/sed handling.
- Adjusted Alpine version.
- Updated Bedrock login support.
- Misc updates.
### Fixed
- Corrected missing variable usage and strict-if logic.
### Removed
- Removed whitespace and `--update` usage where no longer needed.
### Security
- None.

## 2022-11-01
### Added
- Added new environment variables and executables.
### Changed
- Renamed environment variable(s).
- Updated comments, `depends_on` keys, and function formatting.
- Set SSL disabled by default.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2022-08-16
### Added
- Added `roots/acorn`.
### Changed
- Removed composer command path in favor of updated install flow.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2022-08-05
### Added
- Added PHP major `8` as case option.
### Changed
- Misc updates.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2022-08-01
### Added
- Added `mysql-client` package.
- Added `DEMYX_PHP` variable with default 8.0.
- Added wp-cli executable.
- Added PHP 8.0/8.1 installation through package manager.
### Changed
- Switched to upstream Alpine.
- Updated symlink locations.
- Renamed scripts and made them executable.
- Archived PHP 7.4 files.
- Built/pushed 7.4 tag.
- Updated tag-bedrock/tag-cli directory and package flows.
### Fixed
- None.
### Removed
- Removed full paths in tag-bedrock/tag-cli where applicable.
### Security
- None.

## 2021-07-14
### Added
- None.
### Changed
- Updated to latest distro.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2020-12-25
### Added
- None.
### Changed
- Added missing bash package in `tag-cli` flow.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2020-12-06
### Added
- None.
### Changed
- Updated user handling for `su` command.
- Updated compose behavior.
- Updated Bedrock and latest RUN/install command flows.
- Cleared/managed DEMYX directory handling for Bedrock installs.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2020-12-04
### Added
- None.
### Changed
- Restored entrypoint array form.
- Renamed `wp-config-sample.php` earlier in flow.
- Misc updates.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2020-12-02
### Added
- None.
### Changed
- Rearranged wp-cli and Bedrock RUN commands.
- Updated install scripts and final RUN commands.
- Misc changes.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2020-11-30
### Added
- None.
### Changed
- Rearranged RUN commands.
- Updated WordPress RUN commands.
- Updated installer conditional logic.
- Misc updates.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2020-11-24
### Added
- None.
### Changed
- Alphabetized settings.
- Fixed PHP version to 7.x.
- Renamed variables with backwards compatibility.
- Updated Dockerfile RUN commands.
- Used full binary/script paths.
- Used `sudo -E` for env preservation.
- Misc updates.
### Fixed
- ShellCheck compliance improvements.
### Removed
- None.
### Security
- None.

## 2020-07-05
### Added
- Added bash.
### Changed
- Used `cp` instead of `mv` for `wp-config.php` creation.
- Updated WordPress install logic.
- Misc updates.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2020-07-02
### Added
- None.
### Changed
- Populated `/demyx` directory with WordPress/Bedrock files.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2020-07-01
### Added
- Added `WORDPRESS_PHP_EMERGENCY_RESTART_THRESHOLD`, `WORDPRESS_PHP_EMERGENCY_RESTART_INTERVAL`, and `WORDPRESS_PHP_PROCESS_CONTROL_TIMEOUT`.
### Changed
- Alphabetized keys in `docker-compose.yml`.
- Updated README example.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2020-05-18
### Added
- Added `mariadb-client` so wp-cli can use mysqldump.
### Changed
- None.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2020-04-15
### Added
- Created `src` directory for main files.
### Changed
- Formatted `LABEL` and `ENV` entries.
- Switched base image to `php:fpm-alpine`.
- Used third-party script to install PHP extensions.
- Updated bedrock/latest entrypoint and final RUN flows.
- Moved default latest config variables into Dockerfile `ENV`.
- Set `dumb-init` shebang in entrypoints.
### Fixed
- None.
### Removed
- None.
### Security
- None.
