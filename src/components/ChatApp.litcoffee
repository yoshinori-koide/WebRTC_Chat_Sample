## アプリケーションのメインクラス定義

### 依存モジュールの読み込み
- Reactをはじめ、画面構成に必要なモジュールを読み込みます。
```coffeescript

	React = require 'react'
	ChatStore = require '../store/ChatStore'
	EditProf = require './EditProf'
	MainSection = require './MainSection'
	UsersSection = require './UsersSection'
	ChatComm = require '../webrtc/ChatComm'
```

### チャット用接続の開始
- WebRTCの接続の起点となるPeerオブジェクトはシングルトンで持つべきですので、
本モジュールでインスタンスを生成し、`ChatComm`の唯一のインスタンスを保持します。
```coffeescript

	ChatComm.start()
```

### メインのReactモジュール定義

	ChatApp = React.createClass

Reactに対して初期状態の宣言をします。

ここではプロフィールが未入力の際にプロフィール入力画面を表示させるため
プロフィール存在チェックの結果を`state.readyChat`に保持しています。

		getInitialState: ->
			readyChat : ChatStore.isReadyProfile()

`ChatStore`の値を取得するモジュールは変更のイベントを受け取るべきです。

ここでは`ChatStore`の変更イベントを受け取るリスナーを設定します。
`ChatStore`でのデータ変更があった場合、以下のメソッドが呼び出されます。

		componentDidMount: ->
			ChatStore.addChangeListener @_onchange
		componentWillUnmount: ->
			ChatStore.removeChangeListener @_onchange

表示ロジックの定義 ...
プロフィール未入力の場合は、チャット画面を表示せずにプロフィール入力画面を表示します。
プロフィールの入力が完了した後、オンラインになった通知をします。

		render :->
			renderMain = if not this.state.readyChat
				<EditProf prof={ChatStore.getMyProfile()}/>
			else
				<div>
					<UsersSection />
					<MainSection chatComm={ChatComm}/>
				</div>

			ChatComm.onlineBroadcast() if this.state.readyChat

			renderMain

データ変更イベントの受け取り`ChatStore#isReadyProfile`でプロフィール存在チェックをおこない、
結果を受け取ります。
`React`は非常に賢いので`setState`しても実際に値が変わっていなければ`render`されません。

		_onchange : ->
			@setState
				readyChat : ChatStore.isReadyProfile()

### モジュールの発行

	module.exports = ChatApp
