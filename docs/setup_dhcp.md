# DHCP サーバーを使い Kachaka と有線接続する方法

1. **`isc-dhcp-server` をインストールする**<br>
    　以下のコマンドを実行して `isc-dhcp-server` をインストールしてください．
    ```bash
    sudo apt update && sudo apt -y install isc-dhcp-server
    ```

1. **`/etc/dhcp/dhcpd.conf` を編集する**<br>
    　`/etc/dhcp/dhcpd.conf` を開き，以下のコンフィグをファイル末尾に追記してください．
    ```
    subnet 192.168.0.0 netmask 255.255.255.0 {
        range 192.168.0.100 192.168.0.200;
        option routers 192.168.0.1;
        option domain-name-servers 8.8.8.8, 8.8.4.4;
        option broadcast-address 192.168.0.255;
    }
    ```

1. **Kachaka と有線接続する**<br>
    　Kachaka と Ethernet ケーブルを用いて有線接続してください．

1. **接続元の NIC を特定する**<br>
    　Kachaka と有線接続している `NIC` （Network Interface Card）の名前を特定します．以下のコマンドを実行して特定します．
    ```bash
    ip a
    ```
    　もし，`eth0` という NIC に接続する場合，以下のコマンドを実行して変数 `NIC` に NIC 名を代入してください．
    ```bash
    NIC=eth0
    ```
    　確認のため変数 `NIC` に NIC 名が代入されているか以下のコマンドで確認してください．
    ```bash
    echo $NIC
    ```

1. **コネクションプロファイルの作成**<br>
    　以下のコマンドを実行して Kachaka と有線接続するためのプロファイルを新規作成します．
    ```bash
    sudo nmcli connection add con-name kachaka ifname $NIC ipv4.method manual ipv4.addresses 192.168.0.1/24 type ethernet
    ```

1. **Dispatcher スクリプトを作成する**<br>
    　`/etc/NetworkManager/dispatcher.d/99-kachaka.sh` を管理者権限で作成し，以下のスクリプトを追記してください．
    ```bash
    #!/bin/bash
    ACTION=$2

    if [ "$CONNECTION_ID" = "kachaka" ] && [ "$2" = "up" ]; then
        systemctl restart isc-dhcp-server.service
        if [ $? -ne 0 ]; then
            nmcli con up 'Wired connection 1'
        fi
    fi
    ```
    　作成が完了したら次のコマンドを実行して作成したファイルに適切な権限を与えます．
    ```bash
    sudo chown root:root /etc/NetworkManager/dispatcher.d/99-kachaka.sh 
    ```
    ```bash
    sudo chmod 755 /etc/NetworkManager/dispatcher.d/99-kachaka.sh 
    ```

1. **`/etc/default/isc-dhcp-server` を編集する**<br>
    　`/etc/default/isc-dhcp-server` を開き，`INTERFACESv4=""` に接続元の NIC 名を追記してください．以下の例は NIC が `eth0` の場合の変更です．
    ```diff
    - INTERFACESv4=""
    + INTERFACESv4="eth0"
    ```

1. **`isc-dhcp-server` サービスを再起動する**<br>
    　以下のコマンドを実行して `isc-dhcp-server` を再起動します．
    ```bash
    sudo systemctl restart isc-dhcp-server
    ```

1. **Kachaka の IP アドレスを取得する**<br>
    　以下のコマンドを実行して `isc-dhcp-server` の起動ログを確認し，Kachaka の IP アドレスを取得します．
    ```bash
    sudo systemctl status isc-dhcp-server
    ```
    　このとき，以下のログが表示されていれば Kachaka の有線 IP アドレスの取得は成功です．
    ```
    ...
    dhcpd[...]: DHCPACK on 192.168.0.100 to XX:XX:XX... (kachaka-...)
    ```
    本ドキュメントに従い作業をしたならば，初回接続時の Kachaka の IP アドレスは `192.168.0.100` となります．<br>
    　上記のコマンドのログで取得した Kachaka の IP アドレスが正常に疎通するか `ping` コマンドで確認すると良いでしょう．
    ```bash
    ping 192.168.0.100
    ```
