FROM php:7.4-fpm-buster

LABEL maintainer="devs@alpin11.com"

RUN set -eux; \
    apt-get update; \
    apt-get install -y lsb-release; \
    echo "deb http://deb.debian.org/debian $(lsb_release -sc)-backports main" > /etc/apt/sources.list.d/backports.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        autoconf automake libtool nasm make pkg-config libz-dev build-essential openssl g++ \
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

# XDEBUG
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    autoconf automake libtool nasm make pkg-config libz-dev build-essential g++ iproute2; \
    pecl install xdebug-3.0.4; \
    docker-php-ext-enable xdebug; \
    apt-get autoremove -y; \
    apt-get remove -y autoconf automake libtool nasm make pkg-config libz-dev build-essential g++; \
    apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer;

# ENABLE DEBUG MODE in entrypoint.sh
ENV PHP_DEBUG 1
ENV PHP_IDE_CONFIG serverName=localhost

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
