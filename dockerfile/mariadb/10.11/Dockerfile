FROM mariadb:10.11

# カスタム設定をコピー
COPY dockerfile/mariadb/my.cnf /etc/mysql/conf.d/my.cnf

# 環境変数を設定
ENV MYSQL_ROOT_PASSWORD="mysql_root_password"
