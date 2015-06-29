## ユーザーパネルのユーザー名表示部分を定義します。

### 依存モジュールの読み込み

	React = require 'react'
	ReactPropTypes = React.PropTypes

### クラスの定義

	UserItem = React.createClass
		propTypes :
			user : ReactPropTypes.object.isRequired
		render : ->
			user = @props.user
			<li>{user.user_name}@{user.comment}</li>

### モジュールの発行

	module.exports = UserItem
