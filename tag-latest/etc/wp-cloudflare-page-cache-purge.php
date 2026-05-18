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

$purgeResult = null;
$purgeMethodUsed = '';

// Super Page Cache v5.3.0+ API.
if (class_exists('\SPC\Modules\Cache_Controller') && method_exists('\SPC\Modules\Cache_Controller', 'purge_all')) {
    $purgeResult = \SPC\Modules\Cache_Controller::purge_all(false, false);
    $purgeMethodUsed = '\SPC\Modules\Cache_Controller::purge_all(false, false)';
}

if (
    $purgeMethodUsed === '' &&
    method_exists($sw_cloudflare_pagecache, 'get_core_loader') &&
    is_object($sw_cloudflare_pagecache->get_core_loader()) &&
    method_exists($sw_cloudflare_pagecache->get_core_loader(), 'cache_controller')
) {
    $controller = $sw_cloudflare_pagecache->get_core_loader()->cache_controller();

    if (is_object($controller) && method_exists($controller, 'purge_all')) {
        $purgeResult = $controller->purge_all(false, false);
        $purgeMethodUsed = 'get_core_loader()->cache_controller()->purge_all(false, false)';
    }
}

// Legacy plugin API fallback.
if ($purgeMethodUsed === '' && method_exists($sw_cloudflare_pagecache, 'get_cache_controller')) {
    $controller = $sw_cloudflare_pagecache->get_cache_controller();

    if (is_object($controller)) {
        if (method_exists($controller, 'purge_all')) {
            $purgeResult = $controller->purge_all(false, false);
            $purgeMethodUsed = 'get_cache_controller()->purge_all(false, false)';
        } elseif (method_exists($controller, 'purge_cache_everything')) {
            $purgeResult = $controller->purge_cache_everything();
            $purgeMethodUsed = 'get_cache_controller()->purge_cache_everything()';
        }
    }
}

if ($purgeMethodUsed === '' && method_exists($sw_cloudflare_pagecache, 'purge_all')) {
    $purgeResult = $sw_cloudflare_pagecache->purge_all(false, false);
    $purgeMethodUsed = 'purge_all(false, false)';
}

if ($purgeMethodUsed === '' && method_exists($sw_cloudflare_pagecache, 'purge_all_cache')) {
    $purgeResult = $sw_cloudflare_pagecache->purge_all_cache();
    $purgeMethodUsed = 'purge_all_cache()';
}

if ($purgeMethodUsed === '' && method_exists($sw_cloudflare_pagecache, 'purge_cache_everything')) {
    $purgeResult = $sw_cloudflare_pagecache->purge_cache_everything();
    $purgeMethodUsed = 'purge_cache_everything()';
}

if ($purgeMethodUsed === '') {
    fwrite(STDERR, "Error: No supported purge method found on SW_CLOUDFLARE_PAGECACHE.\n");
    exit(4);
}

if ($purgeResult === true || $purgeResult === null) {
    fwrite(STDOUT, "Cache purged successfully via {$purgeMethodUsed}.\n");
    exit(0);
}

fwrite(STDERR, "Error: Cache purge failed via {$purgeMethodUsed}. Check Super Page Cache logs for details.\n");
exit(5);
