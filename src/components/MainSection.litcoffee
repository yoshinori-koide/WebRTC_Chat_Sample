## チャットメインウインドウクラスの定義
チャットの表示と入力を行うメインウィンドウです。

### 依存モジュールの読み込み

	React = require 'react'
	ReactPropTypes = React.PropTypes
	ChatStore = require '../store/ChatStore'
	ChatItem = require './ChatItem'
	ChatInput = require './ChatInput'

### クラスの定義

	MainSection = React.createClass

上位クラスから`ChatComm`のインスタンスを受け取ります。
これにより、Peerが複数作られないようにしています。

		propTypes :
			chatComm : ReactPropTypes.object.isRequired

発言リストを状態として持ちます。

		getInitialState: ->
			allChat : ChatStore.getAllMsgs()

アプリ全体のデータ変更イベントを受け取るリスナーを登録します。

		componentDidMount: ->
			ChatStore.addChangeListener @_onchange
		componentWillUnmount: ->
			ChatStore.removeChangeListener @_onchange

画面表示ロジックの実装

		render: ->
			allChat = @state.allChat
			chatlist = for index of allChat
				<ChatItem key={index} chat={allChat[index]} />

			<section id="main">
				<p>チャットログ</p>
				<ul>
					{chatlist}
				</ul>
				<ChatInput broadcastFunc={@props.chatComm.chatBroadcast}/>
			</section>

データ変更イベントリスナー

発言リストの再取得と`React`への通知を行います。

		_onchange : ->
			@setState
				allChat : ChatStore.getAllMsgs()

### モジュールの発行

	module.exports = MainSection
