Docker Compose Drupal 9 simple - php7.4, nginx, mariadb
=======================================================

This is a docker-compose version of the Lando example tests:

Start up tests
--------------

Run the following commands to get up and running with this example.

```bash
# Should remove any previous runs and poweroff
sed -i -e "/###/d" docker-compose.yml
docker network inspect amazeeio-network >/dev/null || docker network create amazeeio-network
docker-compose down

# Should start up our Lagoon Drupal 9 site successfully
docker-compose build && docker-compose up -d

# Ensure mariadb pod is ready to connect
docker run --rm --net drupal9-example-simple_default jwilder/dockerize dockerize -wait tcp://mariadb:3306 -timeout 1m
```

Verification commands
---------------------

Run the following commands to validate things are rolling as they should.

```bash
# Should be able to site install via Drush
docker-compose exec -T cli bash -c "drush si -y"
docker-compose exec -T cli bash -c "drush cr -y"
docker-compose exec -T cli bash -c "drush status" | grep "Drupal bootstrap" | grep "Successful"

# Should have all the services we expect
docker ps --filter label=com.docker.compose.project=drupal9-example-simple | grep Up | grep drupal9-example-simple_nginx_1
docker ps --filter label=com.docker.compose.project=drupal9-example-simple | grep Up | grep drupal9-example-simple_mariadb_1
docker ps --filter label=com.docker.compose.project=drupal9-example-simple | grep Up | grep drupal9-example-simple_php_1
docker ps --filter label=com.docker.compose.project=drupal9-example-simple | grep Up | grep drupal9-example-simple_cli_1

# Should ssh against the cli container by default
docker-compose exec -T cli bash -c "env | grep LAGOON=" | grep cli-drupal

# Should have the correct environment set
docker-compose exec -T cli bash -c "env" | grep LAGOON_ROUTE | grep drupal9-example-simple.docker.amazee.io
docker-compose exec -T cli bash -c "env" | grep LAGOON_ENVIRONMENT_TYPE | grep development

# Should be running PHP 7.4
docker-compose exec -T cli bash -c "php -v" | grep "PHP 7.4"

# Should have composer
docker-compose exec -T cli bash -c "composer --version"

# Should have php cli
docker-compose exec -T cli bash -c "php --version"

# Should have drush
docker-compose exec -T cli bash -c "drush --version"

# Should have npm
docker-compose exec -T cli bash -c "npm --version"

# Should have node
docker-compose exec -T cli bash -c "node --version"

# Should have yarn
docker-compose exec -T cli bash -c "yarn --version"

# Should have a running Drupal 9 site served by nginx on port 8080
docker-compose exec -T cli bash -c "curl -kL http://nginx:8080" | grep "Welcome to Drush Site-Install"

# Should be able to db-export and db-import the database
docker-compose exec -T cli bash -c "drush sql-dump --result-file /app/test.sql"
docker-compose exec -T cli bash -c "drush sql-drop -y"
docker-compose exec -T cli bash -c "drush sql-cli < /app/test.sql"
docker-compose exec -T cli bash -c "rm test.sql*"

# Should be able to show the drupal tables
docker-compose exec -T cli bash -c "drush sqlq \'show tables;\'" | grep users

# Should be able to rebuild and persist the database
docker-compose build && docker-compose up -d
docker-compose exec -T cli bash -c "drush sqlq \'show tables;\'" | grep users
```

Destroy tests
-------------

Run the following commands to trash this app like nothing ever happened.

```bash
# Should be able to destroy our Drupal 9 site with success
docker-compose down --volumes --remove-orphans
```
