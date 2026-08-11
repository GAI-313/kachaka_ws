# 🤖 ROS2 環境をつかいセットアップする方法

> [!IMPORTANT]
> 　このリポジトリは **Ubuntu 22.04** 専用です．本セットアップを行う前に [**ROS2 Humble インストールドキュメント**](https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debs.html) を参考に ROS2 Humble をインストールしてください．<br>
> 　もし Ubuntu 22.04 以外のディストリビューションを利用している場合は，[**🐳Docker 環境をつかいセットアップする方法**](./setup_via_docker.md) を参照してください．

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

1. **必要なパッケージをダウンロードする**<br>
    　以下のコマンドを実行して `thirdparty` ディレクトリ内に `erasers_kachaka` の依存関係パッケージをクローンします．
    ```bash
    vcs import thirdparty < src/erasers_kachaka/depends.repos
    ```

1. **依存関係パッケージを自動インストールする**<br>
    　以下のコマンドを実行して `apt` パッケージを更新してください．
    ```bash
    sudo apt update
    ```
    　以下のコマンドを実行して ROS2 を通してください．
    ```bash
    source /opt/ros/humble/setup.bash
    ```
    　以下のコマンドを実行して `rosdep` を使用して依存関係パッケージをインストールします．インストール完了には時間がかかります．
    ```bash
    rosdep install -y -i --from-path .
    ```

1. **Python 依存関係をインストールする**<br>
    　以下のコマンドを実行して Python の依存関係をインストールします．
    ```bash
    pip install -r src/erasers_kachaka/requirements.txt
    ```

1. **ワークスペースをビルドする**<br>
    　以下のコマンドを実行してワークスペースをビルドします．
    ```bash
    colcon build --symlink-install --packages-up-to erasers_kachaka_brngup
    ```
    　ビルドが完了したらセットアップ完了です．

1. **動作確認**<br>
    　以下のコマンドを実行してワークスペースを通します．
    ```bash
    source ./install/setup.bash
    ```
    　以下のコマンドを実行して `kachaka` を含むパッケージがビルドされているかを確認します．
    ```bash
    ros2 pkg list | grep kachaka
    ```
    　このコマンドを実行したとき，次のパッケージらが出力されたら成功です．
    ```
    erasers_kachaka_bringup
    erasers_kachaka_cartographer
    erasers_kachaka_common
    erasers_kachaka_description
    erasers_kachaka_navigation
    erasers_kachaka_teleop
    erasers_kachaka_vision
    kachaka_description
    kachaka_grpc_ros2_bridge
    kachaka_interfaces
    kachaka_shelf_description
    ```
