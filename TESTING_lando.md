Lando Drupal 9 Solr and Redis option  - php7.4, nginx, mariadb, solr, redis
===========================================================================

This example exists primarily to test the following documentation:

* [Lagoon Recipe - Drupal 9](https://docs.lando.dev/config/lagoon.html)

Start up tests
--------------

Run the following commands to get up and running with this example.

```bash
# Should remove any previous runs and poweroff
lando --clear
lando destroy -y
lando poweroff

# Should start up our Lagoon Drupal 9 site successfully
lando start
```

Verification commands
---------------------

Run the following commands to validate things are rolling as they should.

```bash
# Should be able to site install via Drush
lando drush si -y
lando drush cr -y
lando drush status | grep "Drupal bootstrap" | grep "Successful"

# Should have all the services we expect
docker ps --filter label=com.docker.compose.project=drupal9exampleadvanced | grep Up | grep drupal9exampleadvanced_nginx_1
docker ps --filter label=com.docker.compose.project=drupal9exampleadvanced | grep Up | grep drupal9exampleadvanced_mariadb_1
docker ps --filter label=com.docker.compose.project=drupal9exampleadvanced | grep Up | grep drupal9exampleadvanced_mailhog_1
docker ps --filter label=com.docker.compose.project=drupal9exampleadvanced | grep Up | grep drupal9exampleadvanced_php_1
docker ps --filter label=com.docker.compose.project=drupal9exampleadvanced | grep Up | grep drupal9exampleadvanced_cli_1
docker ps --filter label=com.docker.compose.project=drupal9exampleadvanced | grep Up | grep drupal9exampleadvanced_solr_1
docker ps --filter label=com.docker.compose.project=drupal9exampleadvanced | grep Up | grep drupal9exampleadvanced_redis_1
docker ps --filter label=com.docker.compose.project=drupal9exampleadvanced | grep Up | grep drupal9exampleadvanced_lagooncli_1

# Should ssh against the cli container by default
lando ssh -c "env | grep LAGOON=" | grep cli-drupal

# Should have the correct environment set
lando ssh -c "env" | grep LAGOON_ROUTE | grep drupal9-example-advanced.lndo.site
lando ssh -c "env" | grep LAGOON_ENVIRONMENT_TYPE | grep development

# Should be running PHP 7.4
lando ssh -c "php -v" | grep "PHP 7.4"

# Should have composer
lando composer --version

# Should have php cli
lando php --version

# Should have drush
lando drush --version

# Should have npm
lando npm --version

# Should have node
lando node --version

# Should have yarn
lando yarn --version

# Should have lagoon cli
lando lagoon --version | grep lagoon

# Should have a running Drupal 8 site served by nginx on port 8080
lando ssh -s cli -c "curl -kL http://nginx:8080" | grep "Welcome to Drush Site-Install"

# Should be running Redis v5.0
lando ssh -s redis -c "redis-server --version | grep v=5."

# Should be able to see Redis databases
lando ssh -s redis -c "redis-cli CONFIG GET databases"

# Redis databases should be initialized
lando ssh -s redis -c "redis-cli dbsize"

# Should have a "drupal" Solr core
lando ssh -s cli -c "curl solr:8983/solr/admin/cores?action=STATUS&core=drupal"

# Should be able to reload "drupal" Solr core
lando ssh -s cli -c "curl solr:8983/solr/admin/cores?action=RELOAD&core=drupal"

# Check Solr has 7.x config in "drupal" core
lando ssh -s solr -c "cat /opt/solr/server/solr/mycores/drupal/conf/schema.xml | grep solr-7.x"

# Should be able to db-export and db-import the database
lando db-export test.sql
lando db-import test.sql.gz
rm test.sql*

# Should be able to show the drupal tables
lando mysql drupal -e "show tables;" | grep users

# Should be able to rebuild and persist the database
lando rebuild -y
lando mysql drupal -e "show tables;" | grep users
```

Destroy tests
-------------

Run the following commands to trash this app like nothing ever happened.

```bash
# Should be able to destroy our Drupal 9 site with success
lando destroy -y
lando poweroff
```
