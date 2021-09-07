# Here we show an example of using a multistage build to build
# assets inside a _nodejs_ image, that are copied into our resulting
# image

# We begin by specifying that we want to use a node image to perform some tasks
# We give it a name, so we can reference it later - here we call it "builder"
FROM uselagoon/node-10-builder as builder
COPY . /app
RUN yarn install
RUN yarn gulp sprite
# As you can see above, we can run nodejs apps, gulp in this case, in "builder"
# this allows us to use node as part of our build process, without needing it
# on the resulting image

# our gulp script generates CSS and png assets. We will now install Drupal and
# copy the files from our builder into the final resulting image.
FROM uselagoon/php-7.4-cli-drupal:latest
COPY composer.* /app/
COPY assets /app/assets
RUN COMPOSER_MEMORY_LIMIT=-1 composer install --no-dev
COPY . /app
RUN mkdir -p -v -m775 /app/web/sites/default/files
# At this point, our resulting image _DOES NOT_ have the images we generated earlier
# we need to explicitly copy them from "builder" into our image.
COPY --from=builder /app/sprites/dest /app/web/sites/default/files/

# Define where the Drupal Root is located
ENV WEBROOT=web
