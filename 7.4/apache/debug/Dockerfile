FROM pimcore/pimcore:PHP7.4-apache-debug

LABEL maintainer="devs@alpin11.com"

# install mjml on global
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -; \
            apt-get install -y nodejs; \
            npm install -g mjml; \
            npm install -g yarn;

# update composer to latest version
RUN composer self-update

# add aliases
RUN echo 'alias cache:clear="bin/console cache:clear && chown www-data: . -R "' >> /root/.bashrc
RUN echo 'alias pimcore:cache:clear="bin/console cache:clear"' >> /root/.bashrc
RUN echo 'alias composer:update="composer clearcache && composer update"' >> /root/.bashrc
RUN echo 'alias fix-phars="php -r \"$phar = new Phar(\"vendor/phpstan/phpstan/phpstan.phar\"); $phar->extractTo(\"vendor/phpstan/phpstan/phpstan.tmp\");\" && rm vendor/phpstan/phpstan/{phpstan,phpstan.phar} && mv vendor/phpstan/phpstan/{phpstan.tmp,phpstan}"' >> /root/.bashrc
