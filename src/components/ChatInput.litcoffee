## チャット発言入力テキストボックスの定義
チャットで送信するテキストの入力ボックスとメッセージの発言時の処理を記述します。

ただし、チャットメッセージの送信には上位で保持している`Peer`のインスタンスを利用するため
モジュールのプロパティとして`broadcastFunc`を受け取るようにしています。

### 依存モジュールの読み込み

	React = require 'react'
	ReactPropTypes = React.PropTypes
	ChatActions = require '../actions/ChatActions'
	ChatStore = require '../store/ChatStore'

### 内部変数
発信者のユーザーIDを保持します。`ChatStore`から直接取得しています。

	user_id = ChatStore.getMyProfile()?.user_id

### クラスの定義

	ChatInput = React.createClass

`ChatInput`クラスのプロパティ宣言です。
チャット送信用の関数を受け取ります。

		propTypes :
			broadcastFunc : ReactPropTypes.func.isRequired

Reactに対して初期状態の宣言をします。

ここでは入力されたテキストデータ制御のために`value`を宣言します。

		getInitialState: ->
			value : ''

`ChatStore`のデータ変更イベントを受け取るためにリスナーを宣言します。

		componentDidMount: ->
			ChatStore.addChangeListener @_onStoreChange
		componentWillUnmount: ->
			ChatStore.removeChangeListener @_onStoreChange

表示ロジックを実装します。
テキストボックスと送信ボタンを配置します。

		render : ->
			<p className="ChatInput">
				{'メッセージ :'}
				<input
					onChange={@_onChange}
					value={@state.value}
					autoFocus={true} />
				<button className="send" onClick={@_onSendClick} >{'送信'}</button>
			</p>

テキストボックスの値が変更された時のイベントハンドラ

Reactに対してvalueの変更を通知します。

		_onChange : (evt) ->
			this.setState
				value: evt.target.value

送信ボタンクリック時のイベントハンドラ

		_onSendClick : (evt)->

アクションを通じて入力されたテキストを保存します。

			ChatActions.saveChat user_id, @state.value, new Date()

`broadcastFunc`が正しいFunctionオブジェクトであれば処理を実行します。

			@props.broadcastFunc? @state.value

ついでにテキストボックスの値を空白にします。

			this.setState
				value: ''

`ChatStore`の値変更通知を受けるイベントハンドラ

ユーザーIDを再取得します。

		_onStoreChange :->
			user_id = ChatStore.getMyProfile()?.user_id

### モジュールの発行

	module.exports = ChatInput
