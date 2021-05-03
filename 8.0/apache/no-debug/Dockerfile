FROM pimcore/pimcore:PHP8.0-apache-debug

# install mjml on global
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -; \
            apt-get install -y nodejs; \
            npm install -g mjml;

# update composer to latest version
RUN composer self-update

