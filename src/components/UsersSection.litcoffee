## ログインユーザー一覧画面

オンラインになったユーザーの一覧を表示します。
ただし、現状ではオフライン時にユーザー情報の削除やオンラインフラグの制御などしていないのでリアルタイムでオンラインのユーザーを表示しているわけではありません。

### 依存モジュールの読み込み

	React = require 'react'
	ChatStore = require '../store/ChatStore'
	UserItem = require './UserItem'

### Reactクラスの定義

	UsersSection = React.createClass

ユーザーのリストを保持します。

		getInitialState : ->
			users: ChatStore.getAllUsers()

データ変更イベントを受け取るリスナーを登録します。

		componentDidMount: ->
			ChatStore.addChangeListener @_onchange
		componentWillUnmount: ->
			ChatStore.removeChangeListener @_onchange

描画ロジックの実装

ユーザーがいなければ丸ごとスキップします。

		render : ->
			return null if not @state.users or Object.keys(@state.users).length < 1
			allUsers = @state.users
			users = for key of allUsers
				<UserItem key={key} user={allUsers[key]}/>
			<section className="UsersSection">
				<p>ユーザーリスト</p>
				<ul>
					{users}
				</ul>
			</section>

イベントハンドラの実装

ユーザーリストの再取得と`React`への通知をおこないます。

		_onchange : ->
			@setState
				users: ChatStore.getAllUsers()

### モジュールの発行

	module.exports = UsersSection
