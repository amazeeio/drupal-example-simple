FROM testlagoon/php-8.0-cli-drupal:pr-47

COPY composer.* /app/
COPY assets /app/assets
RUN composer install --prefer-dist --no-dev --ignore-platform-reqs --no-suggest --optimize-autoloader --apcu-autoloader
COPY . /app
RUN mkdir -p -v -m775 /app/web/sites/default/files
    
# Define where the Drupal Root is located
ENV WEBROOT=web
