FROM testlagoon/php-8.0-cli-drupal:pr-47

COPY composer.* /app/
COPY assets /app/assets
RUN composer self-update --2 \
    && composer install --no-dev --ignore-platform-reqs
COPY . /app
RUN mkdir -p -v -m775 /app/web/sites/default/files
    
# Define where the Drupal Root is located
ENV WEBROOT=web
