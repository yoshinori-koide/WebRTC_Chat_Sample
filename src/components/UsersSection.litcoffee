# ログインユーザー一覧画面

## 依存モジュールの読み込み

	React = require 'react'
	ChatStore = require '../store/ChatStore'
	UserItem = require './UserItem'

## Reactクラスの定義

	UsersSection = React.createClass
		getInitialState : ->
			users: ChatStore.getAllUsers()

		componentDidMount: ->
			ChatStore.addChangeListener @_onchange
		componentWillUnmount: ->
			ChatStore.removeChangeListener @_onchange

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

		_onchange : ->
			@setState
				users: ChatStore.getAllUsers()

## モジュールの発行

	module.exports = UsersSection
