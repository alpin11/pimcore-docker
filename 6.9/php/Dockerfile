FROM php:7.4-fpm-buster

LABEL maintainer="devs@alpin11.com"

RUN set -eux; \
    apt-get update; \
    apt-get install -y lsb-release; \
    echo "deb http://deb.debian.org/debian $(lsb_release -sc)-backports main" > /etc/apt/sources.list.d/backports.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        autoconf automake libtool acl nasm make pkg-config libz-dev build-essential openssl g++ \
        zlib1g-dev libicu-dev libbz2-dev libc-client-dev \
        libkrb5-dev libxml2-dev libxslt1.1 libxslt1-dev locales locales-all \
        ffmpeg html2text ghostscript libreoffice pngcrush jpegoptim exiftool poppler-utils git wget \
        libx11-dev python3-pip opencv-data webp graphviz cmake ninja-build unzip cron \
        liblcms2-dev liblqr-1-0-dev libopenjp2-7-dev libtiff-dev \
        libfontconfig1-dev libfftw3-dev libltdl-dev liblzma-dev libopenexr-dev \
        libwmf-dev libdjvulibre-dev libpango1.0-dev libxext-dev libxt-dev librsvg2-dev libzip-dev \
        libpng-dev libfreetype6-dev libjpeg-dev libxpm-dev libwebp-dev libjpeg62-turbo-dev libonig-dev \
        ufraw; \
    \
    docker-php-ext-install intl mbstring mysqli bcmath bz2 soap xsl pdo pdo_mysql fileinfo exif zip opcache; \
    \
    # Configure LDAP.
    apt-get update; \
    apt-get install libldap2-dev -y; \
    rm -rf /var/lib/apt/lists/*; \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/; \
    docker-php-ext-install ldap; \
    \
    wget http://www.imagemagick.org/download/ImageMagick.tar.gz; \
        tar -xvf ImageMagick.tar.gz; \
        cd ImageMagick-7.*; \
        ./configure; \
        make; \
        make install; \
        ldconfig /usr/local/lib; \
        cd ..; \
        rm -rf ImageMagick*; \
    \
    docker-php-ext-configure gd -enable-gd --with-freetype --with-jpeg --with-webp; \
    docker-php-ext-install xmlrpc gd; \
    pecl install imagick; \
    pecl install apcu; \
    pecl install redis; \
    docker-php-ext-enable redis imagick apcu; \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl; \
    docker-php-ext-install imap; \
    docker-php-ext-enable imap; \
    docker-php-ext-install sockets; \
    docker-php-ext-enable sockets; \
    docker-php-ext-install ldap; \
    docker-php-ext-enable ldap; \
    \
    cd ~; \
    \
    wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz; \
        tar xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz; \
        mv wkhtmltox/bin/wkhtmlto* /usr/bin/; \
        rm -rf wkhtmltox; \
    \
    git clone https://github.com/mozilla/mozjpeg.git ; \
        cd mozjpeg; \
        cmake -G"Unix Makefiles"; \
        make; \
        make install; \
        ln -s /opt/mozjpeg/bin/cjpeg /usr/bin/cjpeg; \
        cd ..; \
        rm -rf mozjpeg; \
    \
    git clone https://gitlab.com/wavexx/facedetect; \
        pip3 install --upgrade pip setuptools wheel; \
        pip3 install scikit-build; \
        pip3 install numpy opencv-python; \
        cd facedetect; \
        cp facedetect /usr/local/bin; \
        cd ..; \
        rm -rf facedetect; \
    \
    git clone https://github.com/google/zopfli.git; \
        cd zopfli; \
        make; \
        cp zopfli /usr/bin/zopflipng; \
        cd ..; \
        rm -rf zopfli; \
    \
    wget http://static.jonof.id.au/dl/kenutils/pngout-20150319-linux.tar.gz; \
        tar -xf pngout-20150319-linux.tar.gz; \
        rm pngout-20150319-linux.tar.gz; \
        cp pngout-20150319-linux/x86_64/pngout /bin/pngout; \
        cd ..; \
        rm -rf pngout-20150319-linux; \
    \
    wget http://prdownloads.sourceforge.net/advancemame/advancecomp-1.17.tar.gz; \
        tar zxvf advancecomp-1.17.tar.gz; \
        cd advancecomp-1.17; \
        ./configure; \
        make; \
        make install; \
        cd ..; \
        rm -rf advancecomp-1.17; \
    \
    curl -sL https://deb.nodesource.com/setup_14.x | bash -; \
        apt-get install -y nodejs; \
        npm install -g sqip; \
    \
    apt-get autoremove -y; \
        apt-get remove -y autoconf automake libtool nasm make cmake ninja-build pkg-config libz-dev build-essential g++; \
        apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer

# MJML and YARN
RUN npm install -g mjml; \
    npm install -g yarn;

# COMPOSER
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_MEMORY_LIMIT -1
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# MYSQL client
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8C718D3B5072E1F5
RUN echo "deb http://repo.mysql.com/apt/debian/ buster mysql-8.0" > /etc/apt/sources.list.d/mysql.list
RUN apt-get update; \
    apt-get install -y --no-install-recommends mysql-client

# XDEBUG
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    autoconf automake libtool nasm make pkg-config libz-dev build-essential g++ iproute2; \
    pecl install xdebug-3.0.4; \
    docker-php-ext-enable xdebug; \
    apt-get autoremove -y; \
    apt-get remove -y autoconf automake libtool nasm make pkg-config libz-dev build-essential g++; \
    apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer;

# BLACKFIRE PROBE
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && architecture=$(case $(uname -m) in i386 | i686 | x86) echo "i386" ;; x86_64 | amd64) echo "amd64" ;; aarch64 | arm64 | armv8) echo "arm64" ;; *) echo "amd64" ;; esac) \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/$architecture/$version \
    && mkdir -p /tmp/blackfire \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get ('extension_dir');")/blackfire.so \
    && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz

# BLACKFIRE CLI
RUN mkdir -p /tmp/blackfire \
    && architecture=$(uname -m) \
    && curl -A "Docker" -L https://blackfire.io/api/v1/releases/cli/linux/$architecture | tar zxp -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire /usr/bin/blackfire \
    && rm -Rf /tmp/blackfire

# install amqp extension
RUN apt-get update -y \
    && apt-get -y install gcc make autoconf libc-dev pkg-config \
    && apt-get -y install libssl-dev librabbitmq-dev \
    && pecl install amqp \
    && docker-php-ext-enable amqp

#- ./.docker/php/php-ini-overrides.ini:/usr/local/etc/php/conf.d/99-overrides.ini
COPY php-ini-overrides.ini /usr/local/etc/php/conf.d/99-overrides.ini

# ENTRYPOINT
COPY entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["php-fpm"]

# add aliases
RUN echo 'alias cache:clear="bin/console cache:clear && chown www-data: . -R "' >> /root/.bashrc
RUN echo 'alias pimcore:cache:clear="bin/console cache:clear"' >> /root/.bashrc
RUN echo 'alias composer:update="composer clearcache && composer update"' >> /root/.bashrc
RUN echo 'alias fix-phars="php -r \"$phar = new Phar(\"vendor/phpstan/phpstan/phpstan.phar\"); $phar->extractTo(\"vendor/phpstan/phpstan/phpstan.tmp\");\" && rm vendor/phpstan/phpstan/{phpstan,phpstan.phar} && mv vendor/phpstan/phpstan/{phpstan.tmp,phpstan}"' >> /root/.bashrc
RUN echo 'alias ll="ls -la"' >> /root/.bashrc
RUN echo 'alias phpx="php -dxdebug.start_with_request=yes"' >> /root/.bashrc
