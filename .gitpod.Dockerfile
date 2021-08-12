FROM gitpod/workspace-full
RUN curl -OL https://github.com/lando/lando/releases/download/v3.1.4/lando-v3.1.4.deb && sudo dpkg -i lando-v3.1.4.deb && rm -rf lando-v3.1.4.deb
RUN mkdir -p ~/.lando && echo "proxy: 'ON'\nproxyHttpPort: '8080'\nproxyHttpsPort: '4443'\nbindAddress: '0.0.0.0'\nproxyBindAddress: '0.0.0.0'" > ~/.lando/config.yml
