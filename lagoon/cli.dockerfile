FROM uselagoon/lagoon-cli:latest as lagoon-cli

FROM uselagoon/php-8.1-cli-drupal:latest

COPY --from=lagoon-cli /lagoon /usr/local/bin/lagoon

COPY composer.* /app/
COPY assets /app/assets
RUN composer install --no-dev
COPY . /app
RUN mkdir -p -v -m775 /app/web/sites/default/files

COPY ./lagoon/test6.lagoon.yml /home/.lagoon.yml
# Define where the Drupal Root is located
ENV WEBROOT=web
