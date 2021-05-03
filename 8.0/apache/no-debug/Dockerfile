FROM pimcore/pimcore:PHP8.0-apache-debug

LABEL maintainer="devs@alpin11.com"

# install mjml on global
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -; \
            apt-get install -y nodejs; \
            npm install -g mjml;

# update composer to latest version
RUN composer self-update

# add aliases
RUN echo 'alias cache:clear="bin/console cache:clear && chown www-data: . -R "' >> /root/.bashrc
RUN echo 'alias pimcore:cache:clear="bin/console cache:clear"' >> /root/.bashrc

