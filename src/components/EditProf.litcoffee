## プロフィールの編集画面
プロフィールでは識別用のユーザーID、表示用のユーザー名、一言メッセージを保存できます。
ユーザー名と一言メッセージはユーザー一覧に表示されます。

### 依存モジュールの読み込み

	React = require 'react'
	ReactPropTypes = React.PropTypes
	ChatActions = require '../actions/ChatActions'

### プロフィール編集画面モジュールの定義

	EditProf = React.createClass

プロパティとしてプロフィールオブジェクトを受け取ります。

		propTypes :
			prof: ReactPropTypes.object.isRequired

初期状態として3つのフィールドを個別にもたせておきます。（オブジェクト丸ごとだと中身の値をチェックしてくれるかどうか不安なので。）

		getInitialState : ->
			user_id: if @props.prof then @props.prof.user_id else ''
			display: if @props.prof then @props.prof.display else ''
			message: if @props.prof then @props.prof.message else ''

画面描画ロジック

		render : ->
			<div>
				<p>プロフィールの編集</p>
				<p>
					{'ユーザーID :'}
					<input
						value={@state.user_id}
						onChange={@_onUserIdChange}
						autoFocus={true} />
				</p>
				<p>
					{'表示名 :'}
					<input
						onChange={@_onDisplayChange}
						value={@state.display} />
				</p>
				<p>
					{'メッセージ :'}
					<input
						onChange={@_onMessageChange}
						value={@state.message} />
				</p>
				<button className="send" onClick={@_save}>{"保存"}</button>
			</div>

各テキストボックスの値変更イベントハンドラ

テキストボックスの`value`が変更されたら`React`に通知します。

		_onUserIdChange : (evt)->
			this.setState
				user_id: evt.target.value
		_onDisplayChange : (evt)->
			this.setState
				display: evt.target.value
		_onMessageChange : (evt)->
			this.setState
				message: evt.target.value

保存ボタンクリック時のイベントハンドラ

アクション経由でプロフィール情報を保存します。

		_save : ->
			ChatActions.saveProf @state.user_id, @state.display, @state.message

### モジュールの発行

	module.exports = EditProf
