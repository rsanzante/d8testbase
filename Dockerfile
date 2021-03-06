FROM php:7.1.13-apache

ADD ./scripts/prepare_container.sh /

# Add Backports to sources (to install Java).
RUN echo "deb http://http.debian.net/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list

# Note: Libgconf is required by Chrome Driver.
RUN apt-get update && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng12-dev libbz2-dev libmcrypt-dev unzip git build-essential wget xvfb libgconf-2-4
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install -j$(nproc) bz2
RUN docker-php-ext-install -j$(nproc) mcrypt
RUN docker-php-ext-install -j$(nproc) pdo_mysql
RUN docker-php-ext-install -j$(nproc) mysqli
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -


RUN apt-get install -y apt-utils \
    && { \
        echo debconf debconf/frontend select Noninteractive; \
        echo mysql-community-server mysql-community-server/data-dir \
            select ''; \
        echo mysql-community-server mysql-community-server/root-pass \
            password 'root'; \
        echo mysql-community-server mysql-community-server/re-root-pass \
            password 'root'; \
        echo mysql-community-server mysql-community-server/remove-test-db \
            select true; \
    } | debconf-set-selections \
    && apt-get install -y nodejs mariadb-client mariadb-server apache2 \
    && apt-get install -y -t jessie-backports openjdk-8-jre-headless ca-certificates-java

RUN /prepare_container.sh

ENTRYPOINT ["docker-php-entrypoint"]
##<autogenerated>##
CMD ["bash"]

