<?php

declare(strict_types=1);

if (PHP_SAPI !== 'cli') {
    fwrite(STDERR, "Error: wp-cloudflare-page-cache-purge.php can only be run from CLI.\n");
    exit(1);
}

$demyxPath = getenv('DEMYX');

if (!is_string($demyxPath) || trim($demyxPath) === '') {
    fwrite(STDERR, "Error: DEMYX environment variable is not set. It must point to your WordPress root path.\n");
    exit(2);
}

$demyxPath = rtrim(trim($demyxPath), '/');
$wpLoadPath = $demyxPath . '/wp-load.php';
$wpConfigPath = $demyxPath . '/wp-config.php';

if (!is_file($wpLoadPath)) {
    fwrite(STDERR, "Error: WordPress bootstrap file not found at {$wpLoadPath}.\n");
    exit(2);
}

/**
 * advanced-cache.php runs early and expects HTTP server vars.
 * In CLI they are usually absent, so provide safe defaults.
 */
if (!isset($_SERVER['REQUEST_METHOD'])) {
    $_SERVER['REQUEST_METHOD'] = 'GET';
}

if (!isset($_SERVER['REQUEST_URI'])) {
    $_SERVER['REQUEST_URI'] = '/';
}

if (!isset($_SERVER['HTTP_HOST']) || $_SERVER['HTTP_HOST'] === '') {
    $host = '';

    if (is_file($wpConfigPath) && is_readable($wpConfigPath)) {
        $wpConfigContent = file_get_contents($wpConfigPath);

        if (is_string($wpConfigContent)) {
            if (preg_match("/define\\(\\s*['\\\"]WP_HOME['\\\"]\\s*,\\s*['\\\"]https?:\\/\\/([^'\\\"\\/]+)['\\\"]/i", $wpConfigContent, $matches) === 1) {
                $host = $matches[1];
            } elseif (preg_match("/define\\(\\s*['\\\"]WP_SITEURL['\\\"]\\s*,\\s*['\\\"]https?:\\/\\/([^'\\\"\\/]+)['\\\"]/i", $wpConfigContent, $matches) === 1) {
                $host = $matches[1];
            }
        }
    }

    if ($host === '') {
        $host = 'localhost';
    }

    $_SERVER['HTTP_HOST'] = $host;
}

if (!isset($_SERVER['SERVER_NAME']) || $_SERVER['SERVER_NAME'] === '') {
    $_SERVER['SERVER_NAME'] = $_SERVER['HTTP_HOST'];
}

if (!isset($_SERVER['HTTPS'])) {
    $_SERVER['HTTPS'] = 'on';
}

require_once $wpLoadPath;

global $sw_cloudflare_pagecache;

if (!isset($sw_cloudflare_pagecache) || !($sw_cloudflare_pagecache instanceof SW_CLOUDFLARE_PAGECACHE)) {
    fwrite(STDERR, "Error: Super Page Cache plugin is not loaded or active in this WordPress install.\n");
    exit(3);
}

$purgeResult = $sw_cloudflare_pagecache->get_cache_controller()->purge_all(false, false);

if ($purgeResult === true) {
    fwrite(STDOUT, "Cache purged successfully.\n");
    exit(0);
}

fwrite(STDERR, "Error: Cache purge failed. Check Super Page Cache logs for details.\n");
exit(4);
