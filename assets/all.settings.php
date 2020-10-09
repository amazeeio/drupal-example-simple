<?php
/**
 * @file
 * amazee.io Drupal all environment configuration file.
 *
 * This file should contain all settings.php configurations that are needed by all environments.
 *
 * It contains some defaults that the amazee.io team suggests, please edit them as required.
 */

// Defines where the sync folder of your configuration lives. In this case it's inside
// the Drupal root, which is protected by amazee.io Nginx configs, so it cannot be read
// via the browser. If your Drupal root is inside a subfolder (like 'web') you can put the config
// folder outside this subfolder for an advanced security measure: '../config/sync'.
$settings['config_sync_directory'] = '../config/sync';

// Adds in a postgres default database - this overrides the mariadb set in settings.lagoon.php
if(getenv('LAGOON')){
    $databases['default']['default'] = array(
      'driver' => 'pgsql',
      'database' => getenv('POSTGRES_DATABASE') ?: 'drupal',
      'username' => getenv('POSTGRES_USERNAME') ?: 'drupal',
      'password' => getenv('POSTGRES_PASSWORD') ?: 'drupal',
      'host' => getenv('POSTGRES_HOST') ?: 'postgres',
      'port' => 5432,
      'prefix' => '',
    );
  }

if (getenv('LAGOON_ENVIRONMENT_TYPE') !== 'production') {
    /**
     * Skip file system permissions hardening.
     *
     * The system module will periodically check the permissions of your site's
     * site directory to ensure that it is not writable by the website user. For
     * sites that are managed with a version control system, this can cause problems
     * when files in that directory such as settings.php are updated, because the
     * user pulling in the changes won't have permissions to modify files in the
     * directory.
     */
    $settings['skip_permissions_hardening'] = TRUE;
}
