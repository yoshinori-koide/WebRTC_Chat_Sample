# チャットメインウインドウクラスの定義

## 依存モジュールの読み込み

	React = require 'react'
	ReactPropTypes = React.PropTypes
	ChatStore = require '../store/ChatStore'
	ChatItem = require './ChatItem'
	ChatInput = require './ChatInput'

## クラスの定義

	MainSection = React.createClass
		propTypes :
			chatComm : ReactPropTypes.object.isRequired
		getInitialState: ->
			allChat : ChatStore.getAllMsgs()
		componentDidMount: ->
			ChatStore.addChangeListener @_onchange
		componentWillUnmount: ->
			ChatStore.removeChangeListener @_onchange

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

		_onchange : ->
			@setState
				allChat : ChatStore.getAllMsgs()

## モジュールの発行

	module.exports = MainSection
