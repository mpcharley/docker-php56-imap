FROM php:5.6-apache

RUN echo "IncludeOptional /apache/*.conf\n" >> /etc/apache2/apache2.conf

RUN a2enmod rewrite

RUN apt-get update && \
    apt-get -y install \
        gnupg2 && \
    apt-key update && \
    apt-get update && \
    apt-get -y install --no-install-recommends \
            g++ \
            git \
            curl \
            imagemagick \
            libcurl3-dev \
            libicu-dev \
            libfreetype6-dev \
            libjpeg-dev \
            libjpeg62-turbo-dev \
            libonig-dev \
            libmagickwand-dev \
            libpq-dev \
            libpng-dev \
            libmcrypt-dev \
            libxml2-dev \
            libzip-dev \
            zlib1g-dev \
            default-mysql-client \
            openssh-client \
            nano \
            unzip \
            libcurl4-openssl-dev \
            libssl-dev \
            libc-client-dev \
            libkrb5-dev && \
            apt-get clean && \
            rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install PHP extensions required for Yii 2.0 Framework

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install -j$(nproc) imap

RUN docker-php-ext-configure bcmath && \
    docker-php-ext-install \
        soap \
        zip \
        curl \
        bcmath \
        exif \
        iconv \
        intl \
        mbstring \
        opcache \
        pdo_mysql \
        pdo_pgsql 
        
# Install PECL extensions
RUN printf "\n" | pecl install \
        imagick \
        mongodb && \
    docker-php-ext-enable \
        imagick \
        mongodb 

RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/3.1.0.tar.gz \
    && tar xfz /tmp/redis.tar.gz \
    && mkdir -p  /usr/src/php/ext/redis \
    && rm -r /tmp/redis.tar.gz \
    && mv ./phpredis-3.1.0/* /usr/src/php/ext/redis/ \
    && ls -Al ./ \
    && ls -Al /usr/src/php/ext/redis \

    && docker-php-ext-configure redis \
    && docker-php-ext-install redis 


