## チャットメッセージアイテムの定義
ここではユーザー名と発言内容の表示をおこないます。

### 依存モジュールの読み込み

	React = require 'react'
	ReactPropTypes = React.PropTypes

	ChatItem = React.createClass
		propTypes :
			chat : ReactPropTypes.object.isRequired
		render : ->
			chat = @props.chat
			<li>{chat.user_id} - {chat.text}</li>

	module.exports = ChatItem
