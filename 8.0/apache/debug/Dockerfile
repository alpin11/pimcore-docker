FROM pimcore/pimcore:PHP8.0-apache

LABEL maintainer="devs@alpin11.com"

# install mjml on global
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -; \
            apt-get install -y nodejs; \
            npm install -g mjml;

# update composer to latest version
RUN composer self-update

RUN echo 'alias cache:clear="bin/console cache:clear && chown www-data: . -R "' >> ~/.bashrc
RUN echo 'alias pimcore:cache:clear="bin/console cache:clear"' >> ~/.bashrc
RUN source ~/.bashrc