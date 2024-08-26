FROM phpmyadmin/phpmyadmin:latest

# カスタム設定をコピー
COPY dockerfile/phpmyadmin/phpmyadmin-misc.ini /usr/local/etc/php/conf.d/phpmyadmin-misc.ini

# 環境変数を設定
ENV MYSQL_ROOT_PASSWORD="mysql_root_password"
ENV PMA_USER=root
ENV PMA_PASSWORD="mysql_root_password"