ARG CLI_IMAGE
FROM ${CLI_IMAGE} as cli

FROM lagoon/php-8.0-fpm

COPY --from=cli /app /app
