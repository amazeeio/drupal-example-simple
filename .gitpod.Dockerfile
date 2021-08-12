FROM gitpod/workspace-full
# Make runc's proc mount work again https://github.com/gitpod-io/gitpod/issues/5124#issuecomment-897048987
RUN curl -o olderrunc -L https://github.com/opencontainers/runc/releases/download/v1.0.0-rc93/runc.amd64 && chmod 755 olderrunc
RUN sudo rm /usr/bin/runc && sudo cp olderrunc /usr/bin/runc
RUN curl -OL https://github.com/lando/lando/releases/download/v3.1.4/lando-v3.1.4.deb && sudo dpkg -i lando-v3.1.4.deb && rm -rf lando-v3.1.4.deb
RUN mkdir -p ~/.lando && echo "proxy: 'ON'\nproxyHttpPort: '8080'\nproxyHttpsPort: '4443'\nbindAddress: '0.0.0.0'\nproxyBindAddress: '0.0.0.0'" > ~/.lando/config.yml
