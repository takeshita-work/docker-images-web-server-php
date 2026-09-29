# docker-images_web-server-php

- レンタルサーバー等で使われている古いPHP環境をローカルのDockerで再現し、動作検証するためのDockerイメージ集
- PHP(Apache) / MySQL / MariaDB / phpMyAdmin / MailCatcher のDockerイメージをビルド・プッシュ・テストできる

[Docker Hub: takeshitawork/web-server-php](https://hub.docker.com/r/takeshitawork/web-server-php)

このリポジトリには用途の異なる2つのディレクトリがある。

- `containers/` — 公開済みの全イメージが正常に動作するかをまとめて確認するためのもの(このREADMEで説明)
- `sample/` — 実際の案件にコピーして使うテンプレート(「PHP 1つ + DB 1つ + phpMyAdmin 1つ」の実運用構成。詳細は [`sample/README.md`](sample/README.md) を参照)

## 提供イメージ一覧

### apache-php

<table>
<thead>
<tr>
<th width="100">バージョン</th>
<th width="170" align="center">Docker Hub タグ</th>
</tr>
</thead>
<tbody>
<tr><td>PHP 5.3</td><td align="center"><code>apache-php5.3</code></td></tr>
<tr><td>PHP 5.5</td><td align="center"><code>apache-php5.5</code></td></tr>
<tr><td>PHP 5.6</td><td align="center"><code>apache-php5.6</code></td></tr>
<tr><td>PHP 7.0</td><td align="center"><code>apache-php7.0</code></td></tr>
<tr><td>PHP 7.1</td><td align="center"><code>apache-php7.1</code></td></tr>
<tr><td>PHP 7.2</td><td align="center"><code>apache-php7.2</code></td></tr>
<tr><td>PHP 7.3</td><td align="center"><code>apache-php7.3</code></td></tr>
<tr><td>PHP 7.4</td><td align="center"><code>apache-php7.4</code></td></tr>
<tr><td>PHP 8.0</td><td align="center"><code>apache-php8.0</code></td></tr>
<tr><td>PHP 8.1</td><td align="center"><code>apache-php8.1</code></td></tr>
<tr><td>PHP 8.2</td><td align="center"><code>apache-php8.2</code></td></tr>
<tr><td>PHP 8.3</td><td align="center"><code>apache-php8.3</code></td></tr>
<tr><td>PHP 8.4</td><td align="center"><code>apache-php8.4</code></td></tr>
<tr><td>PHP 8.5</td><td align="center"><code>apache-php8.5</code></td></tr>
</tbody>
</table>

- `apache-php5.3` は**利用不可**。Dockerfileの中身が空のスタブ、かつベースイメージ`php:5.3-apache`自体が現行Dockerでは取得できない形式のため。compose.ymlでもコメントアウトしている
- `apache-php8.0` はionCube非対応バージョン

いずれも ionCube Loader / mcrypt(PECL) / mbstring / gd / zip / pdo_mysql / mysqli を有効化済み。メール送信はmsmtp経由で`smtp`(MailCatcher)に転送される。

`containers/compose.yml` ではバージョンごとに別々のポートを割り当てており、全バージョンを同時に起動できる。

### mysql / mariadb

<table>
<thead>
<tr>
<th width="170">バージョン</th>
<th width="150" align="center">Docker Hub タグ</th>
</tr>
</thead>
<tbody>
<tr><td>MySQL 5.7</td><td align="center"><code>mysql5.7</code></td></tr>
<tr><td>MySQL 8.0</td><td align="center"><code>mysql8.0</code></td></tr>
<tr><td>MySQL 8.4 (LTS)</td><td align="center"><code>mysql8.4</code></td></tr>
<tr><td>MariaDB 10.6</td><td align="center"><code>mariadb10.6</code></td></tr>
<tr><td>MariaDB 10.11 (LTS)</td><td align="center"><code>mariadb10.11</code></td></tr>
<tr><td>MariaDB 11.4 (LTS)</td><td align="center"><code>mariadb11.4</code></td></tr>
</tbody>
</table>

- `mysql8.4` は8.4で`default-authentication-plugin`が廃止されたため専用の`my.cnf`を使用

MySQL系とMariaDB系は文字コード設定の互換性が異なるため、`dockerfile/mysql/my.cnf`と`dockerfile/mariadb/my.cnf`は別ファイルで管理している。

### その他

<table>
<thead>
<tr>
<th width="110">イメージ</th>
<th width="140" align="center">Docker Hub タグ</th>
<th>備考</th>
</tr>
</thead>
<tbody>
<tr><td>phpMyAdmin</td><td align="center"><code>phpmyadmin</code></td><td>接続先DBごとに個別コンテナ</td></tr>
<tr><td>MailCatcher</td><td align="center"><code>mailcatcher</code></td><td>apache-phpからのメール送信を受信・確認する</td></tr>
</tbody>
</table>

## containers/ での動作確認

`containers/` は公開済みの全イメージが正常に動作するかを確認するためのもの。「実際の案件でどう使うか」のテンプレートではなく、あくまで動作確認用(実運用の構成例は [`sample/README.md`](sample/README.md) を参照)。

`containers/compose.yml` はバージョンごとに別々のポートを割り当てているため、コメントアウトせずに全サービスを同時に起動できる。

### 自動での動作確認

全サービスを起動し、それぞれ疎通確認まで自動で行い、最後にコンテナを削除するスクリプト。
```
./scripts/test/verify.ps1
```
- apache-php: HTTPでアクセスし、200かつ `Fatal error` を含まないことを確認
- mysql/mariadb: `mysqladmin`(`mariadb-admin`) ping で応答を確認
- phpMyAdmin: HTTPでアクセスし、ページ内に `phpMyAdmin` の文字列があることを確認
- MailCatcher: HTTPで200が返ることを確認

失敗した項目があれば一覧で表示し、終了コード1を返す(成功時は0)。成功・失敗にかかわらずコンテナは必ず削除される。

### 手動での動作確認

`start.ps1`/`stop.ps1`/`down.ps1`はいずれも引数無しで全サービス、引数にサービス名を指定するとそのサービスだけを対象にする(`<Tab>`で補完できる)。

1. コンテナを起動する(Docker Hub上のイメージが自動でpullされる)
    ```
    ./scripts/containers/start.ps1              # 全サービスを起動
    ./scripts/containers/start.ps1 apache-php8.3 # apache-php8.3 だけ起動
    ```
2. ブラウザで動作確認する(ポート番号は `containers/compose.yml` を参照)
    - Webサーバー: `http://localhost:{ポート}/`
    - phpMyAdmin: `http://localhost:{ポート}/`。ログインは `root` / `mysql_root_password`
    - MailCatcher: `http://localhost:{ポート}/`
3. コンテナ内に入って確認する場合(`<Tab>`でサービス名を補完できる。未起動なら自動的に起動してから接続する)
    ```
    ./scripts/containers/access.ps1 apache-php8.3
    ```
4. コンテナを停止する
    ```
    ./scripts/containers/stop.ps1              # 全サービスを停止
    ./scripts/containers/stop.ps1 apache-php8.3 # apache-php8.3 だけ停止
    ```
5. コンテナを削除する
    ```
    ./scripts/containers/down.ps1              # 全サービスを削除(ネットワークも削除)
    ./scripts/containers/down.ps1 apache-php8.3 # apache-php8.3 だけ削除
    ```

## リポジトリの構成

```
docker-images_web-server-php
|-- containers
|   `-- compose.yml                     ... 作成した docker image の動作確認用コンテナ定義
|-- sample
|   `-- ...                             ... 実案件にコピーして使うテンプレート(sample/README.md 参照)
|-- dockerfile
|   `-- {software}
|       |-- {version}
|       |   `-- Dockerfile              ... Dockerfile: {software}{version} で管理する場合
|       `-- Dockerfile                  ... Dockerfile: {software} で管理する場合
|-- scripts
|   |-- test
|   |   `-- verify.ps1                  ... containers/compose.yml を使った自動テスト
|   |-- containers
|   |   |-- access.ps1                  ... containers/compose.yml に定義したコンテナにアクセス(サービス名は<Tab>補完)
|   |   |-- __config.ps1
|   |   |-- down.ps1                    ... containers/compose.yml に定義したコンテナを削除
|   |   |-- start.ps1                   ... containers/compose.yml に定義したコンテナを起動
|   |   `-- stop.ps1                    ... containers/compose.yml に定義したコンテナを停止
|   `-- dockerfile
|       |-- {software}
|       |   |-- {version}
|       |   |   |-- build.ps1           ... Dockerfile: {software}{version} をビルド
|       |   |   |-- push.ps1            ... Dockerfile: {software}{version} のイメージを Docker Hub にプッシュ
|       |   |   `-- __config.ps1
|       |   |-- build.ps1               ... Dockerfile: {software} をビルド
|       |   |-- push.ps1                ... Dockerfile: {software} のイメージを Docker Hub にプッシュ
|       |   `-- __config.ps1
|       `-- __config.ps1
`-- README.md
```

リポジトリ名(Docker Hubのプッシュ先)は `scripts/dockerfile/__config.ps1` で `takeshitawork/web-server-php` に設定済み。

## 新しいバージョンを追加する

例: `apache-php` に新バージョン `X.Y` を追加する場合

1. `dockerfile/apache-php/apache-phpX.Y/Dockerfile` と `ioncube.ini` を、既存の近いバージョン(例: `apache-php8.3`)をコピーして作成する
    - ionCube を conf.d に配置する際は `00-ioncube.ini` という名前でCOPYする(後述の注意点を参照)
2. `scripts/dockerfile/apache-php/apache-phpX.Y/` に `__config.ps1`(バージョン名を設定)・`build.ps1`・`push.ps1` を用意する(`build.ps1`/`push.ps1`は他バージョンと同一内容でよい)
3. `scripts/dockerfile/apache-php/build_all.ps1` に追記する
4. `containers/compose.yml` にサービスを追加する(ポートは既存の続き番号を割り当てる)
5. ビルド・動作確認
    ```
    ./scripts/dockerfile/apache-php/apache-phpX.Y/build.ps1
    ./scripts/containers/start.ps1
    ```
6. 問題なければ Docker Hub にプッシュする
    ```
    ./scripts/dockerfile/apache-php/apache-phpX.Y/push.ps1
    ```

mysql・mariadbに新バージョンを追加する場合も同様の構成(`__config.ps1`でバージョンのみ指定、`build.ps1`/`push.ps1`は共通)。

## 既知の制限・注意点

- **apache-php5.3 は利用できない**。Dockerfileの中身が空である上、ベースイメージ`php:5.3-apache`のmanifest形式が古く、現行のDocker/containerdでは`pull`自体ができない
- **5.6〜8.0系を今から作り直す(`build.ps1`を実行する)と失敗する可能性が高い**。ベースのDebianリリースがEOLとなりパッケージアーカイブへの移行が進んでいるため。Docker Hub上の既存イメージは問題なく動作するので、再ビルドせずそのまま使う分には影響ない
- ionCube Loaderは`conf.d`内のファイル名のアルファベット順で読み込まれるため、他のzend_extensionより後に読み込まれると起動できない。新しいバージョンを追加する際は`00-ioncube.ini`という名前で配置すること
- ローカル検証用途を想定しており、外部公開を目的としたセキュリティ対策は行っていない
