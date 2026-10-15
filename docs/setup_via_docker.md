# 🐳Docker 環境をつかいセットアップする方法

1. **環境変数 `PASSWORD` にパスワードを設定する**<br>
    　以下のコマンドのように環境変数 `PASSWORD` に Docker 内ユーザー用に使用されるパスワードを設定してください．以下のコマンドの例は `password` というパスワードを設定します．`password` を置き換えて自分自身のパスワード文字列に変更してください．
    ```bash
    export PASSWORD=password
    ```

1. **Docker イメージ `erasers_kachaka` をビルドする**<br>
    　以下のコマンドを実行して `erasers_kachaka` Docker イメージをビルドします．本リポジトリでは2つのビルドオプションが用意されています．実装環境に合わせて選択してください．

    |プラットフォーム名|概要|
    |:---:|:---|
    |`desktop`|　`RViz2` などの GUI 環境を内包したパッケージ|
    |`headless`|　CUI に対応した最小パッケージ|

    - desktop
        ```bash
        docker compose build desktop
        ```
    - headless
        ```bash
        docker compose build headless
        ```

1. **Docker イメージが存在することを確認する**<br>
   　以下のコマンドを実行して  `erasers_kachaka:latest` という文字列が表示されることを確認してください．
    ```bash
    docker images | grep kachaka
    ```

1. **ワークスペースをビルドする**<br>
    　以下のコマンドを実行して， `scripts/colcon_build.sh` を実行するとワークスペースをビルドします．`<platform>` には前述した任意のプラットフォーム `desktop` または `headless` に差し替えてください．
    ```bash
    ./scripts/colcon_build.sh <platform>
    ```

1. **`docker_env` を編集して Kachaka との接続設定をする**<br>
    　このリポジトリ内にある [docker_env](/docker_env) を編集して，Kachaka との接続設定を行ってください．<br>
    　詳しい編集方法は [環境変数の設定方法](./setup_env.md) を参照してください．

1. **起動確認をする**<br>
    　次のコマンドを実行して Kachaka を起動します．`<platform>` には前述した任意のプラットフォーム `desktop` または `headless` に差し替えてください．
    このとき Kachaka から `「eR@sers Kachaka スタート！Domain Number is XX」` と発話したら成功です．
    ```bash
    ./scripts/bringup.sh <platform>
    ```
    　また，`docker_env` の `USE_RVIZ` が `True` ならば起動時に RViz が表示され，視覚化されたロボット情報が表示されます．RViz の操作方法については [RViz の操作方法](./about_kachaka_rviz.md) を参照してください．
