# チャット通信モジュール
WebRTCによる(擬似)ブラウザ間P2Pによりチャットを行います

WebRTCによる擬似P2Pには2段階の接続が必要です。

1. 中継サーバー(Skyway)に接続する。new Peerした時点でこれは行われる

2. ブラウザ同士でハンドシェイク ... 特定のpeeridをopenして取得したconnectionオブジェクトを使用して相互データ通信を行う。
API上、接続の方向性はない。
connectionは基本的に非同期で通信できるが、シーケンスが重なるとプログラム的に制御がめんどいので、必要な時に都度、openし、データ通信が終わったらcloseする、とする。

ただし、本プログラムではpeerid（接続オブジェクト）に方向性をもたせて、将来的な優先順位の決定が可能なように実装している。

## 依存モジュールのロード
```coffeescript

	ChatConstants = require '../constants/ChatConstants'
	ChatActions = require '../actions/ChatActions'
	assign = require 'object-assign'

```

## 内部変数定義
このセクションではモジュール内で使用される変数を宣言します。

```coffeescript

	API_KEY = '5129452e-02b4-43c2-8825-b17ea7da69a4'
	MASTER_LABEL = 'sample_chat'

```

### データ通信ラベル
データ通信時に使用するラベル

* プロフィールデータの送信

	PEER_SEND_PROF = 'SEND_PROF'

* チャットメッセージの1件送信

	PEER_SEND_CHAT = 'SEND_CHAT'

## チャットモジュールの内部オブジェクト定義

今回の接続は方向性を持ちます。ただし接続を選択するロジックは未実装です。

### 状態の保持
```coffeescript

	netStatus =

```
* こちらからのリクエストでつないだ接続
```coffeescript

		connectorConnection : {}

```
* 相手からのリクエストで繋がれた接続
```coffeescript

		connectedConnection : {}

```
* 自分のプロフィールなどを保持
```coffeescript

		meObj : localStorage.getJSON 'me'

```

* データ着信時のコールバック

データの着信には方向性を無視します。
```coffeescript

	peerCallback =
		TYPE_SEND_PROF : (d)->
			ChatActions.saveUser d.user_id, d.user_name, d.comment
			true

		TYPE_REQ_PROF : (d,con)->
			ChatActions.saveUser d.user_id, d.user_name, d.comment
			con.send assign {}, netStatus.meObj,
				type : 'TYPE_SEND_PROF'
			true

```
チャットメッセージの着信にはアクションを使用して全体にメッセージの追加を通知します。
```coffeescript

		TYPE_MSG : (d) ->
			ChatActions.saveChat d.user_id, d.text, d.time
			true

```
## メインオブジェクトの定義
```coffeescript

	ChatComm =
		peer : null
		start : ->
			@peer = new Peer
				key: API_KEY
				debug: 3
				logFunction : ->
					copy = Array::slice.call(arguments).join(' ')
					console.log copy

```
instanceの生成に失敗したら終了
```coffeescript

			if not @peer?
				console.log "Peer の生成に失敗！"
				return

```
Windowのアンロード時に破棄
```coffeescript

			window.onunload = window.onbeforeunload = (e)->
				@peer?.destroy if not @peer?.destroyed

```
peerオブジェクトのイベントハンドラ設定

* Peer接続開始時のイベント
```coffeescript

			@peer.on 'open', ->
				console.log "Peer の接続 Open"

```

* 他からの着信を受けるイベント
接続が相手からのリクエストにより開始した場合にこのイベントが呼ばれます。

con:相手とのConnectionオブジェクト

```coffeescript

			.on 'connection', (con)->

```

接続のラベルがMASTER_LABELでなければ切断
```coffeescript

				return if con.label isnt MASTER_LABEL

```

プロフィール未登録の場合は切断
```coffeescript

				return if not netStatus.meObj

```
connection へのイベントハンドラ定義
```coffeescript

				con.on 'open', ->

```
* 相手との接続確立 … 接続オブジェクトを保存

現状では接続保持のコストは無視してすべての"メンバー"との接続を維持する。
将来的には最低限の接続数だけでデータ保持できるように調整が必要。
```coffeescript

					netStatus.connectedConnection[@peer] = this
					console.log @peer + ' opened.'

```
* 相手との接続が切断されたイベント … インスタンスを削除
```coffeescript

				.on 'close', ()->
					console.log @peer + ' has left.'
					delete netStatus.connectedConnection[@peer]

```

* 接続エラーイベント … インスタンスを削除
```coffeescript

				.on 'error', (err)->
					console.log err
					delete netStatus.connectedConnection[@peer]

```

* データ着信イベント … コールバックに引き渡し
```coffeescript

				.on 'data', (data)->
					peerCallback[data.type]?(data, this)

```
* peer のエラーイベント … 保持しているconnectionの開放
```coffeescript

			.on "error", (err)->
				console.log err

```
* peer の切断
```coffeescript

			.on "close", ->
				console.log "close peer."

```
* オンラインの通知
```coffeescript

		checkIn : (peerid)->

```
自分自身か、既知のpeeridについては接続しない
```coffeescript

			return if peerid is @peer.id or netStatus.connectedConnection[peerid]? or netStatus.connectorConnection[peerid]?

			@peer.connect peerid,
				label: MASTER_LABEL

```

通信中のデータ形式はJSONとします。

```coffeescript

				serialization: 'json'
				metadata:
					userId : netStatus.meObj.user_id
			.on "open", ()->

				netStatus.connectorConnection[@peer] = this
```
自身のプロフィールを送りつつ、相手にプロフィールを送ってもらう要求を送る
```coffeescript

				@send assign {}, netStatus.meObj,
					type: 'TYPE_REQ_PROF'

```
// 接続が切れた。
```coffeescript

			.on "close", ()->
				console.log @peer + ' has left.'
				delete netStatus.connectorConnection[@peer]
```
// 接続エラー発生
```coffeescript

			.on "error", ()->
				console.log @peer + ' has error.'
				delete netStatus.connectorConnection[@peer]

```
// データ受信イベント
// コールバックに引き渡し。戻り値がtrueでなければ切断
```coffeescript

			.on "data", (data)->
				if not peerCallback[data.type]?(data, this)
					@close()

```
// 接続の継承要求
他Peerからpeeridを教えてもらいます。
```coffeescript

		requestPeer : ->
			for con in netStatus.connectorConnection
				con.send
					type : 'TYPE_GET_PEER'

```
// オンライン時のブロードキャスト
他Peerとの接続を貼りまくります。
```coffeescript

		onlineBroadcast : ->
			netStatus.meObj = localStorage.getJSON 'me' if not netStatus.meObj
			if @peer && not @peer.disconnected
				@peer.listAllPeers (list)->
					list = eval(list)
					ChatComm.checkIn peerid for peerid in list

```
// "チャット"のブロードキャスト
ここではブロードキャストのみを行い、データ保存、画面への反映などは行いません。
```coffeescript

		chatBroadcast : (text) ->
			chat_data =
				type : 'TYPE_MSG'
				user_id : netStatus.meObj.user_id,
				text : text,
				time : new Date()

```
// 現状では前後1つのPeerにのみ送信とします。
リレーのロジックは未実装です。
```coffeescript

			sendFunc = (cons) ->
				if Object.keys(cons).length > 0
					cons[Object.keys(cons)[0]]?.send chat_data

			sendFunc(netStatus.connectorConnection)
			sendFunc(netStatus.connectedConnection)

```
## オブジェクトの発行
```coffeescript

	module.exports = ChatComm

```
