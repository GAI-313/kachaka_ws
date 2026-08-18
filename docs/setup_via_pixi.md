# Pixi を使いセットアップする方法

1. **pixi をインストールする**<br>
    　以下のコマンドを実行して `pixi` をインストールしてください．
    ```bash
    curl -fsSL https://pixi.sh/install.sh | sh
    ```
    　インストール完了後以下のコマンドを実行してターミナルを再読込してください．
    ```bash
    source ~/.bashrc
    ```

1. **`kachaka_ws` をクローンする**<br>
    　以下のコマンドを実行して `kachaka_ws` をクローン（ダウンロード）してください．
    ```bash
    git clone --recursive https://github.com/GAI-313/kachaka_ws.git
    ```

1. **ワークスペースを構築する**<br>
    　以下のコマンドを実行してワークスペースを構築します．このコマンドでは依存関係のインストールからパッケージのビルドまで一括で行われます．
    ```bash
    pixi run colcon_build
    ```

1. **環境変数の設定**<br>
    　[環境変数の設定方法](./setup_env.md) を参考に [pixi.toml](/pixi.toml) の `[activation.env]` 内の環境変数を設定してください．

1. **起動**<br>
    　以下のコマンドを実行して `erasers_kahcaka` を起動します．
    ```bash
    pixi run bringup
    ```