# アクションの定義

## 依存モジュールのロード

	AppDispatcher = require '../dispatcher/AppDispatcher'
	ChatConstants = require '../constants/ChatConstants'

## アクション発行クラスの定義

	ChatActions =
		saveProf : (id, display, message)->
			AppDispatcher.dispatch
				actionType: ChatConstants.ACT_SAVE_MY_PROF
				user_id : id
				display : display
				message : message
		saveUser : (id, display, message)->
			AppDispatcher.dispatch
				actionType: ChatConstants.ACT_ADD_USER_PROF
				user_id : id
				display : display
				message : message
		saveChat : (user_id,message,time) ->
			AppDispatcher.dispatch
				actionType: ChatConstants.ACT_SAVE_MSG
				user_id : user_id
				message : message
				time : time

	module.exports = ChatActions
