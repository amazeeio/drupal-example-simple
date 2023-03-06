ARG CLI_IMAGE
FROM ${CLI_IMAGE} as cli

FROM testlagoon/php-8.1-fpm:pr-197

COPY --from=cli /app /app
