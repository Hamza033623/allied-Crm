FROM php:7.4-apache

WORKDIR taha
RUN a2enmod rewrite


RUN apt-get update && apt-get install -y \
                libfreetype6-dev \
                libjpeg62-turbo-dev \
                libpng-dev \
        && docker-php-ext-configure gd --with-freetype --with-jpeg \
        && docker-php-ext-install -j$(nproc) gd

RUN docker-php-source extract \
        # do important things \
        && docker-php-source delete

RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

RUN apt-get update \
     && apt-get install -y libzip-dev \
     && docker-php-ext-install zip

RUN apt-get update && apt-get install -y libc-client-dev libkrb5-dev && rm -r /var/lib/apt/lists/*
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap

COPY . .

EXPOSE 80

CMD ["php","-S","0.0.0.0:80"]
