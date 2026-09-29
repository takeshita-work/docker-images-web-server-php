# Docker Web Server Sample

ローカルの Docker で PHP の開発環境をセットアップする。案件ごとに `.docker` フォルダごとプロジェクトルートにコピーして使う。

イメージは [takeshitawork/web-server-php](https://hub.docker.com/r/takeshitawork/web-server-php) を使用する。

## 利用可能なバージョン

- `PHP_VERSION`: `5.5` / `5.6` / `7.0` / `7.1` / `7.2` / `7.3` / `7.4` / `8.0` / `8.1` / `8.2` / `8.3` / `8.4` / `8.5`
- `DB_ENGINE` + `DB_VERSION`:
    - `mysql`: `5.7` / `8.0` / `8.4`
    - `mariadb`: `10.6` / `10.11` / `11.4`

各バージョンの詳細・既知の制限事項はイメージ本体のリポジトリの [README](https://github.com/takeshita-work/docker-images-web-server-php#提供イメージ一覧) を参照。

## 開発の流れ

1. `.docker/.env.sample` をコピーして `.docker/.env` を作成し、案件に合わせて値を設定する
    ```
    COMPOSE_PROJECT_NAME=00_docker-web-server-sample
    PHP_VERSION=8.3
    DB_ENGINE=mysql
    DB_VERSION=8.0
    APP_DIR=./src
    ```
    - `DB_ENGINE` は `mysql` か `mariadb` を指定する
    - `DB_VERSION` は `DB_ENGINE` に応じたバージョンを指定する(mysql: `5.7`|`8.0`|`8.4`、mariadb: `10.6`|`10.11`|`11.4`)

1. 環境を構築する
    ```
    .docker/scripts/start.ps1
    ```
    - ホスト側のポートが案件間で共通のため、**同時に起動できるのは1案件分のみ**。`start.ps1`/`stop.ps1`/`down.ps1`は実行前に「ホスト側のポートを使っている」かつ「コンテナ名が`terimukuri_`で始まる」コンテナだけを自動で停止する(無関係なコンテナや`terimukuri_`以外の命名の環境には影響しない)

1. 開発作業

    - `src` 以下にコードを設置する
    - `src/html` 以下がブラウザで公開される(ポート番号は `.docker/compose.yml` を参照)
    - データベースは phpMyAdmin からセットアップする
    - PHP からメールを送信するとメールキャッチャーで確認できる
    - コンテナ内に入って確認する場合
        ```
        .docker/scripts/access.ps1
        ```

1. 環境を停止する
    ```
    .docker/scripts/stop.ps1
    ```

1. 環境を削除する(コンテナ・ネットワークを削除。DBのデータはvolumeに残る)
    ```
    .docker/scripts/down.ps1
    ```