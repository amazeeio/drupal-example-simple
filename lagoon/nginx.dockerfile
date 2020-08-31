ARG CLI_IMAGE
FROM ${CLI_IMAGE} as cli

FROM amazeeio/nginx-drupal

RUN echo "~^a\.domain                 https://www.example.com\$request_uri;" >> /etc/nginx/redirects-map.conf
RUN fix-permissions /etc/nginx

COPY --from=cli /app /app


# Define where the Drupal Root is located
ENV WEBROOT=web
