# 環境変数の設定方法

　Kachaka と通信するために以下の環境変数が必要です．これらの環境変数は [`docker_env`](/docker_env) または `~/.bashrc` などに記述されている必要があります．

## ROS 設定

| 環境変数 | 設定値 | 意訳・用途 |
| --- | --- | --- |
| `ROS_DOMAIN_ID` | `1` | ROS 2 の通信グループ番号です．同じ番号のノード同士だけが通信します． |
| `ROS_LOCALHOST_ONLY` | `0` | 通信範囲の制限です．`0` は localhost 限定ではなく，ネットワーク上の機器とも通信します． |
| `RMW_IMPLEMENTATION` | `rmw_cyclonedds_cpp` | ROS 2 が使用する通信ミドルウェアとして Cyclone DDS を指定します． |

## Kachaka 接続設定

| 環境変数 | 設定値 | 意訳・用途 |
| --- | --- | --- |
| `KACHAKA_NAME` | `er_kachaka` | 接続する Kachaka の名前（ROS2 名前空間）です． |
| `KACHAKA_IP` | `192.168.195.189` | 接続する Kachaka の IP アドレスです． |

## 起動時の引数

| 環境変数 | 設定値 | 意訳・用途 |
| --- | --- | --- |
| `SHELF_TYPE` | `0` | 搭載するシェルフの種類を指定します．<br>- `0`：シェルフなし<br>- `1`：Kachaka ベースシェルフ<br>- `2`：2段シェルフ<br>- `3`：3段シェルフです． |
| `USE_RVIZ` | `True` | RViz を起動するかどうかです．`True` で起動します． |
| `USE_TOF_POINTS` | `True` | ToF センサーの点群を使用するかどうかです．`True` で使用します． |

## 変更不要な設定

| 環境変数 | 設定値 | 意訳・用途 |
| --- | --- | --- |
| `GRPC_PORT` | `26400` | Kachaka との gRPC 通信に使用するポート番号です．通常は変更しません． |
