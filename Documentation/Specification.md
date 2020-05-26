## 仕様

### メイン画面

* タブ構成にし、2つのタブを表示する
 * 一つのタブはGitHubのSearch APIからキーワードを入力しユーザ一覧を取得して表示する
 * もう一つのタブはお気に入り保存されたローカルデータからキーワードを入力し該当したユーザ一覧を表示する

### APIユーザ一覧画面

|API初回表示|APIユーザ一覧|
|:-:|:-:|
|![API-initial](https://github.com/matsuda/MyBridgeSample/blob/master/Documentation/Images/1.API-initial.png?raw=true "API初回表示")|![API-user-list](https://github.com/matsuda/MyBridgeSample/blob/master/Documentation/Images/2.API-user-list.png?raw=true "APIユーザ一覧")|

* 初回表示にユーザに機能の説明を表示する
* 検索フォームを表示し、キーワードを入力するとGitHubのSearch APIをインクリメンタルサーチをしてユーザ一覧を表示する
	* ユーザ名でソートしイニシャルでセクションを分け、インデックスを表示する
* ユーザを選択するとお気に入り登録し、お気に入りアイコンをアクティブにする
* お気に入り追加されているユーザを選択するとお気に入りから削除され、お気に入りアイコンを非アクティブにする
* お気に入り状態が変更されたら、お気に入りユーザ一覧画面にも即座に反映する

### お気に入りユーザ一覧画面

|お気に入り初回表示|お気に入りユーザ一覧|
|:-:|:-:|
|![Local-initial](https://github.com/matsuda/MyBridgeSample/blob/master/Documentation/Images/3.Local-initial.png?raw=true "お気に入り初回表示")|![Locla-user-list](https://github.com/matsuda/MyBridgeSample/blob/master/Documentation/Images/4.Locla-user-list.png?raw=true "お気に入りユーザ一覧")|

* 初回表示にユーザに機能の説明を表示する
* 検索フォームを表示し、キーワードを入力するとローカルに保存してあるお気に入りデータからインクリメンタルサーチをしてユーザ一覧を表示する
	* ユーザ名でソートしイニシャルでセクションを分け、インデックスを表示する
* ユーザを選択するとお気に入りから削除され、画面からも削除される
* お気に入りから削除されたら、APIユーザ一覧画面にも即座に反映する
