## Architecture

MVVM + 簡易Clean Architecutreを採用

* RxSwiftによりviewバインディングを適用。
* MVVMのModelをUseCaseとRepositoryに分解。
* インターフェース（Protocol）を定義し各レイヤーの抽象化を高め、各レイヤー間を疎結合にする。
* テスト時にはモックで差し替え。

![MVVM+MVVM_CleanArchitecture](https://github.com/matsuda/MyBridgeSample/blob/master/Documentation/Images/MVVM_CleanArchitecture.png?raw=true)


### 役割

#### View

* 見た目を描画

#### VIewController

* Viewを表示
* ユーザーイベントをVMへ依頼
* UseCaseから流れてきたViewModelが保持しているデータとViewをバインディング

#### ViewModel

* VC経由で受け取ったユーザーイベントをUseCaseへ処理を依頼する
* UseCaseを通して取得したデータを保持する
* Viewの状態を保持する

#### UseCase

* ビジネスロジックを実装
* VMから依頼された処理を適切なRepositoryを通してCRUD処理を行う。

#### Repository

* データのCRUD処理