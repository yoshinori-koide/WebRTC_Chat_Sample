# 永続化クラスの定義
本クラスではデータの保存ロジックを記述します。

## 依存モジュールのロード

```coffeescript

	AppDispatcher = require '../dispatcher/AppDispatcher'
	EventEmitter = require('events').EventEmitter
	ChatConstants = require '../constants/ChatConstants'
	assign = require 'object-assign'

```
## 内部変数定義
このセクションではモジュール内で使用される変数を宣言します。

### 本アプリで使用するEventEmmiter用名前空間ラベル

```coffeescript

	EVENT_LABEL = 'chat'

```

* localStorage のプロトタイプに json で取得メソッドを追加します。

```coffeescript

	Storage::getJSON = (key) ->
		JSON.parse localStorage.getItem key

```

## 内部関数
このセクションではモジュール内で使用される内部関数を宣言します。

データ読み書き用の関数を定義します。

* マイプロフィールデータの保存

```coffeescript

	saveMyProf = (id,name,comment) ->
		prof =
			user_id : id
			user_name : name
			comment : comment
		localStorage.setItem 'me', JSON.stringify(prof)

```

* 他ユーザプロフィールの保存

```coffeescript

	saveProf = (id,name,comment) ->
		prof =
			user_id : id
			user_name : name
			comment : comment
		users = localStorage.getJSON('users') ?
			list: {}
		users.list[id] = prof
		localStorage.setItem 'users' , JSON.stringify(users)

```

* チャットメッセージの保存

```coffeescript

	saveChat = (user_id, text, date) ->
		msg =
			user_id : user_id
			text : text
			date : date
		chats = localStorage.getJSON('chats') ? {messages : []}
		chats.messages.push msg
		localStorage.setItem 'chats', JSON.stringify(chats)

```
## モジュールの定義

```coffeescript

	ChatStore = assign {}, EventEmitter.prototype,
		isReadyProfile : ->
			if localStorage.getJSON('me') then true else false
		getMyProfile : ->
			localStorage.getJSON 'me'
		getAllUsers: ()->
			(localStorage.getJSON 'users')?.list
		getAllMsgs: ()->
			(localStorage.getJSON 'chats')?.messages
		emitChange: ->
			@emit EVENT_LABEL
		addChangeListener: (callback)->
			@on EVENT_LABEL, callback
		removeChangeListener: (callback)->
			@removeListener EVENT_LABEL, callback

```
## ディスパッチャへの登録

```coffeescript

	AppDispatcher.register (action)->
		switch action.actionType
			when ChatConstants.ACT_SAVE_MY_PROF
				me_id = action.user_id.trim()
				me_display = action.display.trim()
				me_message = action.message.trim()
				if me_display isnt ''
					saveMyProf me_id,me_display,me_message
					ChatStore.emitChange()
			when ChatConstants.ACT_ADD_USER_PROF
				user_id = action.user_id.trim()
				display = action.display.trim()
				message = action.message.trim()
				if display isnt ''
					saveProf user_id,display,message
					ChatStore.emitChange()
			when ChatConstants.ACT_SAVE_MSG
				user_id = action.user_id.trim()
				message = action.message.trim()
				if user_id isnt ''
					saveChat user_id,message, action.time
					ChatStore.emitChange()

```
## モジュールの発行

```coffeescript

	module.exports = ChatStore

```
