# 🤖ROS2 環境をつかいセットアップする方法

> [!IMPORTANT]
> 　このリポジトリは **Ubuntu 22.04** 専用です．本セットアップを行う前に [**ROS2 Humble インストールドキュメント**](https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debs.html) を参考に ROS2 Humble をインストールしてください．<br>
> 　もし Ubuntu 22.04 以外のディストリビューションを利用している場合は，[**🐳Docker 環境をつかいセットアップする方法**](./setup_via_docker.md) を参照してください．

1. **`kachaka_ws` をクローンする**<br>
    　以下のコマンドを実行して `kachaka_ws` をクローン（ダウンロード）してください．
    ```bash
    git clone --recursive https://github.com/GAI-313/kachaka_ws.git
    ```

1. **セットアップに必要なコマンドを確認する**<br>
    　Ubuntu 22.04 に ROS 2 Humble をインストールしたうえで，`git`，`vcs`，`colcon`，`pip`，`protoc`，`grpc_cpp_plugin` を使用できる状態にしてください．ROS 2 Humble のインストール方法は，[ROS2 Humble インストールドキュメント](https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debs.html)を参照してください．
    　ワークスペース内の依存関係パッケージは，後述する `rosdep install` でインストールします．

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

1. **protobuf などの依存関係をインストールする**<br>
    ```bash
    sudo apt update &&\
    sudo apt install -y \
        libprotobuf-dev \
        libgrpc++-dev \
        nlohmann-json3-dev \
        protobuf-compiler-grpc
    ```

1. **protobuf から gRPC のソースコードを生成する**<br>
    　`kachaka-api` の protobuf 定義から，`kachaka_grpc_ros2_bridge` が使用する C++ ソースコードを生成してください．
    ```bash
    mkdir -p thirdparty/kachaka-api/ros2/kachaka_grpc_ros2_bridge/gen-src
    protoc -I thirdparty/kachaka-api/protos \
      --grpc_out=thirdparty/kachaka-api/ros2/kachaka_grpc_ros2_bridge/gen-src \
      --plugin=protoc-gen-grpc=/usr/bin/grpc_cpp_plugin \
      --cpp_out=thirdparty/kachaka-api/ros2/kachaka_grpc_ros2_bridge/gen-src \
      thirdparty/kachaka-api/protos/*.proto
    ```

1. **rosdep を初期化して依存関係パッケージを自動インストールする**<br>
    　`rosdep` を初めて使用する場合は，以下のコマンドを一度だけ実行してください．既に初期化済みというエラーが表示された場合は，`rosdep update` へ進んでください．
    ```bash
    sudo rosdep init
    rosdep update
    ```
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
    rosdep install -y -i --from-path thirdparty
    rosdep install -y -i --from-path src \
      --skip-keys "emcl2 rclpy_util kachaka_grpc_ros2_bridge kachaka_description kachaka_interfaces kachaka_shelf_description"
    ```
    　`rosdep update` に失敗する場合は，インターネット接続とプロキシ設定を確認してから再実行してください．`src` の依存関係解決時に上記の `skip-keys` 対象についてエラーが表示された場合は，指定漏れがないことを確認してください．

1. **`kachaka-api` のソースコードを置き換える**<br>
    　プロジェクト固有の TF ブリッジ実装を `kachaka-api` 側へコピーしてください．
    ```bash
    cp src/erasers_kachaka/customs/dynamic_tf_bridge.cpp \
      thirdparty/kachaka-api/ros2/kachaka_grpc_ros2_bridge/src/dynamic_tf_bridge.cpp
    ```

1. **Python 依存関係をインストールする**<br>
    　以下のコマンドを実行して Python の依存関係をインストールします．
    ```bash
    pip install -r src/erasers_kachaka/requirements.txt ipython
    ```

1. **ローカル環境の環境変数を設定する**<br>
    　[環境変数の設定方法](./setup_env.md) に記述されている環境変数が必要となります．以下の内容を `~/.bashrc` の末尾に追記してください．`KACHAKA_IP` は接続する Kachaka の IP アドレスに変更してください．
    ```bash
    export ROS_DOMAIN_ID=1
    export ROS_LOCALHOST_ONLY=0
    export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
    export KACHAKA_NAME="er_kachaka"
    export KACHAKA_IP=192.168.8.11
    export SHELF_TYPE=0
    export USE_RVIZ=True
    export USE_TOF_POINTS=True
    export GRPC_PORT=26400
    export API_GRPC_BRIDGE_SERVER_URI="${KACHAKA_IP}:${GRPC_PORT}"
    ```
    　設定を現在の端末へ反映するには，以下のコマンドを実行してください．
    ```bash
    source ~/.bashrc
    ```
1. **ワークスペースをビルドする**<br>
    　以下のコマンドを実行してワークスペースをビルドします．
    ```bash
    colcon build --symlink-install --packages-up-to erasers_kachaka_bringup
    ```
    　ビルドが完了したらセットアップ完了です．
    　ビルド後は以下のコマンドでワークスペースを通してください．
    ```bash
    source install/setup.bash
    ```
    　毎回実行する手間を省くため，このコマンドを `~/.bashrc` の末尾へ追記することを推奨します．`~/.bashrc` ではカレントディレクトリがワークスペースとは限らないため，ワークスペースの絶対パスを指定してください．例えば，ワークスペースが `~/kachaka_ws` にある場合は，次のように記述します．
    ```bash
    source ~/kachaka_ws/install/setup.bash
    ```

1. **動作確認**<br>
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

## トラブルシューティング

1. **ROS 2 のコマンドが見つからない**<br>
    　`ros2` や `colcon` が見つからない場合は，ROS 2 Humble のセットアップを通してください．
    ```bash
    source /opt/ros/humble/setup.bash
    ```

1. **Kachaka と通信できない**<br>
    　`KACHAKA_IP` が正しいことを確認し，以下のコマンドで Kachaka との疎通を確認してください．
    ```bash
    ping $KACHAKA_IP
    ```
