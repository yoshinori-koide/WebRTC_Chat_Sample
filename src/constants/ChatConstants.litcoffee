# 状態ラベル定義
本アプリケーションにおける状態のラベルを列挙・定義します。

## 依存モジュールの読み込み

	keyMirror = require 'keymirror'

## 定数のオブジェクトの発行と定数定義

トップオブジェクトの定義・発行

	module.exports = keyMirror

### アクションラベル

アプリケーションアクションの定義(Reactに通知する用)

* マイプロフィールの保存

		ACT_SAVE_MY_PROF: null

* 他ユーザープロフィールの追加

		ACT_ADD_USER_PROF: null

* メッセージの作成

		ACT_SAVE_MSG: null

### 画面ラベル

* タイトル表示

		VIEW_START : null

* チャット画面

		VIEW_CHAT : null

* プロフィール確認画面

		VIEW_PROF : null

* プロフィール編集画面

		VIEW_EDIT_PROF:null

### アプリ状態ラベル

* プロフィール記入フラグ

		ST_NO_PROF: null
		ST_PROF_READY :null

* オンライン状態

		ST_ON_LINE :null
		ST_OFF_LINE:null
