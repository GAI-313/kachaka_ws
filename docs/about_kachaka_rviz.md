# Kachaka 用 RViz の表示項目

`src/erasers_kachaka/erasers_kachaka_bringup/rviz/erasers_kachaka.rviz` の設定を基に、RViz 起動時に登録されている表示項目を以下に示します。

| 表示項目 | 内容 |
| --- | --- |
| Grid | XY 平面上にグリッドを表示します。 |
| Kachaka | Kachaka のロボットモデルを表示します。 |
| LiDAR | LiDAR のスキャン結果を表示します。 |
| Front Camera | 前方カメラの映像を表示します。 |
| Object Detect Image | 物体検出用の画像を表示します。 |
| Back Camera | 後方カメラの映像を表示します。 |
| ToF Camera | ToF カメラの映像を表示します。 |
| ToF Points | ToF カメラの点群を表示します。 |
| Map | 作成済みの地図を表示します。 |
| Local CostMap | ローカルコストマップを表示します。 |
| Global CostMap | グローバルコストマップを表示します。 |
| Goal Pose | 設定されたゴール姿勢を表示します。 |
| TF | TF（座標フレーム間の変換）を表示します。 |
| Path | ナビゲーション経路を表示します。 |
| Kachaka Detect Object Pose | 検出した物体の姿勢を表示します。 |
| Kachaka Detect Object Marker | 検出した物体のマーカーを表示します。 |

なお、`ToF Camera` と `ToF Points` は設定上は登録されていますが、起動時は非表示です。必要に応じて RViz の Displays パネルから有効化できます。
