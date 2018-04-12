## Bootstrap from PHP container
FROM php:7.2-apache

## Setting up default workdir
WORKDIR "/var/www/html"

## Copy apache config file to container
COPY apache.conf /etc/apache2/sites-enabled/000-default.conf

## Add PHP Core Extensions, like GD Library, iconv, MySQLI, Gettext
RUN apt-get update && apt-get install -y \
				software-properties-common \
				git \
                locales \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
    && docker-php-ext-install -j$(nproc) iconv mysqli gettext \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo pdo_mysql \
    && docker-php-ext-enable mysqli gettext


# Set locales
RUN echo "hu_HU.UTF-8 UTF-8" >> /etc/locale.gen 
RUN locale-gen

## Add GIT LFS
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
RUN apt-get install git-lfs

## Add mcrypt via PECL
RUN pecl install mcrypt-1.0.1
RUN docker-php-ext-enable mcrypt

RUN rm -rf /var/lib/apt/lists/*

## Enable modrewrite and SSL module
RUN a2enmod rewrite
RUN a2enmod ssl