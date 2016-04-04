FROM gliderlabs/alpine:latest
MAINTAINER Vojtěch Biberle <vojtech.biberle@gmail.com>

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk --update add \
  nginx \
  php-fpm \
  php-pdo \
  php-json \
  php-openssl \
  php-mysql \
  php-pdo_mysql \
  php-mcrypt \
  php-sqlite3 \
  php-pdo_sqlite \
  php-ctype \
  php-zlib \
  php-iconv \
  php-xdebug@testing \
  supervisor

RUN mkdir -p /etc/nginx \
   mkdir -p /run/nginx

RUN [ -f /etc/nginx/nginx.conf ] && rm /etc/nginx/nginx.conf || return 0
ADD nginx.conf /etc/nginx/nginx.conf

VOLUME ["/var/www", "/etc/nginx/sites-enabled"]

ADD nginx-supervisor.ini /etc/supervisor.d/nginx-supervisor.ini
ADD essentials.ini /etc/php/conf.d/essentials.ini
RUN sed -i "s/extension/zend_extension/g" /etc/php/conf.d/xdebug.ini 

EXPOSE 80 9000

CMD ["/usr/bin/supervisord"]
