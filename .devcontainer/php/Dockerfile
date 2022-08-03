FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y software-properties-common git wget curl jq vim unzip mysql-client npm \
    && add-apt-repository ppa:ondrej/php \
    && apt-get update

RUN apt-get install -y \
    php7.4 \
    php7.1 \
    php7.1-apcu \
    php7.1-cli \
    php7.1-curl \
    php7.1-dev \
    php7.1-fpm \
    php7.1-gd \
    php7.1-json \
    php7.1-imagick \
    php7.1-intl \
    php7.1-mysql \
    php7.1-mcrypt \
    php7.1-xml \
    php7.1-zip \
    php7.1-xdebug
    
RUN update-alternatives --set php /usr/bin/php7.1

RUN sed -i \
    -e 's/.*\(short_open_tag\).*/\1 = On/' \
    -e 's/.*\(date.timezone\).*/\1 = UTC/' \
    /etc/php/7.1/fpm/php.ini

ADD 90-xdebug.ini /etc/php/7.1/fpm/conf.d/90-xdebug.ini

# Install node 8
RUN npm install -g n \
    && n 8

RUN adduser --home /home/developer \
   --shell /bin/bash \
   --uid 1000 \
   --disabled-password \
   -q developer

ENV BASEDIR=/code

WORKDIR ${BASEDIR}
RUN mkdir -p ${BASEDIR}/vendor \
   && mkdir -p ${BASEDIR}/node_modules \
   && mkdir -p ${BASEDIR}/app/cache \
   && chown -R developer:developer ${BASEDIR} \
   && chown -R developer ${BASEDIR}/app \
   && touch /var/log/php-fpm.log \
   && chown -R developer:developer /var/log/php-fpm.log


ADD php-fpm.conf /etc/php/7.1/fpm/pool.d/php-fpm.conf

USER developer

ENTRYPOINT [ "/usr/sbin/php-fpm7.1", "--nodaemonize", "--force-stderr", "--fpm-config", "/etc/php/7.1/fpm/pool.d/php-fpm.conf" ]
