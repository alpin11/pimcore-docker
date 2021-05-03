FROM pimcore/pimcore:PHP7.4-apache-debug

LABEL maintainer="devs@alpin11.com"

# install mjml on global
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -; \
            apt-get install -y nodejs; \
            npm install -g mjml;

# update composer to latest version
RUN composer self-update

