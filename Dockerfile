FROM alpine:3.22

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk update && apk upgrade && \
    apk add --no-cache \
        nginx curl git bash nano vim openssl openssh-client busybox-suid tzdata \
        php84 php84-fpm php84-cli php84-opcache php84-mbstring php84-intl php84-curl \
        php84-pdo php84-pdo_mysql php84-json php84-session php84-ctype \
        php84-fileinfo php84-zip php84-gd php84-dom php84-xml php84-xmlwriter php84-phar \
        php84-simplexml php84-tokenizer php84-xmlreader php84-posix php84-pcntl \
        php84-iconv php84-ftp php84-sodium php84-sqlite3 php84-pdo_sqlite php84-pecl-redis \
        php84-bcmath php84-sockets php84-soap php84-gmp

RUN rm -rf /var/cache/apk/*

ARG TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo "${TZ}" > /etc/timezone

RUN ln -s /usr/bin/php84 /usr/bin/php

RUN addgroup -S www-data || true && \
    adduser -S -D -H -G www-data www-data || true && \
    mkdir -p /run/php /run/nginx /var/www/app && \
    chown -R www-data:www-data /var/www/app

COPY docker/cron/root /etc/crontabs/root
RUN touch /var/log/cron.log && \
    chown www-data:www-data /var/log/cron.log

RUN rm -f /etc/nginx/http.d/default.conf
COPY docker/nginx/app.conf /etc/nginx/http.d/app.conf

RUN mkdir -p /etc/ssl/private /etc/ssl/certs && \
    openssl req -x509 -nodes -days 6400 \
        -newkey rsa:2048 \
        -keyout /etc/ssl/private/selfsigned.key \
        -out /etc/ssl/certs/selfsigned.crt \
        -subj "/CN=localhost"

COPY docker/php-fpm/www.conf /etc/php84/php-fpm.d/www.conf

RUN curl -sS https://getcomposer.org/installer | php84 -- \
    --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/app
EXPOSE 443

CMD ["sh", "-c", "crond && php-fpm84 -D && nginx -g 'daemon off;'"]
