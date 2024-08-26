FROM php:8.1-apache

RUN \
  apt-get -qq update && \
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
    && \
  # htaccess を有効に
  a2enmod rewrite && \
  # ssl を有効に
  a2enmod ssl  && \
  # ssiを 有効に
  a2enmod include && \
  # default-ssl の設定を有効に
  a2ensite default-ssl && \
  # mcrypt の拡張をインストール
  pecl install mcrypt && \
  docker-php-ext-enable mcrypt

# ioncube の設置
RUN mkdir /var/ioncube \
    && curl -sL https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    | tar zx -C /var/ioncube  --strip-components 1

# php.ini の設置
COPY dockerfile/apache-php/etc/php.ini /usr/local/etc/php/php.ini
COPY dockerfile/apache-php/apache-php8.1/ioncube.ini /usr/local/etc/php/conf.d

# apache の設定ファイルの設置
COPY dockerfile/apache-php/etc/apache2/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY dockerfile/apache-php/etc/apache2/000-default.conf /etc/apache2/sites-available/000-default.conf

# メール送信の設定
COPY dockerfile/apache-php/etc/msmtprc /etc/msmtprc