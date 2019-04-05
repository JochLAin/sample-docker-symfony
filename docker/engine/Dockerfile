FROM php:7.1-fpm

WORKDIR /home/docker

ARG PHP_APCU_VERSION=5.1.7
ARG PHP_XDEBUG_VERSION=2.5.0

RUN useradd -u 1000 -d /home/wanauser -m wanauser \
    && apt update \
    && apt install -y \
        python-pip \
        python-dev \
        build-essential \
        git \
        libicu-dev \
        libpq-dev \
        libxml2-dev \
        libldap2-dev \
        libpng-dev \
        zlib1g-dev \
    && python -m pip install --upgrade pip \
    && python -m pip install \
        libsass \
    && docker-php-source extract \
    && curl -L -o /tmp/apcu-$PHP_APCU_VERSION.tgz https://pecl.php.net/get/apcu-$PHP_APCU_VERSION.tgz \
    && tar xfz /tmp/apcu-$PHP_APCU_VERSION.tgz \
    && rm -r \
        /tmp/apcu-$PHP_APCU_VERSION.tgz \
    && mv apcu-$PHP_APCU_VERSION /usr/src/php/ext/apcu \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install -j$(nproc) \
        apcu \
        bcmath \
        calendar \
        intl \
        ldap \
        gd \
        mbstring \
        opcache \
        pdo_pgsql \
        xml \
        zip \
    && docker-php-source delete \
    && php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer

ARG BUILD_ENV=dev

RUN if [ "$BUILD_ENV" = "dev" ]; then \
        docker-php-source extract \
        && curl -L -o /tmp/xdebug-$PHP_XDEBUG_VERSION.tgz http://xdebug.org/files/xdebug-$PHP_XDEBUG_VERSION.tgz \
        && tar xfz /tmp/xdebug-$PHP_XDEBUG_VERSION.tgz \
        && rm -r \
            /tmp/xdebug-$PHP_XDEBUG_VERSION.tgz \
        && mv xdebug-$PHP_XDEBUG_VERSION /usr/src/php/ext/xdebug \
        && docker-php-ext-install \
            xdebug \
        && docker-php-source delete \
    ; fi

COPY ./docker/engine/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

COPY ./docker/engine/php.ini /usr/local/etc/php/conf.d/custom.ini
COPY . /home/docker

RUN if [ "$BUILD_ENV" = "prod" ]; then \
        SYMFONY_ENV=prod composer install -o --no-progress --no-scripts \
        && mkdir -p var/cache var/log \
        && chmod 777 -R var/cache var/log \
    ; fi

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]
