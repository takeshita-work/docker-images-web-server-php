FROM php:7.0-apache

RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian/|g' /etc/apt/sources.list
RUN sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list
RUN sed -i 's|http://archive.debian.org/debian stretch-updates|# http://archive.debian.org/debian stretch-updates|g' /etc/apt/sources.list
RUN sed -i '/stretch-updates/d' /etc/apt/sources.list

RUN apt-get -o Acquire::Check-Valid-Until=false -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true update

RUN \
  # 必要なライブラリの導入
  apt-get -qq install -y --no-install-recommends \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    zlib1g-dev \
    libzip-dev\
    libssl-dev \
    libonig-dev \
    openssl \
    #自己署名証明書発行のために導入
    ssl-cert \
    #メール送信の設定
    msmtp mailutils \
    && \
  # 拡張をインストール
  docker-php-ext-install \
    pdo_mysql \
    mysqli \
    mbstring \
    gd \
    zip \
    mcrypt \
    && \
  # htaccess を有効に
  a2enmod rewrite && \
  # ssl を有効に
  a2enmod ssl  && \
  # ssiを 有効に
  a2enmod include && \
  # default-ssl の設定を有効に
  a2ensite default-ssl

# ioncube の設置
RUN mkdir /var/ioncube \
    && curl -sL https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    | tar zx -C /var/ioncube  --strip-components 1

ARG php_path
ARG php_version

# php.ini の設置
COPY dockerfile/apache-php/etc/php.ini /usr/local/etc/php/php.ini
COPY dockerfile/apache-php/apache-php7.0/ioncube.ini /usr/local/etc/php/conf.d

# apache の設定ファイルの設置
COPY dockerfile/apache-php/etc/apache2/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY dockerfile/apache-php/etc/apache2/000-default.conf /etc/apache2/sites-available/000-default.conf

# メール送信の設定
COPY dockerfile/apache-php/etc/msmtprc /etc/msmtprc