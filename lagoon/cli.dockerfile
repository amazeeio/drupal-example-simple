FROM uselagoon/php-8.1-cli-drupal:latest

COPY lagoon/99-start-site-alias.sh /lagoon/entrypoints/
COPY lagoon/site-alias-gen /lagoon/site-alias-gen
COPY lagoon/drush.yml /home/.drush/drush.yml

COPY composer.* /app/
COPY assets /app/assets
RUN composer install --no-dev
COPY . /app
RUN mkdir -p -v -m775 /app/web/sites/default/files
    
# Define where the Drupal Root is located
ENV WEBROOT=web
# testing something for insights
ENV PYTHON_PIP_VERSION=1
