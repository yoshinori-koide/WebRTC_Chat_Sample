# プロフィールの編集画面

## 依存モジュールの読み込み

	React = require 'react'
	ReactPropTypes = React.PropTypes
	ChatActions = require '../actions/ChatActions'

	EditProf = React.createClass
		propTypes :
			prof: ReactPropTypes.object.isRequired

		getInitialState : ->
			user_id: if @props.prof then @props.prof.user_id else ''
			display: if @props.prof then @props.prof.display else ''
			message: if @props.prof then @props.prof.message else ''

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

		_onUserIdChange : (evt)->
			this.setState
				user_id: evt.target.value
		_onDisplayChange : (evt)->
			this.setState
				display: evt.target.value
		_onMessageChange : (evt)->
			this.setState
				message: evt.target.value
		_save : ->
			ChatActions.saveProf @state.user_id, @state.display, @state.message

## モジュールの発行

	module.exports = EditProf
