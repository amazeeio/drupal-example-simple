#
# CLI image
#
FROM testlagoon/php-8.1-cli-drupal:pr-197 as cli

COPY composer.* /app/
COPY assets /app/assets
RUN composer install --no-dev
COPY . /app
RUN mkdir -p -v -m775 /app/web/sites/default/files
    
# Define where the Drupal Root is located
ENV WEBROOT=web

#
# Nginx image
#
FROM testlagoon/nginx-drupal:pr-197 as nginx

COPY --from=cli /app /app

# Define where the Drupal Root is located
ENV WEBROOT=web

#
# PHP-FPM image
#
FROM testlagoon/php-8.1-fpm:pr-197 as php

COPY --from=cli /app /app
