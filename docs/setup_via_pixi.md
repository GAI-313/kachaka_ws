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

1. **`thirdparty` ディレクトリを作成する**<br>
    　以下のコマンドを実行して `kachaka_ws` 内に `thirdparty` ディレクトリを作成してください．
    ```bash
    mkdir thirdparty
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

## トラブルシューティング

- **`pixi run colcon_build` 実行時にエラーが発生する．**<br>
    　以下のエラーが発生した場合，`pixi` の更新が必要です．
    ```bash
        Error:   × Failed to load lock file from `/Users/gai/kachaka_ws/pixi.lock`
      ╰─▶ The lock file version is 7, but only up to including version 6 is supported by the current version.
      help: Please update pixi to the latest version and try again.
    ```
    　pixi の更新には以下のコマンドを実施します．
    ```bash
    pixi self-update
    ```
