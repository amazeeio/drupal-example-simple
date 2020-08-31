ARG CLI_IMAGE
FROM ${CLI_IMAGE} as cli

FROM amazeeio/nginx-drupal

COPY --from=cli /app /app


RUN echo "~^a\.domain                 https://www.example.com\$request_uri;" >> /etc/nginx/redirects-map.conf
RUN fix-permissions /etc/nginx

# Define where the Drupal Root is located
ENV WEBROOT=web
