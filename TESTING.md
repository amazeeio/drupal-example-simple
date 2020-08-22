Lagoon Drupal 8 Simple
=======================

This example exists primarily to test the following documentation:

* [Lagoon Recipe - Drupal 8](https://docs.lando.dev/config/lagoon.html)

Start up tests
--------------

Run the following commands to get up and running with this example.

```bash
# Avoid namespace collisions for Lando
sed -i.bak "s/^name.*/name: drupal8simpleci/" .lando.yml
sed -i.bak "s/^COMPOSE_PROJECT_NAME.*/COMPOSE_PROJECT_NAME=drupal8simpleci/" .env

# Should remove any previous runs and poweroff
lando --clear
lando destroy -y
lando poweroff

# Should start up our lagoon drupal 8 site successfully
lando start
```

Verification commands
---------------------

Run the following commands to validate things are rolling as they should.

```bash
# Should be able to site install via drush
lando drush si -y
lando drush cr -y
lando drush status | grep "Drupal bootstrap" | grep "Successful"

# Should have all the services we expect
docker ps --filter label=com.docker.compose.project=drupal8simpleci | grep Up | grep drupal8simpleci_nginx_1
docker ps --filter label=com.docker.compose.project=drupal8simpleci | grep Up | grep drupal8simpleci_mariadb_1
docker ps --filter label=com.docker.compose.project=drupal8simpleci | grep Up | grep drupal8simpleci_mailhog_1
docker ps --filter label=com.docker.compose.project=drupal8simpleci | grep Up | grep drupal8simpleci_php_1
docker ps --filter label=com.docker.compose.project=drupal8simpleci | grep Up | grep drupal8simpleci_cli_1

# Should ssh against the cli container by default
lando ssh -c "env | grep LAGOON=" | grep cli-drupal

# Should have the correct environment set
lando ssh -c "env" | grep LAGOON_ROUTE | grep https://drupal8-example-simple.lndo.site
lando ssh -c "env" | grep LAGOON_ENVIRONMENT_TYPE | grep development

# Should be running PHP 7.4.x
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

# Should have a running drupal 8 site served by nginx on port 8080
lando ssh -s cli -c "curl -kL http://nginx:8080" | grep "Welcome to Drush Site-Install"

# Should be able to db-export and db-import the database
lando db-export test.sql
lando db-import test.sql.gz
rm test.sql*

# Should be able to show the drupal tables
lando mysql drupal -e "show tables;" | grep users

# Should be able to rebuild and persist the database
lando rebuild -y
lando mysql drupal -e "show tables;" | grep users

# Should be able to rebuild using PHP7.2
sed -i "/^FROM/ s/7.4/7.2/" lagoon/*.dockerfile
lando rebuild -y
lando ssh -c "php -v" | grep "PHP 7.2"

# Should have a running drupal 8 site served by nginx on port 8080
lando drush cr
lando ssh -s cli -c "curl -kL http://nginx:8080" | grep "Welcome to Drush Site-Install"
```

Destroy tests
-------------

Run the following commands to trash this app like nothing ever happened.

```bash
# Should be able to destroy our drupal8 site with success
lando destroy -y
lando poweroff

# Reset modifed files to pre-testing versions
sed -i "/^FROM/ s/7.2/7.4/" lagoon/*.dockerfile
docker image ls --format "{{.Repository}} {{.ID}}" |grep -E "drupal8simpleci" | xargs -n2 docker rmi -f
mv .lando.yml.bak .lando.yml
mv .env.bak .env
```