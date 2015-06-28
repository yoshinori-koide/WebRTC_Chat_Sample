# チャット発言窓クラスの定義

## 依存モジュールの読み込み

	React = require 'react'
	ReactPropTypes = React.PropTypes
	ChatActions = require '../actions/ChatActions'
	ChatStore = require '../store/ChatStore'

## 内部変数

	user_id = ChatStore.getMyProfile()?.user_id

## クラスの定義

	ChatInput = React.createClass
		propTypes :
			broadcastFunc : ReactPropTypes.func.isRequired
		getInitialState: ->
			value : ''
		componentDidMount: ->
			ChatStore.addChangeListener @_onStoreChange
		componentWillUnmount: ->
			ChatStore.removeChangeListener @_onStoreChange
		render : ->
			<p className="ChatInput">
				{'メッセージ :'}
				<input
					onChange={@_onChange}
					value={@state.value}
					autoFocus={true} />
				<button className="send" onClick={@_onSendClick} >{'送信'}</button>
			</p>
		_onChange : (evt) ->
			this.setState
				value: evt.target.value
		_onSendClick : (evt)->
			ChatActions.saveChat user_id, @state.value, new Date()
			@props.broadcastFunc? @state.value
			this.setState
				value: ''
		_onStoreChange :->
			user_id = ChatStore.getMyProfile()?.user_id

	module.exports = ChatInput
