#!/usr/bin/env bash
set -euo pipefail

if (($# == 0)); then
    printf 'Usage: %s IMAGE [IMAGE ...]\n' "${0##*/}" >&2
    exit 2
fi

container_test=$(cat <<'EOF'
assert_executable() {
    if [ ! -x "$1" ]; then
        printf "Required executable missing or not executable: %s\n" "$1" >&2
        exit 1
    fi
}

assert_link_target() {
    if [ ! -L "$1" ] || [ "$(readlink "$1")" != "$2" ]; then
        printf "Unexpected link target: %s\n" "$1" >&2
        exit 1
    fi
}

assert_php_branch() {
    cli="$1"
    fpm="$2"
    minor="$3"
    minimum="$4"

    assert_executable "$cli"
    assert_executable "$fpm"

    cli_version=$("$cli" -r 'echo PHP_VERSION;')
    PHP_VERSION_UNDER_TEST="$cli_version" PHP_EXPECTED_MINOR="$minor" PHP_MINIMUM_VERSION="$minimum" "$cli" -r '
$version = getenv("PHP_VERSION_UNDER_TEST");
$expectedMinor = getenv("PHP_EXPECTED_MINOR");
$minimum = getenv("PHP_MINIMUM_VERSION");
if (
    PHP_MAJOR_VERSION !== 8
    || PHP_MINOR_VERSION !== (int) $expectedMinor
    || PHP_SAPI !== "cli"
    || $version !== PHP_VERSION
    || version_compare(PHP_VERSION, $minimum, "<")
) {
    fwrite(STDERR, "Unexpected PHP CLI version: " . PHP_VERSION . PHP_EOL);
    exit(1);
}
'

    missing_extensions=$("$cli" -r '
$required = [
    "bcmath", "ctype", "curl", "dom", "exif", "fileinfo", "ftp", "gd",
    "iconv", "imagick", "intl", "json", "mbstring", "mysqli",
    "Zend OPcache", "openssl", "PDO", "pdo_mysql", "Phar", "posix",
    "session", "SimpleXML", "soap", "sodium", "sockets", "ssh2",
    "tokenizer", "xml", "xmlreader", "xmlwriter", "zip", "zlib",
];
$missing = [];
foreach ($required as $extension) {
    if (!extension_loaded($extension)) {
        $missing[] = $extension;
    }
}
echo implode(" ", $missing);
')
    if [ -n "$missing_extensions" ]; then
        printf "Missing PHP %s extensions: %s\n" "$minor" "$missing_extensions" >&2
        exit 1
    fi

    fpm_output=$("$fpm" --version) || {
        printf "Could not read PHP-FPM version from %s\n" "$fpm" >&2
        exit 1
    }
    if ! fpm_version=$(printf "%s\n" "$fpm_output" | awk '
NR == 1 {
    if ($1 != "PHP" || $2 !~ /^8\.[0-9]+\.[0-9]+$/ || $3 != "(fpm-fcgi)") {
        exit 1
    }
    print $2
    found = 1
}
END {
    if (!found) {
        exit 1
    }
}
'); then
        printf "Malformed PHP-FPM version output from %s: %s\n" "$fpm" "$fpm_output" >&2
        exit 1
    fi
    PHP_FPM_VERSION="$fpm_version" PHP_EXPECTED_MINOR="$minor" PHP_MINIMUM_VERSION="$minimum" "$cli" -r '
$version = getenv("PHP_FPM_VERSION");
$expectedMinor = getenv("PHP_EXPECTED_MINOR");
$minimum = getenv("PHP_MINIMUM_VERSION");
if (
    $version === false
    || !preg_match("/^8\.[0-9]+\.[0-9]+$/D", $version)
    || strpos($version, "8." . $expectedMinor . ".") !== 0
    || version_compare($version, $minimum, "<")
) {
    fwrite(STDERR, "Unexpected PHP-FPM version: " . (string) $version . PHP_EOL);
    exit(1);
}
'
    printf "PHP %s CLI/FPM checks passed (%s / %s)\n" "$minor" "$cli_version" "$fpm_version"
}

if [ "$(id -u)" -ne 1000 ]; then
    printf "Expected non-root UID 1000, got %s\n" "$(id -u)" >&2
    exit 1
fi

for binary in /usr/bin/php83 /usr/bin/php84 /usr/sbin/php-fpm83 /usr/sbin/php-fpm84; do
    assert_executable "$binary"
done

assert_executable /usr/bin/php /usr/sbin/php-fpm
assert_link_target /usr/bin/php /usr/bin/php84
assert_link_target /usr/sbin/php-fpm /usr/sbin/php-fpm84
assert_php_branch /usr/bin/php /usr/sbin/php-fpm 4 8.4.27

assert_link_target /etc/php83/php-fpm.d/www.conf /etc/demyx/www.conf
assert_link_target /etc/php84/php-fpm.d/www.conf /etc/demyx/www.conf
assert_link_target /etc/php83/conf.d/demyx.ini /etc/demyx/demyx.ini
assert_link_target /etc/php84/conf.d/demyx.ini /etc/demyx/demyx.ini

printf "<?php\n" > /demyx/wp-config.php
DEMYX_WP_CONFIG=/demyx/wp-config.php demyx-config
expected_memory="${DEMYX_MEMORY:-256M}"

for version in 8.4 8.3; do
    DEMYX_PHP="$version" sudo -E demyx-sudo php
    case "$version" in
        8.4)
            suffix=84
            minor=4
            minimum=8.4.27
        ;;
        8.3)
            suffix=83
            minor=3
            minimum=8.3.36
        ;;
    esac

    assert_link_target /usr/bin/php "/usr/bin/php${suffix}"
    assert_link_target /usr/sbin/php-fpm "/usr/sbin/php-fpm${suffix}"
    assert_php_branch "/usr/bin/php${suffix}" "/usr/sbin/php-fpm${suffix}" "$minor" "$minimum"

    actual_memory=$(/usr/bin/php -r 'echo ini_get("memory_limit");')
    if [ "$actual_memory" != "$expected_memory" ]; then
        printf "Expected PHP %s memory_limit %s, got %s\n" "$minor" "$expected_memory" "$actual_memory" >&2
        exit 1
    fi
    /usr/sbin/php-fpm -tt
done

printf "Dual-runtime PHP security checks passed\n"
EOF
)

for image in "$@"; do
    printf 'Checking PHP security in %s\n' "$image"
    docker run --rm --network none --entrypoint /bin/sh "$image" -ec "$container_test"
done
