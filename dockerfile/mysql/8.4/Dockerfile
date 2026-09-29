FROM mysql:8.4

# カスタム設定をコピー
# 8.4 では default-authentication-plugin が廃止されたため、5.7/8.0 と共有の my.cnf ではなく専用の my.cnf を使用する
COPY dockerfile/mysql/8.4/my.cnf /etc/mysql/conf.d/my.cnf

# 環境変数を設定
ENV MYSQL_ROOT_PASSWORD="mysql_root_password"
