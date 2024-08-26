# docker-images_template

- Docker イメージ を作成するときのテンプレート

[Docker Hub](https://hub.docker.com/explore)

## 開発について

```
docker-images_template
|-- docker-compose
|   `-- compose.yml                     ... 作成した docker image をコンテナ
|-- dockerfile
|   `-- {software}
|       |-- {version}
|       |   `-- Dockerfile              ... Dockerfile: {software}{version} で管理する場合
|       `-- Dockerfile                  ... Dockerfile: {software} で管理する場合
|-- scripts
|   |-- docker-compose
|   |   |-- access
|   |   |   `-- {software}{version}.ps1 ... docker/compose.yml に定義したコンテナにアクセス
|   |   |-- __config.ps1
|   |   |-- down.ps1                    ... docker/compose.yml に定義したコンテナを削除
|   |   |-- start.ps1                   ... docker/compose.yml に定義したコンテナを起動
|   |   `-- stop.ps1                    ... docker/compose.yml に定義したコンテナを停止
|   `-- dockerfile
|       |-- {software}
|       |   |-- {version}
|       |   |   |-- build.ps1           ... Dockerfile: {software}{version} をビルド
|       |   |   |-- push.ps1            ... Dockerfile: {software}{version} のイメージを docDocker Hub にプッシュ
|       |   |   `-- __config.ps1
|       |   |-- build.ps1               ... Dockerfile: {software} をビルド
|       |   |-- push.ps1                ... Dockerfile: {software} のイメージを docDocker Hub にプッシュ
|       |   `-- __config.ps1
|       `-- __config.ps1
`-- README.md
```

### docker イメージ

ディレクトリ名, ファイル名, ファイル内の `{software}`, `{version}` を適切に変更する

#### リポジトリ名の 設定

- docker イメージ の名称の設定

    ./scripts/dockerfile/__config.ps1 で行う

    - Docker Hub に プッシュする場合
        ```
        $global:repositoryName = "organization/repository"
        ```
        ※ 設定したものが Docker Hub のリポジトリ名になる

    - ローカルのみで利用する場合
        ```
        $global:repositoryName = "repository"
        ```

#### Dockerfile の定義

- ソフトウェアとバージョンごとで管理する場合
    - Dockerfile の定義
        - dockerfile/{software}/{version}/Dockerfile に定義する

    - 設定
        - scripts/dockerfile/{software}/__config.ps1 に ソフトウェア名を定義する
        - scripts/dockerfile/{software}/{version}/__config.ps1 に バージョンを定義する

- ソフトウェアごとで管理する場合
    - Dockerfile の定義
        - dockerfile/{software}/Dockerfile に定義する

    - 設定
        - scripts/dockerfile/{software}/__config.ps1 に ソフトウェア名を定義する

#### 操作

- ソフトウェアとバージョンごとで管理する場合
    - ビルド
        ```
        ./scripts/dockerfile/{software}/{version}/build.ps1
        ```

        ローカルに docker イメージ がビルドされる
        - イメージ名は `リポジトリ名` になる
        - タグは、`{software}{version}`, `{software}{version}_yyyymm` になる. タグを変更修正する場合は ps1 ファイルを修正.

    - プッシュ
        ```
        ./scripts/dockerfile/{software}/{version}/push.ps1
        ```

        ローカルの docker イメージ が Docker Hub にプッシュされる
        - イメージ名は `リポジトリ名` になる
        - タグは、`{software}{version}`, `{software}{version}_yyyymm` になる. タグを変更修正する場合は ps1 ファイルを修正.

- ソフトウェアごとで管理する場合
    - ビルド
        ```
        ./scripts/dockerfile/{software}/build.ps1
        ```

        ローカルに docker イメージ がビルドされる
        - イメージ名は `リポジトリ名` になる
        - タグは、`{software}`, `{software}_yyyymm` になる. タグを変更修正する場合は ps1 ファイルを修正.

    - プッシュ
        ```
        ./scripts/dockerfile/{software}/push.ps1
        ```

        ローカルの docker イメージ が Docker Hub にプッシュされる
        - イメージ名は `リポジトリ名` になる
        - タグは、`{software}`, `{software}_yyyymm` になる. タグを変更修正する場合は ps1 ファイルを修正.

### コンテナでのテスト

#### 設定

- コンテナプロジェクト の名称の設定

    ./scripts/docker-compose/__config.ps1 で行う
    ```
    $global:composeProjectName = ""
    ```

#### テストの実施

1. `./docker-compose/compose.yml` にテスト対象のコンテナを定義
    ```
    services:
      container-name_software-version:
        image: repository:software-version
    ```
    - ローカルにビルドされた docker イメージ を指定する

1. コンテナ の起動
    ```
    ./scripts/docker-compose/start.ps1
    ```

    - `./docker-compose/compose.yml` に定義したすべてのコンテナが起動

1. 動作を確認する

    - コンテナに接続して動作を確認する

        ```
        ./scripts/docker-compose/access/{software}{version}.ps1
        ```

1. コンテナを停止する
    ```
    ./scripts/docker-compose/stop.ps1
    ```

1. コンテナを削除する
    ```
    ./scripts/docker-compose/down.ps1
    ```
