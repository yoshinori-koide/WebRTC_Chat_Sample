# アプリケーションのメインクラス定義

## 依存モジュールの読み込み

	React = require 'react'
	ChatStore = require '../store/ChatStore'
	EditProf = require './EditProf'
	MainSection = require './MainSection'
	UsersSection = require './UsersSection'
	ChatComm = require '../webrtc/ChatComm'

## チャット用接続の開始

	ChatComm.start()

## メインのReactモジュール定義

	ChatApp = React.createClass
		getInitialState: ->
			readyChat : ChatStore.isReadyProfile()

		componentDidMount: ->
			ChatStore.addChangeListener @_onchange
		componentWillUnmount: ->
			ChatStore.removeChangeListener @_onchange

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

		_onchange : ->
			@setState
				readyChat : ChatStore.isReadyProfile()

	module.exports = ChatApp
